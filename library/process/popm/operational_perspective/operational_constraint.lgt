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

:- category(operational_constraint).
	
		:- info([
			version is 0.8,
			date is 2009/10/15,
			author is 'Michael Igler (michael.igler@uni-bayreuth.de)',
			comment is 'This perspective is conform when the given operational constraints evaluate to true.']).
	
		:- public(operational_constraint/5).
		:- mode(organizational_constraint(+list(actions), +modelstate, +instance_identifier, ?list(tool_identifiers), +callable), 
				zero_or_more).
					
		:- public(operational_constraint/6).
		:- mode(organizational_constraint(+modal_prefix, +list(actions), +modelstate, +instance_identifier, ?list(tool_identifiers), +callable), 
				zero_or_more).
		:- info(operational_constraint/6, [
			comment is 'Contains the POPM constraints of the operational perspective.']).
		
		% Operational constraints without modal prefix are necessary operational constraints.	
		operational_constraint(necessity, ActionList, ModelState, Instance, ToolList, Constraints) :-
			::operational_constraint(ActionList, ModelState, Instance, ToolList, Constraints).
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	operational_constraints_conform/4
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */		
		:- public(operational_constraints_conform/4).
		:- mode(operational_constraints_conform(+var(action), +modelstate, ?instance_identifier, +list(tool_identifiers)), 
				zero_or_more).
		:- info(operational_constraints_conform/4, [
			comment is 'This predicate expects: instantiated Action(+var), 
						 						instantiated ModelState(+list), 
												instantiated Instance(+var) and
												free or instantiated ToolList(?list).']).
													
		% 1st case: Action is in the list given by an operational_constraint
		operational_constraints_conform(Action, ModelState, Instance, Tools) :-
			bagof(	Constraints, 
					(	::operational_constraint(necessity, ActionList, ModelState, Instance, Tools, Constraints),
						list::member(Action, ActionList)
					),
					List
			),
			meta::map({call}, List).

		% 2nd case: Action is NOT in the list given by an operational_constraint
		operational_constraints_conform(Action, ModelState, Instance, Tools) :-
			::operational_constraint(necessity, ActionList, ModelState, Instance, Tools, _),
			\+ list::member(Action, ActionList),
			Tools = [].

		% 3rd case: No operational_constraint given at all
		operational_constraints_conform(_, _, _, Tools) :-
			\+ ::operational_constraint(_, _, _, _, _, _),
			Tools = [].
			
:- end_category.