%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ESProNa - 	Modeling, Execution and Navigation of Declarative Business Processes
%  Release 0.8
%  
%  Copyright (c) 2007-2012 Michael Igler.       All Rights Reserved.
%  ESProNa is free software.  You can redistribute it and/or modify it under the terms 
%  of the "Artistic License 2.0" as published by The Perl Foundation. 
%  Consult the "LICENSE.txt" file for details.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- object(process_planning,
	instantiates(heuristic_state_space)).
				
		:- info([
			version is 0.8,
			date is 2011/03/03,
			author is 'Michael Igler (michael.igler@uni-bayreuth.de)',
			comment is 'Process planning object to enable ProcessNavigation in ESProNa.']).	

		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	initial_state/2
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		initial_state(ProcessModelID, InitialState) :-
			model_state(_, _)::generate_initial_model_state(ProcessModelID, InitialState).
		
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	goal_state/2
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		goal_state(ProcessModelID, GoalState) :-
			model_state(_, _)::generate_goal_model_state(ProcessModelID, GoalState).
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	next_state/3
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */								
		next_state(ProcessModelID, State, NextState) :-
			extends_object(Process, process),
			Process::contained_in_process_model(ProcessModelID),
			
			Process::process_actions(ActionList),
			list::member(Action, ActionList),
			
			% Do some accelerations here: No planning on aborting processes
			Action \== abort,
			
			Process::validate_action(Action, State, Instance-AgentList-RequiredDataList-ToolsList),							
			Process::perform_action(Action, State, Instance-AgentList-DataProduced-ToolsList, NextState),
			
			debug((
					Process::id(ProcessID),
				    write(Action), write(' process '), write(ProcessID), nl,
					write('\tinstance '), write(Instance), nl,
					write('\tby agent '), write(AgentList), nl,
					write('\twith data '), write(RequiredDataList), nl,
					write('\tusing tool '), write(ToolsList), nl,
					write('\tData produced: '), write(DataProduced),nl,
					nl,
				    write('... old state was: '), nl, State::print, nl,
				    write('... new state is: '), nl, NextState::print, nl,
					nl
				 )).
				
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	next_state/4	
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */												
		next_state(ProcessModelID, State, NextState, Total_Costs) :-
			extends_object(Process, process),
			Process::contained_in_process_model(ProcessModelID),
			
			% Get Actions that can be performed on Process
			Process::process_actions(ActionList),
			list::member(Action, ActionList),
						
			% Check ability to perform process
			Process::validate_action(Action, State, Instance-Agents-RData-Tools),
		
			% Perform Action on process							
			Process::perform_action(Action, State, Instance-Agents-PData-Tools, NextState),
					
			% Calculate the costs of each perspective
			functional_heuristic::		costs_do_process(Process, Action, State, Instance, _, 		Costs_FU),
			behavioral_heuristic::		costs_do_process(Process, Action, State, Instance, _, 		Costs_BE),			
			organizational_heuristic::	costs_do_process(Process, Action, State, Instance, Agents, 	Costs_ORG),
			data_heuristic::			costs_do_process(Process, Action, State, Instance, RData, 	Costs_DATA),
			operational_heuristic::		costs_do_process(Process, Action, State, Instance, Tools, 	Costs_OP),
			
			% Calculate the total costs by adding up all values
			Total_Costs is Costs_FU + Costs_BE + Costs_ORG + Costs_DATA + Costs_OP,
			
			debug((
					Process::id(ProcessID),
				    write(Action), write(' process '), write(ProcessID), write(' with costs: '),
					write('('), 
					write(Costs_FU), write('(FU)'), 
					write(' + '), 
					write(Costs_BE), write('(BE)'),
					write(' + '),
					write(Costs_ORG), write('(ORG)'),
					write(' + '),
					write(Costs_DATA), write('(DATA)'),
					write(' + '),
					write(Costs_OP), write('(OP)'),
					write(' = '), write(Total_Costs),
					write(')'), 
					nl,
					write('\tinstance '), write(Instance), nl,
					write('\tby agent '), write(Agents), nl,
					write('\twith data '), write(RData), nl,
					write('\tusing tool '), write(Tools), nl,
					write('\tData produced: '), write(PData),nl,
					nl,
				    write('... old state was: '), nl, State::print, nl,
				    write('... new state is: '), nl, NextState::print, nl,
					nl
				 )).
				
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	heuristic/2
		
			Estimates state distance to a goal state. In best case costs can be 0 when following the necessity constraints.
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		heuristic(_, 0).

		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	navigate/5
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		navigate(ProcessModelID, FromState, ToState, Path, Conditions) :-
			esprona_depth_first(6)::solve(ProcessModelID, process_planning, FromState, ToState, Path),
			{Conditions}.
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	navigate/6
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		navigate(ProcessModelID, InState, ToState, Path, Costs, Conditions) :-
			esprona_hill_climbing(15)::solve(ProcessModelID, process_planning, InState, ToState, Path, Costs),
			{Conditions}.
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	print_state/1
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */	
		print_state(State) :-
			model_state(State, _)::print, nl.	
		
:- end_object.