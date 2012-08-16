/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   														LOADING THE PROCESS MODEL 
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
process_model::load(set_up_surgery_plan_extended(loader)).


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   														ACTION QUERIES 
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
process_planning::initial_state(set_up_surgery_plan_extended, InitialState),
extends_object(Process, process),
Process::validate_action(start, InitialState, Instance-AgentList-RequiredDataList-ToolsList).							

process_planning::initial_state(set_up_surgery_plan_extended, InitialState),
'set_up_surgery_plan_extended#pid_0'(_)::perform_action(start, InitialState, 
	1-['http://ai4.inf.uni-bayreuth.de/ontology/individuals#John']-[]-['HIS'], 
	NextModelState
).

ModelState = model_state([
	process_state('set_up_surgery_plan_extended#pid_0', [1-start-['http://ai4.inf.uni-bayreuth.de/ontology/individuals#John']-[]-['HIS']]),
	process_state('set_up_surgery_plan_extended#pid_1', []), 
	process_state('set_up_surgery_plan_extended#pid_2', []),
	process_state('set_up_surgery_plan_extended#pid_3', [])], 
	0),
extends_object(Process, process),
Process::validate_action(Action, ModelState, Instance-AgentList-RequiredDataList-ToolsList).


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   														STATE SPACE GENERATING QUERIES 
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
% esprona_HILL_CLIMBING:	
performance::init,
process_planning::initial_state(set_up_surgery_plan_extended, IS), 
process_planning::goal_state(set_up_surgery_plan_extended, GS),
graphviz::start_export('./process_models/set_up_surgery_plan_extended/graph_state_space_HillClimbing.dot'), 
esprona_hill_climbing(6)::solve(set_up_surgery_plan_extended, process_planning, IS, GS, Path, Costs),
graphviz::finish_export(GS, Path, '"#62D523"', '"#0066FF"'),
performance::report.

performance::init,
process_planning::initial_state(set_up_surgery_plan_extended, IS), 
process_planning::goal_state(set_up_surgery_plan_extended, GS),
esprona_hill_climbing(6)::solve(set_up_surgery_plan_extended, process_planning, IS, GS, Path, Costs),
performance::report.

% esprona_BEST_FIRST:
performance::init,
process_planning::initial_state(set_up_surgery_plan_extended, IS), 
process_planning::goal_state(set_up_surgery_plan_extended, GS),
graphviz::start_export('./process_models/set_up_surgery_plan_extended/graph_state_space_BestFirst.dot'), 
esprona_best_first(10)::solve(set_up_surgery_plan_extended, process_planning, IS, GS, Path, Costs),
graphviz::finish_export(GS, Path, '"#62D523"', '"#0066FF"'),
performance::report.

performance::init,
process_planning::initial_state(set_up_surgery_plan_extended, IS), 
process_planning::goal_state(set_up_surgery_plan_extended, GS),
esprona_best_first(10)::solve(set_up_surgery_plan_extended, process_planning, IS, GS, Path, Costs),
performance::report.

% esprona_DEPTH_FIRST with export to Graphviz file:
performance::init,
process_planning::initial_state(set_up_surgery_plan_extended, IS), 
process_planning::goal_state(set_up_surgery_plan_extended, GS),
graphviz::start_export('./process_models/set_up_surgery_plan_extended/graph_state_space_DepthFirst.dot'), 
esprona_depth_first(6)::solve(set_up_surgery_plan_extended, process_planning, IS, GS, Path),
graphviz::finish_export(GS, Path, '"#62D523"', '"#0066FF"'),
performance::report.

performance::init,
process_planning::initial_state(set_up_surgery_plan_extended, IS), 
process_planning::goal_state(set_up_surgery_plan_extended, GS),
esprona_depth_first(6)::solve(set_up_surgery_plan_extended, process_planning, IS, GS, Path),
performance::report.

% esprona_BREADTH_FIRST with export to Graphviz file:
performance::init,
process_planning::initial_state(set_up_surgery_plan_extended, IS), 
process_planning::goal_state(set_up_surgery_plan_extended, GS),
graphviz::start_export('./process_models/set_up_surgery_plan_extended/graph_state_space_BreadthFirst.dot'), 
esprona_breadth_first(6)::solve(set_up_surgery_plan_extended, process_planning, IS, GS, Path),
graphviz::finish_export(GS, Path, '"#62D523"', '"#0066FF"'),
performance::report.

performance::init,
process_planning::initial_state(set_up_surgery_plan_extended, IS), 
process_planning::goal_state(set_up_surgery_plan_extended, GS),
esprona_breadth_first(6)::solve(set_up_surgery_plan_extended, process_planning, IS, GS, Path),
performance::report.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   														SmartNavigation QUERIES 
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
process_planning::initial_state(set_up_surgery_plan_extended, InState),
process_planning::navigate(set_up_surgery_plan_extended, InState, ToState, Path, Costs,
(
	'set_up_surgery_plan_extended#pid_3'(_)::validate_action(finish, ToState, Instance-AgentList-_-_)
)).


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   														State Transitions Export
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
performance::init,
process_planning::initial_state(set_up_surgery_plan_extended, IS), 
process_planning::goal_state(set_up_surgery_plan_extended, GS),
export_state_transitions::start_export('./process_models/set_up_surgery_plan_extended/state_transitions.txt'), 
esprona_hill_climbing(6)::solve(set_up_surgery_plan_extended, process_planning, IS, GS, Path, Costs),
export_state_transitions::finish_export,
performance::report.