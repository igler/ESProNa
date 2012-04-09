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
/*
{
	{	
		Time:	20110706_135223,
		Action: start,
		Process/Instance: pid_0/1,
		Agent: [http://ai4.inf.uni-bayreuth.de/ontology/individuals#Jack],
		Data: [],
		Tool: [HIS],
		Costs: 1	
	}

	{	
		Time:	20110706_140203,
		Action: start,
		Process/Instance: pid_0/1,
		Agent: [http://ai4.inf.uni-bayreuth.de/ontology/individuals#John],
		Data: [],
		Tool: [HIS],
		Costs: 1	
	}
	...
}
*/

:- object(export_state_transitions,
	implements(monitoring)).
	
		:- info([
			version is 0.8,
			date is 2011/03/03,
			author is 'Michael Igler (michael.igler@uni-bayreuth.de)',
			comment is 'export_file to file exporter.']).
			
		:- uses(event_registry, [set_monitor/4, del_monitors/4]).
		
		:- public(file/1).
		:- dynamic(file/1).	
		
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			   	start_export/1
		  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(start_export/1).
		start_export(File) :-
			::assertz(file(File)),
			open(File, write, _, [alias(export_file)]),
			self(Self),
			event_registry::set_monitor(_, solve(_, _, _, _), _, Self),		% ... my_searchers
			event_registry::set_monitor(_, solve(_, _, _, _, _), _, Self),	% ... my heuristic searchers
			after_event_registry::set_monitor(_, next_state(_, _), _, Self),
			after_event_registry::set_monitor(_, next_state(_, _, _), _, Self).
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			   	finish_export/0
		  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */		
		:- public(finish_export/0).
		finish_export :-
			self(Self),
			del_monitors(_, _, _, Self),
			close(export_file),
			::retractall(file(_)).

		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			   	before/3
		  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */		
		before(_, solve(_, _, _), _) :-	
			write(export_file, '{'),
			nl(export_file).
			
		before(_, solve(_, _, _, _), _) :-
			write(export_file, '{'),
			nl(export_file).	
		
		before(_, solve(_, _, _, _, _), _) :-
			write(export_file, '{'),
			nl(export_file).
								
		before(_, next_state(_, _), _).
		
		before(_, next_state(_, _, _), _).
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			   	after/3
		  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */		
		after(_, solve(_, _, _), _) :-
			write(export_file, '}'),
			nl(export_file).
					
		after(_, solve(_, _, _, _), _) :-
			write(export_file, '}'),
			nl(export_file).
		
		after(_, solve(_, _, _, _, _), _) :-
			write(export_file, '}'),
			nl(export_file).
							
		after(_, next_state(ModelState, NextModelState), _) :-
			ModelState::model_state_changes(NextModelState, ExecutedProcess, Instance, Action, AgentList, DataList, ToolList),
			write(export_file, '\t{'), nl(export_file),
			get_time(TimeStamp),
			write(export_file, '\t\tTime: '), write(export_file, TimeStamp), write(export_file, ','), nl(export_file),
			write(export_file, '\t\tAction: '), write(export_file, Action), write(export_file, ','), nl(export_file),
			write(export_file, '\t\tProcess/Instance: '), write(export_file, ExecutedProcess),
			write(export_file, '/'), write(export_file, Instance), write(export_file, ','), nl(export_file),
			write(export_file, '\t\tAgent: '), write(export_file, AgentList), write(export_file, ','), nl(export_file),
			write(export_file, '\t\tData: '), write(export_file, DataList), write(export_file, ','), nl(export_file),
			write(export_file, '\t\tTool: '), write(export_file, ToolList), 
			nl(export_file),
			write(export_file, '\t}'), nl(export_file), nl(export_file),
			flush_output(export_file).			
	
		after(_, next_state(ModelState, NextModelState, Costs), _) :-
			ModelState::model_state_changes(NextModelState, ExecutedProcess, Instance, Action, AgentList, DataList, ToolList),
			write(export_file, '\t{'), nl(export_file),
			get_time(TimeStamp),
			write(export_file, '\t\tTime: '), write(export_file, TimeStamp), write(export_file, ','), nl(export_file),
			write(export_file, '\t\tAction: '), write(export_file, Action), write(export_file, ','), nl(export_file),
			write(export_file, '\t\tProcess/Instance: '), write(export_file, ExecutedProcess), 
			write(export_file, '/'), write(export_file, Instance), write(export_file, ','), nl(export_file),
			write(export_file, '\t\tAgent: '), write(export_file, AgentList), write(export_file, ','), nl(export_file),
			write(export_file, '\t\tData: '), write(export_file, DataList), write(export_file, ','), nl(export_file),
			write(export_file, '\t\tTool: '), write(export_file, ToolList), write(export_file, ','), nl(export_file),
			write(export_file, '\t\tCosts: '), write(export_file, Costs), 
			nl(export_file),
			write(export_file, '\t}'), nl(export_file), nl(export_file),
			flush_output(export_file).
				
:- end_object.