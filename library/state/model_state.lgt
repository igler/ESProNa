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

:- object(model_state(_ProcessStatesList, _ModelDoneCode)).

		:- info([
			version is 0.8,
			date is 2010/04/19,
			author is 'Michael Igler (michael.igler@uni-bayreuth.de)',
			comment is 'Represents the state of the process model.']).
		
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	generate_initial_model_state/2
			- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(generate_initial_model_state/2).
		:- mode(generate_initial_model_state(+process_model, ?model_state), 
				zero_or_one). 
		:- info(generate_initial_model_state/2, [
			comment is 'Generates the initial ModelState.']).
			
		generate_initial_model_state(IdOfModel, ModelState) :-
			findall(ProcessState,
					(	extends_object(Process, process),
						Process::contained_in_process_model(IdOfModel),
						Process::id(PID),
						ProcessState = process_state(PID, [])
					),
					ProcessStatesList
			),
			ModelState = model_state(ProcessStatesList, 0).	

		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	generate_goal_model_state/2
			- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(generate_goal_model_state/2).
		:- mode(generate_goal_model_state(+process_model, ?model_state), 
				zero_or_one). 
		:- info(generate_goal_model_state/2, [
			comment is 'Generates the goal ModelState.']).
			
		generate_goal_model_state(IdOfModel, ModelState) :-
			findall(ProcessState,
					(	extends_object(Process, process),
						Process::contained_in_process_model(IdOfModel),
						Process::id(PID),
						ProcessState = process_state(PID, _)
					),
					ProcessStatesList
			),
			ModelState = model_state(ProcessStatesList, 1).	
						
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	update_model_state/3
			- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */				
		:- public(update_model_state/3).
		:- mode(update_model_state(?process_identifier, +compound_term(concept_identifiers), ?model_state),  
				zero_or_one). 
		:- info(update_model_state/3, [
			comment is 'Updates the ProcessState of a certain process. A new HistoryList of that process is calculated.']).
			
		update_model_state(PID, ConceptIdentifiers, NewModelState) :-
			parameter(1, OldProcessStatesList),
			OldProcessState = process_state(PID, _),		
			list::memberchk(OldProcessState, OldProcessStatesList),
			OldProcessState::update_process_state(ConceptIdentifiers, NewProcessState),
			list::selectchk(OldProcessState, 
							OldProcessStatesList, 
							NewProcessState,
							NewProcessStatesList
			),	
			TempNewModelState = model_state(NewProcessStatesList, _),
			!,
			extends_object(Process, process),
			Process::id(PID),
			(	Process::all_done(TempNewModelState) ->
				DoneCode is 1
				;
				DoneCode is 0
			),
			NewModelState = model_state(NewProcessStatesList, DoneCode).	
		
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	get_process_state/2
			- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */				
		:- public(get_process_state/2).
		:- mode(get_process_state(?process_identifier, ?process_state), 
				zero_or_one). 
		:- info(get_process_state/7, [
			comment is 'Retrieves a certain ProcessState for a given process-ID.']).
		
		get_process_state(PID, ProcessState) :-
			parameter(1, ProcessStatesList),
			ProcessState = process_state(PID, _),
			list:memberchk(ProcessState, ProcessStatesList).			
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	model_state_changes/7
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(model_state_changes/7).
		:- mode(model_state_changes(+state, ?process_identifier, ?instance_identifier, ?action, ?agents, ?data, ?tools), 
				zero_or_one). 
		:- info(model_state_changes/7, [
			comment is 'Retrieves elements that have changed between two different model states.']).

		model_state_changes(NextModelState, ExecutedProcess, Instance, Action, AgentList, DataList, ToolList) :-
			parameter(1, ProcessStatesList),
			NextModelState = model_state(NextProcessStatesList, _),
			list::subtract(NextProcessStatesList, ProcessStatesList, [process_state(ExecutedProcess, ProcessHistoryList)]),
			list::last(ProcessHistoryList, Instance-Action-AgentList-DataList-ToolList).
					
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	print/0
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */		
		:- public(print/0).
		:- mode(print, one).
		:- info(print/0, [
			comment is 'Prints some informations about the model state.']).
	
		print :-
			parameter(1, ProcessStatesList),
			parameter(2, ModelDoneCode),
			forall(	list::member(ProcessState, ProcessStatesList),
					ProcessState::print
			),
			write('\tModelDoneCode: '),
			write(ModelDoneCode).
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	print/1
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */		
		:- public(print/1).
		:- mode(print, one).
		:- info(print/1, [
			comment is 'Prints some informations about the model state into a stream.']).
	
		print(Stream) :-
			parameter(1, ProcessStatesList),
			parameter(2, ModelDoneCode),
			forall(	list::member(ProcessState, ProcessStatesList),
					ProcessState::print(Stream)
			),
			write(Stream, 'ModelDoneCode: '),
			write(Stream, ModelDoneCode).
			
:- end_object. 