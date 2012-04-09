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

:- object(data_heuristic,
	extends(heuristic_perspective)).
			
		:- info([
			version is 0.8,
			date is 2011/04/6,
			author is 'Michael Igler (michael.igler@uni-bayreuth.de)',
			comment is 'Predicates for heuristic searching and planning algorithms of the data perspective.']).
								
		% 1st case: No recommendation constraint given ==> costs =													
		costs_necessity_do_process(Process, Action, ModelState, Instance, RData, 0) :-		
			Process::data_constraint(necessity, ActionList, ModelState, Instance, RData, Constraints),
			list::member(Action, ActionList),
			{Constraints}.

		% 2nd case: Action is in the list given by a recommended organizational_constraint															
		costs_recommendation_do_process(Process, Action, ModelState, Instance, RData, Costs) :-
			bagof(	Constraint,
					(
						Process::data_constraint(recommendation(Costs), ActionList, ModelState, Instance, RData, Constraint),
						list::member(Action, ActionList)
					),
					List
			),
			meta::map({call}, List).

:- end_object.