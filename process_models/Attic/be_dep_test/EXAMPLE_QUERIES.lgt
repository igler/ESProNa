/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   														LOADING THE PROCESS MODEL 
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
logtalk_load(be_dep_test(loader)).
	
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   														STATE SPACE GENERATING QUERIES
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
% esprona_HILL_CLIMBING:	
performance::init,
process_planning::initial_state(IS), 
process_planning::goal_state(GS),
graphviz::start_export('./process_models/be_dep_test/graph_state_space_HillClimbing.dot'), 
esprona_hill_climbing(6)::solve(process_planning, IS, GS, Path, Costs),
graphviz::finish_export(GS, Path, '"#62D523"', '"#0066FF"'),
performance::report.

% esprona_BEST_FIRST:
performance::init,
process_planning::initial_state(IS), 
process_planning::goal_state(GS),
graphviz::start_export('./process_models/be_dep_test/graph_state_space_BestFirst.dot'), 
esprona_best_first(6)::solve(process_planning, IS, GS, Path, Costs),
graphviz::finish_export(GS, Path, '"#62D523"', '"#0066FF"'),
performance::report.

% esprona_DEPTH_FIRST with export to Graphviz file:
performance::init,
process_planning::initial_state(IS), 
process_planning::goal_state(GS),
graphviz::start_export('./process_models/be_dep_test/graph_state_space_DepthFirst.dot'), 
esprona_depth_first(10)::solve(process_planning, IS, GS, Path),
graphviz::finish_export(GS, Path, '"#62D523"', '"#0066FF"'),
performance::report.
	