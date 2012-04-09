%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ESProNa - 	Modeling, Execution and SmartNavigation(c) of Declarative Business Processes
%  Release 0.8
%  
%  Copyright (c) 2007-2011 Michael Igler.       All Rights Reserved.
%  ESProNa is free software.  You can redistribute it and/or modify it under the terms 
%  of the "Artistic License 2.0" as published by The Perl Foundation. 
%  Consult the "LICENSE.txt" file for details.
%
%  Contact: 	Michael Igler (michael.igler@uni-bayreuth.de)
%				University of Bayreuth
%				Chair for Applied Computer Science IV
%				Databases and Information Systems
%				Universitaetsstrasse 30
%				D-95440 Bayreuth
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- object(heuristic_perspective).
			
		:- info([
			version is 0.8,
			date is 2011/04/6,
			author is 'Michael Igler (michael.igler@uni-bayreuth.de)',
			comment is 'Predicates for the heuristic search/planning in the Organizational Perspective.']).								
		
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		  	costs_do_process/6
		  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(costs_do_process/6).
		:- mode(costs_do_process(?process_object, ?var(action), +modelstate, ?instance_identifier, ?list, -number), 
				zero_or_one). 
		:- info(costs_do_process/6, [
			comment is 'Calculates the costs for executing a given process ID.
						Example query: 	organizational_heuristic::costs_do_process(pid_a(_), start, Costs).']).

		:- private(costs_necessity_do_process/6).
		:- private(costs_recommendation_do_process/6).

		costs_do_process(Process, Action, ModelState, Instance, PerspectiveVar, Costs) :-
			(	% check if recommendation is given
				::costs_recommendation_do_process(Process, Action, ModelState, Instance, PerspectiveVar, Costs) ->	
				true
			;	% if not, then check necessity and recommedation_degree = costs
				::costs_necessity_do_process(Process, Action, ModelState, Instance, PerspectiveVar, Costs) ->
				true
			;	% no constraint specified ==> no costs
				Costs is 0
			).
		
:- end_object.