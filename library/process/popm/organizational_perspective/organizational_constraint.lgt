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

:- category(organizational_constraint).
	
		:- info([
			version is 0.8,
			date is 2009/10/15,
			author is 'Michael Igler (michael.igler@uni-bayreuth.de)',
			comment is 'This perspective is conform when the given organizational constraints evaluate to true.']).
		
		:- public(organizational_constraint/5).
		:- mode(organizational_constraint(+list(actions), +modelstate, +instance_identifier, ?list(agent_identifiers), +callable), 
				zero_or_more).
										
		:- public(organizational_constraint/6).
		:- mode(organizational_constraint(+modal_prefix, +list(actions), +modelstate, +instance_identifier, ?list(agent_identifiers), +callable), 
				zero_or_more).
		:- info(organizational_constraint/6, [
			comment is 'Contains the POPM constraints of the organizational perspective.']).
			
		% Organizational constraints without modal prefix are necessary organizational constraints.	
		organizational_constraint(necessity, ActionList, ModelState, Instance, AgentList, Constraints) :-
			::organizational_constraint(ActionList, ModelState, Instance, AgentList, Constraints).
				
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	organizational_constraints_conform/4
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(organizational_constraints_conform/4).
		:- mode(organizational_constraints_conform(+action, +modelstate, ?instance_identifier, ?list(agent_identifiers)), 
				zero_or_more).
		:- info(organizational_constraints_conform/4, [
			comment is 'This predicate expects: instantiated Action(+var), 
						 						instantiated ModelState(+list), 
												instantiated Instance(+var) and
												free or instantiated AgentList(?list).']).
		organizational_constraints_conform(Action, ModelState, Instance, Agents) :-
			bagof(	Constraints,
					(	::organizational_constraint(necessity, ActionList, ModelState, Instance, Agents, Constraints),	
						list::member(Action, ActionList)
					),
					List
			),
			meta::map({call}, List).
						
:- end_category.