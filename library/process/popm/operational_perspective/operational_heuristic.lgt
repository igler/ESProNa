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

:- object(operational_heuristic,
		extends(heuristic_perspective)).
			
		:- info([
			version is 0.8,
			date is 2011/04/6,
			author is 'Michael Igler (michael.igler@uni-bayreuth.de)',
			comment is 'Predicates for heuristic searching and planning algorithms of the operational perspective.']).
								
		% 1st case: No recommendation constraint given ==> costs =													
		costs_necessity_do_process(Process, Action, ModelState, Instance, Tool, 0) :-		
			Process::operational_constraint(necessity, ActionList, ModelState, Instance, Tool, Constraints),
			list::member(Action, ActionList),
			{Constraints}.

		% 2nd case: Action is in the list given by a recommended organizational_constraint															
		costs_recommendation_do_process(Process, Action, ModelState, Instance, Tool, Costs) :-
			bagof(	Constraint,
					(
						Process::operational_constraint(recommendation(Costs), ActionList, ModelState, Instance, Tool, Constraint),
						list::member(Action, ActionList)
					),
					List
			),
			meta::map({call}, List).
		
:- end_object.