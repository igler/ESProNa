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

:- category(data_constraint).
	
		:- info([
			version is 0.8,
			date is 2009/10/15,
			author is 'Michael Igler (michael.igler@uni-bayreuth.de)',
			comment is 'This perspective is conform when the given data constraints evaluate to true.']).
	
		:- public(data_constraint/5).
		:- mode(data_constraint(+list(actions), +modelstate, +instance_identifier, ?list(data_identifiers), +callable), 
				zero_or_more).
			
		:- public(data_constraint/6).
		:- mode(data_constraint(+modal_prefix, +list(actions), +modelstate, +instance_identifier, ?list(data_identifiers), +callable), 
				zero_or_more).
		:- info(data_constraint/6, [
			comment is 'Contains the POPM constraints of the data perspective.']).
		
		:- public(data_production/2).
		:- mode(data_constraint(+var, +list), zero_or_one).
		:- info(data_constraint/2, [
			comment is 'Stores which data is produced (2nd argument) during a certain action (1st argument).']).
			
			
		% Data constraints without modal prefix are necessary data constraints.	
		data_constraint(necessity, ActionList, ModelState, Instance, DataList, Constraints) :-
			::data_constraint(ActionList, ModelState, Instance, DataList, Constraints).		
	
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	data_constraints_conform/4
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */		
		:- public(data_constraints_conform/4).
		:- mode(data_constraints_conform(+var(action), +modelstate, ?instance_identifier, +list(data_identifiers)), 
				zero_or_more).
		:- info(data_constraints_conform/4, [
			comment is 'This predicate expects: instantiated Action(+var), 
						 						instantiated ModelState(+list), 
												instantiated Instance(+var) and
												free or instantiated DataList(?list).']).
		
		% 1st case: Action is in the list given by a data_constraint
		data_constraints_conform(Action, ModelState, Instance, Data) :-
			bagof(	Constraints, 
					(	::data_constraint(necessity, ActionList, ModelState, Instance, Data, Constraints),
						list::member(Action, ActionList)
					),
					List
			),
			meta::map({call}, List).

		% 2nd case: Action is NOT in the list given by a data_constraint
		data_constraints_conform(Action, ModelState, Instance, Data) :-
			::data_constraint(necessity, ActionList, ModelState, Instance, Data, _),
			\+ list::member(Action, ActionList),
			Data = [].

		% 3rd case: No operational_constraint given at all
		data_constraints_conform(_, _, _, Data) :-
			\+ ::data_constraint(_, _, _, _, _, _),
			Data = [].		
						
:- end_category.