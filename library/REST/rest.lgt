:- object(rest).

		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	Start the REST-server
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */	
		:- public(start_server/1).
		start_server(Port) :-
	        {thread_httpd:http_server(http_dispatch:http_dispatch, [port(Port)])},
			{http_dispatch:http_handler(/, rest_proxy_module:distributor, [prefix])}.
	
	
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	Stop the REST-server
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */		
		:- public(stop_server/1).
		stop_server(Port) :-
	        {thread_httpd:http_stop_server(Port, [])}.	
		
		
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	Distributes the queries to the specific predicates
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */									
		:- public(distributor/1).
			distributor(Request) :-
				memberchk(method(post), Request),
			
				memberchk(request_uri(PathModelID), Request),

				% matching / and fork to predicate 'say_hi'
				(	PathModelID = '/' ->
					say_hi(Request)
					;
					true
				),
				% matching /models and fork to predicate 'available_process_models'
				(	PathModelID = '/models' ->
					available_process_models(Request)
					;
					true
				),
				% matching /models/.../initial_state and fork to predicate 'initial_state/2'
				(	atomic_list_concat(['', 'models', ModelID, Query], '/', PathModelID) ->
					(	Query = initial_state ->
						initial_state(Request, ModelID)
						;
						true
					)
					;
					true
				),
				% matching /models/.../actions and fork to predicate 'validate_actions/2'
				(	atomic_list_concat(['', 'models', ModelID, Query], '/', PathModelID) ->
					(	Query = actions ->
						validate_actions(Request, ModelID)
						;
						true
					)
					;
					true
				),
				% matching /models/<<ModelID>>/<<ProcessID>>/<<Action>> and fork to predicate 'perform_actions/2'
				(	atomic_list_concat(['', 'models', ModelID, ProcessID, Action], '/', PathModelID) ->
					perform_action(Request, ModelID, ProcessID, Action)
					;
					true
				).
				
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	Returns all available process models as JSON object
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */		
		:- public(available_process_models/1).
		available_process_models(Request) :-
			memberchk(method(post), Request),
			
			findall(	json([ 	id = ProcessModel,
								name = Title ]),
						(	process_model::available_process_models(ProcessModel),
							ProcessModel::title(Title)
						),
						ProcessModelList
			),
			
			PrologOut = ProcessModelList,
			
			% reply
			{json_convert:prolog_to_json(PrologOut, JSONOut)},
	        {http_json:reply_json(JSONOut)}.
			
							
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			calls initial_state/2 and returns the initial state as JSON object   	
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */	
		:- public(initial_state/2).
		initial_state(Request, ModelID) :-
			memberchk(method(post), Request),
						
			% Check if a process of that specific model model has already been loaded. If not then load the model.	
			(	\+ (	extends_object(Process, process),
						Process::contained_in_process_model(ModelID)
					) ->
				(	{term_to_atom(ModelID, IdOfModelToLoadAtom)},	
					atomic_list_concat([IdOfModelToLoadAtom, '(loader)'], LoadStringAtom),
					{term_to_atom(LoadString, LoadStringAtom)},
					process_model::load(LoadString)
				)
				;
				true
			),
			process_planning::initial_state(ModelID, InitialState),
			InitialState = model_state(ProcessStatesList, ModelDoneCode),
			
			findall(	json([	object_name = 'process_state',
								process_id = Process_ID,
								process_history = Process_History
						]),
						(	list::member(ProcessState, ProcessStatesList),
							ProcessState = process_state(Process_ID, Process_History)
						),
						JSONProcessStatesList
			),
			
		    PrologOut = json([ 	model_state = json([ process_state_members = JSONProcessStatesList,
							  						 model_done_code = ModelDoneCode
							    ])
			]),
			
			% reply					
			{json_convert:prolog_to_json(PrologOut, JSONOut)},
		    {http_json:reply_json(JSONOut)}.


		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	calls validate_action/6 and returns a JSON object containing information about possible actions
		
			MIME Content Type: application/json
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(validate_actions/2).
		validate_actions(Request, ModelID) :-		
			memberchk(method(post), Request),
			
			/*
			?- 	ERROR: [Thread httpd@2600_3] stream_property/2: stream `<stream>(0x101559530)' does not exist
				==> JSON Request does not fit. Missing bracket, etc.
			*/
			
			{http_json:http_read_json(Request, JSONIn)},
        	{json_convert:json_to_prolog(JSONIn, PrologIn)},
			
			PrologIn = json([ model_state = json([ 	process_state_members = ProcessStateMemberList,
							  						model_done_code = ModelDoneCode
							])
			]),
			
			% Check if a process of that specific model model has already been loaded. If not then load the model.	
			(	\+ (	extends_object(Process, process),
						Process::contained_in_process_model(ModelID)
					) ->
				(	{term_to_atom(ModelID, IdOfModelToLoadAtom)},	
					atomic_list_concat([IdOfModelToLoadAtom, '(loader)'], LoadStringAtom),
					{term_to_atom(LoadString, LoadStringAtom)},
					process_model::load(LoadString)
				)
				;
				true
			),
			
			extends_object(Process, process),
			Process::id(FullQualifiedProcessID),
			atomic_list_concat([ModelID, ProcessID], '#', FullQualifiedProcessID),
			
			% rebuild the state from the JSON-object			
			findall(	process_state(Process_ID, Process_HistoryTerm),
						(	member(M, ProcessStateMemberList),
							M = json([	object_name = 'process_state',
										process_id = Process_ID,
										process_history = Process_HistoryString
								]),
							string_to_atom(Process_HistoryString, Process_HistoryAtom),
							atom_to_term(Process_HistoryAtom, Process_HistoryTerm, _)	
						),
						JSONProcessStatesList
			),
			ModelState = model_state(JSONProcessStatesList, ModelDoneCode),

			% validating actions for the given model and state
			findall(	json([	process = ProcessID,
								action = Action,
								instance = Instance,
								agent = AgentList,
								data = DataList,
								tool = ToolList,
								costs = Total_Costs
						]),
						(	Process::validate_action(Action, ModelState, Instance-AgentList-DataList-ToolList),
						
							% calculating costs for ranking
							functional_heuristic::		costs_do_process(Process, Action, ModelState, Instance, _, 			Costs_FU),
							behavioral_heuristic::		costs_do_process(Process, Action, ModelState, Instance, _, 			Costs_BE),			
							organizational_heuristic::	costs_do_process(Process, Action, ModelState, Instance, AgentList,	Costs_ORG),
							data_heuristic::			costs_do_process(Process, Action, ModelState, Instance, DataList, 	Costs_DATA),
							operational_heuristic::		costs_do_process(Process, Action, ModelState, Instance, ToolList, 	Costs_OP),
			
							% Calculate the total costs by adding up all values
							Total_Costs is Costs_FU + Costs_BE + Costs_ORG + Costs_DATA + Costs_OP
						),
						ValidationList
			),

			PrologOut = ValidationList,
			
			% reply			
			{json_convert:prolog_to_json(PrologOut, JSONOut)},
		    {http_json:reply_json(JSONOut)}.
		
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	calls perform_action/7 and returns a JSON object containing information about the next state
		
			MIME Content Type: application/json
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(perform_action/4).
		perform_action(Request, ModelID, ProcessID, Action) :-		
			memberchk(method(post), Request),
					
			{http_json:http_read_json(Request, JSONIn)},
        	{json_convert:json_to_prolog(JSONIn, PrologIn)},
			
			PrologIn = json([ instance = Instance,
      						  agent = Agents,
      						  data = Data,
      						  tool = Tools,
				  			  model_state = json([ 	process_state_members = OldProcessStatesList,
							  						model_done_code = OldModelDoneCode
							])
			]),
			
			% Check if a process of that specific model model has already been loaded. If not then load the model.	
			(	\+ (	extends_object(Process, process),
						Process::contained_in_process_model(ModelID)
					) ->
				(	{term_to_atom(ModelID, IdOfModelToLoadAtom)},	
					atomic_list_concat([IdOfModelToLoadAtom, '(loader)'], LoadStringAtom),
					{term_to_atom(LoadString, LoadStringAtom)},
					process_model::load(LoadString)
				)
				;
				true
			),
			
			atomic_list_concat([ModelID, ProcessID], '#', FullQualifiedProcessID),
			extends_object(Process, process),
			Process::id(FullQualifiedProcessID),
			
			% rebuild the state from the JSON-object			
			findall(	process_state(Process_ID, Process_History),
						(	member(M, OldProcessStatesList),
							M = json([	object_name = 'process_state',
										process_id = Process_ID,
										process_history = Process_History
								])
						),
						OldJSONProcessStatesList
			),
			OldModelState = model_state(OldJSONProcessStatesList, OldModelDoneCode),
			
			% perform action on process
			Process::perform_action(Action, OldModelState, Instance-Agents-Data-Tools, NextModelState),

			% parse the new model state
			NextModelState = model_state(NewProcessStatesList, NewModelDoneCode),	
					
			findall(	json([	object_name = 'process_state',
								process_id = Process_ID,
								process_history = Process_HistoryString
						]),
						(	list::member(ProcessState, NewProcessStatesList),
							ProcessState = process_state(Process_ID, Process_History),
							term_to_atom(Process_History, Process_HistoryAtom),
							string_to_atom(Process_HistoryAtom, Process_HistoryString)	
						),
						JSONProcessStatesList
			),
			
		    PrologOut = json([ 	model_state = json([ process_state_members = JSONProcessStatesList,
							  						 model_done_code = NewModelDoneCode
							    ])
			]),
						
			% reply			
			{json_convert:prolog_to_json(PrologOut, JSONOut)},
		    {http_json:reply_json(JSONOut)}.
		
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	Message when accessing the root document
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */	
		:- public(say_hi/1).
		say_hi(Request) :-
			%write(Request),
	        {html_write:reply_html_page(title('ESProNa'),
	        							table(	[	width('100%'),
													border(0)],
												[	tr(td(pre('	___________ ___________________                _______          
	\\_   _____//   _____/\\______   \\_______  ____  \\      \\ _____   
	 |    __)_ \\_____  \\  |     ___/\\_  __ \\/  _ \\ /   |    \\__  \\  
	 |        \\/        \\ |    |     |  | \\(  <_> )    |    \\/ __ \\_
	/_______  /_______  / |____|     |__|   \\____/\\____|__  (____  /
	        \\/        \\/                                  \\/     \\/
+++ Modeling, Execution and SmartNavigation(c) of Declarative Business Processes +++')))
												]))}.
		
:- end_object.