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

:- object(tests,
	extends(lgtunit)).

	test(esprona_HILL_CLIMBING) :-
		process_planning::initial_state(set_up_surgery_plan_extended, IS), 
		process_planning::goal_state(set_up_surgery_plan_extended, GS),
		esprona_hill_climbing(6)::solve(set_up_surgery_plan_extended, process_planning, IS, GS, _, Costs),
		Costs == -11.

:- end_object.