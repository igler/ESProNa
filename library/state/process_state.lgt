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

:- object(process_state(_Process_ID, _Process_History)).

		:- info([
			version is 0.8,
			date is 2010/04/19,
			author is 'Michael Igler (michael.igler@uni-bayreuth.de)',
			comment is 'Represents the state of a process containing Process_ID, Process_History_List, Process_Status.']).

		/*	process_state:				A compound term of (Process_ID, Process_History)
					
			_Process_ID: 				e.g. pid_a, pid_b, ...

			_Process_History: 			The process history at the moment is a compound term of 
										Process-Instance-ID, Status Code and agent 
										who started it:
								
										Process-Instance-ID: 			1,2,3, ... 
										Process-Instance-Status-Code: 	start, finish, abort, etc.
										AgentList: 						List of agent(s)
										DataList:						List of data item(s)
										ToolList:						List of used tool(s)
		
										e.g. [1-start-[p1]-[]-[], 1-finish-[p2]-[]-[], 2-start-[p2, p4]-[]-[], 3-start-[p2]-[]-[]] 
										means: 	process instance 1 started by agent p1 with data [] and toos []
												process instance 1 finished by agent p2 ...
												process instance 2 started by agent p2 and p4 (four eye principle) ...
												process instance 3 sarted by agent p2 ...
		*/	
		
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	get_highest_instance_id/1
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(get_highest_instance_id/1).
		:- mode(get_highest_instance_id(-number), one).
		:- info(get_highest_instance_id/1, [
			comment is 'Retrieves the highest instance-ID of the process.']).
		
		get_highest_instance_id(MaxIID) :-
			parameter(2, HistoryList),
			(	HistoryList = [] ->
				MaxIID is 0
				;
				list::max(HistoryList, (MaxIID-_-_-_-_))
			).
					
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	update_process_state/2
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(update_process_state/2).
		:- mode(update_process_state(+compound_term(concept_identifiers), -process_state), one).
		:- info(update_process_state/2, [
			comment is 'Updates a process state.']).
		
		update_process_state(ConceptIdentifiers, NewProcessState) :-
			parameter(1, Process_ID),
			parameter(2, OldProcess_History),
			TempProcessHistory = [OldProcess_History, ConceptIdentifiers],
			list::flatten(TempProcessHistory, NewProcessHistory),									
			NewProcessState = process_state(Process_ID, NewProcessHistory).
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	instance_successtype_agents_data_tools/5
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */	
		:- public(instance_successtype_agents_data_tools/5).
		:- mode(instance_successtype_agents_data_tools(+instance_identifier, +action, +agent, +data, +tool), 
				zero_or_one). 
		:- info(instance_successtype_agents_data_tools/5, [
			comment is 'Retrieves information about a certain execution.']).
		
		instance_successtype_agents_data_tools(Instance, Action, AgentList, DataList, ToolList) :-
			parameter(2, HistoryList),
			list::member((Instance-Action-AgentList-DataList-ToolList), HistoryList).
	
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	instance_successtype_agents_data_tools_counter/6		
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */	
		:- public(instance_successtype_agents_data_tools_counter/6).
		:- mode(instance_successtype_agents_data_tools_counter(+instance_identifier, +action, +agent, +data, +tool, -number), 
				zero_or_one). 
		:- info(instance_successtype_agents_data_tools_counter/6, [
			comment is 'Counts the executions by a certain person with certain data and tools.']).
			
		instance_successtype_agents_data_tools_counter(Instance, Action, AgentList, DataList, ToolList, Count) :-
			parameter(2, HistoryList),
			count(HistoryList, Instance, Action, AgentList, DataList, ToolList, Count).		
		
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	count/7
			Counts special elements (instance-successtype-agent-data-tool) in the historylist of the state.
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */	
		count([], _, _, _, _, _, 0) :-
			!.
		count(HistoryList, Instance, SuccessType, AgentList, DataList, ToolList, Count) :-
			findall(Instance-SuccessType-AgentList-DataList-ToolList, 
					list::member(Instance-SuccessType-AgentList-DataList-ToolList, HistoryList), 
					SolutionList),
			list::length(SolutionList, Count).		
						
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	print/0
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */		
		:- public(print/0).
		:- mode(print, one).
		:- info(print/0, [
			comment is 'Prints some informations about the state.']).

		print :-
			self(Self),
			write('\t'),
			write(Self), 
			nl.
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	print/1
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */		
		:- public(print/1).
		:- mode(print(+var), one).
		:- info(print/1, [
			comment is 'Prints some informations about the process state to a stream alias.']).

		print(StreamAlias) :-
			parameter(1, Process_ID),
			parameter(2, Process_History),
			write(StreamAlias, Process_ID),
			write(StreamAlias, ': '),
			write(StreamAlias, Process_History), 
			write(StreamAlias, '\\n').
						
:- end_object. 