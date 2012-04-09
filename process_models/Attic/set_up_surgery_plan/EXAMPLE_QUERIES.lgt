/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   														LOADING THE PROCESS MODEL 
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
logtalk_load(set_up_surgery_plan(loader)).
	
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   														STATE SPACE GENERATING QUERIES 
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
% esprona_HILL_CLIMBING:	
performance::init,
process_planning::initial_state(IS), 
process_planning::goal_state(GS),
graphviz::start_export('./process_models/set_up_surgery_plan/graph_state_space_HillClimbing.dot'), 
esprona_hill_climbing(6)::solve(process_planning, IS, GS, Path, Costs),
graphviz::finish_export(GS, Path, '"#62D523"', '"#0066FF"'),
performance::report.

% esprona_BEST_FIRST:
performance::init,
process_planning::initial_state(IS), 
process_planning::goal_state(GS),
graphviz::start_export('./process_models/set_up_surgery_plan/graph_state_space_BestFirst.dot'), 
esprona_best_first(6)::solve(process_planning, IS, GS, Path, Costs),
graphviz::finish_export(GS, Path, '"#62D523"', '"#0066FF"'),
performance::report.

% esprona_DEPTH_FIRST with export to Graphviz file:
performance::init,
process_planning::initial_state(IS), 
process_planning::goal_state(GS),
graphviz::start_export('./process_models/set_up_surgery_plan/graph_state_space_DepthFirst.dot'), 
esprona_depth_first(6)::solve(process_planning, IS, GS, Path),
graphviz::finish_export(GS, Path, '"#62D523"', '"#0066FF"'),
performance::report.

% esprona_BREADTH_FIRST with export to Graphviz file:
performance::init,
process_planning::initial_state(IS), 
process_planning::goal_state(GS),
graphviz::start_export('./process_models/set_up_surgery_plan/graph_state_space_BreadthFirst.dot'), 
esprona_breadth_first(6)::solve(process_planning, IS, GS, Path),
graphviz::finish_export(GS, Path, '"#62D523"', '"#0066FF"'),
performance::report.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   														SmartNavigation QUERIES 
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
performance::init,
graphviz::start_export('./process_models/set_up_surgery_plan/graph_navigation_HillClimbing.dot'),
InState = model_state([process_state(pid_0, [1-start-['http://ai4.inf.uni-bayreuth.de/ontology/individuals#Hugo']-[]-['HIS']]), process_state(pid_1, []), process_state(pid_2, [])], 0),
process_planning::navigate(InState, ToState, Path, Costs,
(
	pid_2(_)::validate_action(start, ToState, Instance, [Agent], _, _),
	'http://ai4.inf.uni-bayreuth.de/ontology/individuals#Surgery'::'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'(Agent)
)),
graphviz::finish_export(ToState, Path, '"#62D523"', '"#0066FF"'),
performance::report.
	
	
performance::init,
graphviz::start_export('./process_models/set_up_surgery_plan/graph_navigation_DepthFirst.dot'),
InState = model_state([process_state(pid_0, [1-start-['http://ai4.inf.uni-bayreuth.de/ontology/individuals#Hugo']-[]-['HIS']]), process_state(pid_1, []), process_state(pid_2, [])], 0),
process_planning::navigate(InState, ToState, Path,
(
	pid_2(_)::validate_action(start, ToState, Instance, [Agent], _, _),
	'http://ai4.inf.uni-bayreuth.de/ontology/individuals#Surgery'::'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'(Agent)
)),
graphviz::finish_export(ToState, Path, '"#62D523"', '"#0066FF"'),
performance::report.
	
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   														Ontology QUERIES 
  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
	
'http://ai4.inf.uni-bayreuth.de/ontology/individuals#Jacob'::'http://ai4.inf.uni-bayreuth.de/ontology/organization#supervisorOf'(X).
'http://ai4.inf.uni-bayreuth.de/ontology/individuals#Hugo'::'http://ai4.inf.uni-bayreuth.de/ontology/organization#supervisorOf'(X).
'http://ai4.inf.uni-bayreuth.de/ontology/individuals#Jack'::'http://ai4.inf.uni-bayreuth.de/ontology/organization#supervisorOf'(X).

'http://ai4.inf.uni-bayreuth.de/ontology/individuals#MTA'::'http://ai4.inf.uni-bayreuth.de/ontology/organization#supervises'(X).
'http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor'::'http://ai4.inf.uni-bayreuth.de/ontology/organization#supervises'(X).
'http://ai4.inf.uni-bayreuth.de/ontology/individuals#MedicalSuperintendent'::'http://ai4.inf.uni-bayreuth.de/ontology/organization#supervises'(X).

'http://ai4.inf.uni-bayreuth.de/ontology/individuals#Hugo'::'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'(X).

'http://ai4.inf.uni-bayreuth.de/ontology/individuals#Cardiology'::'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'(X).

'http://ai4.inf.uni-bayreuth.de/ontology/individuals#XRayDepartment'::'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'(Assistent),
Assistent::'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor').







