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

:- category(behavioral_constraint).
	
		:- info([
			version is 0.8,
			date is 2009/10/15,
			author is 'Michael Igler (michael.igler@uni-bayreuth.de)',
			comment is 'This perspective is conform when the given behavioral constraints evaluate to true.']).
	
		:- public(behavioral_constraint/4).
		:- mode(behavioral_constraint(+list(actions), +modelstate, -instance_identifier, +callable), 
				zero_or_more).

		:- public(behavioral_constraint/5).
		:- mode(behavioral_constraint(+modal_prefix, +list(actions), +modelstate, -instance_identifier, +callable), 
				zero_or_more).
		:- info(behavioral_constraint/5, [
			comment is 'Contains the POPM constraints of the behavioral perspective.']).


		% Behavioral constraints without modal prefix are necessary behavioral constraints.	
		behavioral_constraint(necessity, ActionList, ModelState, Instance, Constraints) :-
			::behavioral_constraint(ActionList, ModelState, Instance, Constraints).
				
	
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	behavioral_constraints_conform/3
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(behavioral_constraints_conform/3).
		:- mode(behavioral_constraints_conform(+var(action), +modelstate, ?instance_identifier), 
				zero_or_more).
		:- info(behavioral_constraints_conform/3, [
			comment is 'This predicate expects: instantiated Action(+var), 
						 						instantiated ModelState(+list), 
												instantiated Instance(+var).']).
		
		% 1st case: Action is in the list given by a behavioral_constraint
		behavioral_constraints_conform(Action, ModelState, Instance) :-
			bagof(	Constraints, 
					(	::behavioral_constraint(necessity, ActionList, ModelState, Instance, Constraints),
						list::member(Action, ActionList)
					),
					List
			),
			meta::map({call}, List).
						
		% 2nd case: Action is NOT in the list given by a behavioral_constraint
		behavioral_constraints_conform(Action, ModelState, Instance) :-
			::behavioral_constraint(necessity, ActionList, ModelState, Instance, _),
			\+ list::member(Action, ActionList).
			
		% 3rd case: No behavioral_constraint given at all
		behavioral_constraints_conform(_, ModelState, Instance) :-
			\+ ::behavioral_constraint(_, _, ModelState, Instance, _).
					
:- end_category.