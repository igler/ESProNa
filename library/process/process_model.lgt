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

:- object(process_model).

		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	   		id/1
		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */	
		:- public(id/1).
		:- mode(id(-model_id), one).
		:- info(id/1, [
			comment is 'The ID of the process model.']).
		
		id(MyID) :-
			self(Self),
			functor(Self, MyID, _).	
			
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	   		title/1
		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */	
		:- public(title/1).
		:- mode(title(-atom), one).
		:- info(title/1, [
			comment is 'The title of the process model.']).
				
				
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	   		contained processes/1
		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */	
		:- public(contains_processes/1).
		:- mode(contains_processes(?list), one).
		:- info(contains_processes/1, [
			comment is '...']).
			
		contains_processes(ProcessList) :-
			bagof( Process,
					(	::id(MyID),
						extends_object(Process, process),
						Process::contained_in_process_model(MyID)
					),
					ProcessList
			).
	
	
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	available_process_models/1
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */					
		:- public(available_process_models/1).
		:- mode(available_process_models(?process_model_id), zero_or_one).
		:- info(available_process_models/1, [
			comment is 'Retrieving available process models.']).
			
		available_process_models(Model_ID) :-
			logtalk_library_path(Model_ID, process_models(_)).
	
	
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	load/1
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */					
		:- public(load/1).
		:- mode(load(+var(file)), zero_or_one).
		:- info(load/1, [
			comment is 'Loading and instatiating process objects defined in a file.']).
			
		load(File) :-
			write(user_output, '+++ Loading process model...                                                  '),
			logtalk_load(File).
		
		
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	unload/0
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */	
		:- public(unload/0).
		:- mode(unload, zero_or_one).
		:- info(unload/0, [
			comment is 'Unloading all process objects.']).
		
		unload :-
			write('+++ Unloading process model...                                                '),
			::id(MyID),
			forall(	(	extends_object(Process, process),
						Process::contained_in_process_model(MyID)
					),
					abolish_object(Process)
			),
			abolish_object(MyID).
				
:- end_object.