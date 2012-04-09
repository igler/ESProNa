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

:- object(process,
	imports(functional_constraint, behavioral_constraint, organizational_constraint, data_constraint, operational_constraint)).
									
		:- info([
			version is 0.8,
			date is 2011/03/03,
			author is 'Michael Igler (michael.igler@uni-bayreuth.de)',
			comment is 'Describes the process object as a composition of all POPM perspectives.']).
							
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	Process title
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */	
		:- public(process_title/1).
		:- mode(process_title(-atom), one).
		:- info(process_title/1, [
			comment is 'The title of the process.']).
		
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	Process description
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */	
		:- public(process_description/1).
		:- mode(process_description(-atom), one).
		:- info(process_description/1, [
			comment is 'The description of the process.']).
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	Process description
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */	
		:- public(contained_in_process_model/1).
		:- mode(contained_in_process_model(-process_model), one).
		:- info(contained_in_process_model/1, [
			comment is 'Stores in which process model this process is contained.']).	
		
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	Process actions
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */	
		:- public(process_actions/1).
		:- mode(process_actions(+list(actions)), one).
		:- info(process_actions/1, [
			comment is 'Declaring the actions that can be performed on the process.']).
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	Process domain
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */	
		:- public(process_domain/2).
		:- mode(process_domain(+list(dependencies), +term(clpfd_domains)), one).
		:- info(process_domain/2, [
			comment is 'The domain of the process is stored here.']).
		
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	Maximum positive and negative recommendation degree used by the heuristic planning algorithms
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */	
		:- public(highest_positive_recommendation_degree/1).
		:- mode(highest_positive_recommendation_degree(-number), one).
		:- info(highest_positive_recommendation_degree/1, [
			comment is '...']).
		
		:- public(highest_negative_recommendation_degree/1).
		:- mode(highest_negative_recommendation_degree(-number), one).
		:- info(highest_negative_recommendation_degree/1, [
			comment is '...']).
						
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	validate_action/3
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(validate_action/3).
		:- mode(validate_action(?var(action), +modelstate, +compound_term(concept_identifiers)), 
				zero_or_more). 
		:- info(validate_action/3, [
			comment is '...']).
		
		validate_action(Action, ModelState, Instance-Agents-Data-Tools) :-
			::process_actions(ActionList),
			list::member(Action, ActionList),			
			::functional_constraints_conform(		Action, ModelState, Instance),			% FU-perspective
			::behavioral_constraints_conform(		Action, ModelState, Instance),			% BE-perspective
			::organizational_constraints_conform(	Action, ModelState, Instance, Agents),	% ORG-perspective
			::data_constraints_conform(				Action, ModelState, Instance, Data),	% DATA-perspective
			::operational_constraints_conform(		Action, ModelState, Instance, Tools).	% OP-perspective
				
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		    perform_action/4
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(perform_action/4).
		:- mode(perform_action(	+var(action), +modelstate, +compound_term(concept_identifiers), ?list(state)), 
				zero_or_one). 
		:- info(perform_action/4, [
			comment is '...']).

		perform_action(Action, ModelState, Instance-Agents-Data-Tools, NextModelState) :-
			::process_actions(ActionList),
			list::member(Action, ActionList),
			
			% Data production:
			(	::data_production(ActionListData, Data), 
				list:member(Action, ActionListData) ->
				true
			;
				Data = []
			),

			% Add new information to the end of the process history
			::id(MyID),
			ModelState::update_model_state(MyID, Instance-Action-Agents-Data-Tools, NextModelState).
					
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	id/1
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(id/1).
		:- mode(id(?var(process_identifier)), zero_or_one). 
		:- info(id/1, [
			comment is 'Returns the process identifier.
						Example query: 	pid_1(_)::id(MyID).']).
						
		id(MyID) :-
			self(Self),
			functor(Self, MyID, _).
				
:- end_object.