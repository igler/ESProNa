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

:- object(graphviz,
	implements(monitoring)).
	
		:- info([
			version is 0.8,
			date is 2011/03/03,
			author is 'Michael Igler (michael.igler@uni-bayreuth.de)',
			comment is 'dot-file exporter.']).
			
		:- uses(event_registry, [set_monitor/4, del_monitors/4]).
		
		:- public(file/1).
		:- dynamic(file/1).	
		
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			   	start_export/1
		  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(start_export/1).
		start_export(File) :-
			::assertz(file(File)),
			open(File, write, _, [alias(graphviz)]),
			self(Self),
			event_registry::set_monitor(_, solve(_, _, _, _, _), _, Self),		% ... blind search algorithms
			event_registry::set_monitor(_, solve(_, _, _, _, _, _), _, Self),	% ... heuristic search algorithms
			after_event_registry::set_monitor(_, next_state(_, _, _), _, Self),
			after_event_registry::set_monitor(_, next_state(_, _, _, _), _, Self).
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			   	finish_export/4
		  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */		
		:- public(finish_export/4).
		finish_export(HighlightModelState, HighlightPath, ColorGoalModelState, ColorPath) :-
			self(Self),
			del_monitors(_, _, _, Self),
			write(graphviz, '}'),
			close(graphviz),
			::file(File),
			% Highlight the goal-state in the dot-file
			highlight_state(File, HighlightModelState, ColorGoalModelState),
			% Highlight the solution-path in the dot-file
			highlight_path(File, HighlightPath, ColorPath),
			::retractall(file(_)).
			
		highlight_state(File, HighlightModelState, Color) :-
			{term_to_atom(HighlightModelState, HighlightModelStateAtom)},
			CallStringPerlProgram = '/usr/bin/perl ./library/planning/visualize/highlight_state.pl',			
			atomic_list_concat(['"', HighlightModelStateAtom, '"'], '', HighlightModelStateString),
			atomic_list_concat([CallStringPerlProgram, File, HighlightModelStateString, Color], ' ', CallString),		
			{shell(CallString)}.

			
		highlight_path(File, HighlightPath, Color) :-
			forall(	list::member(ModelState, HighlightPath),
					highlight_state(File, ModelState, Color)
			),
			CallStringPerlProgram = '/usr/bin/perl ./library/planning/visualize/highlight_path.pl ',
			forall(	::list_pairs((FirstModelState, SecondModelState), HighlightPath),
					(	{term_to_atom(FirstModelState, FirstModelStateAtom)},
						{term_to_atom(SecondModelState, SecondModelStateAtom)},
						atomic_list_concat(['"', FirstModelStateAtom], '', FirstModelStateString),
						atomic_list_concat([SecondModelStateAtom, '"'], '', SecondModelStateString),
						atomic_list_concat([CallStringPerlProgram, File, FirstModelStateString, '->', SecondModelStateString, Color], ' ', CallString),
						{shell(CallString)}
					)
			).
			
		:- private(list_pairs/2).	
		list_pairs((A, B), L) :-
			list::member(A, L),
			list::nextto(A, B, L).	

		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			   	before/3
		  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */		
		before(_, solve(_, _, _, _, _), _) :-
			write(graphviz, 'digraph untitled \n{\n size = "30,30";\n'),
			nl(graphviz).	
		
		before(_, solve(_, _, _, _, _, _), _) :-
			write(graphviz, 'digraph untitled \n{\n size = "30,30";\n'),
			nl(graphviz).
								
		before(_, next_state(_, _), _).
		
		before(_, next_state(_, _, _), _).
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			   	after/3
		  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */						
		after(_, solve(_, _, _, _, _), _).
		
		after(_, solve(_, _, _, _, _, _), _).
							
		after(_, next_state(_, ModelState, NextModelState), _) :-
			ModelState::model_state_changes(NextModelState, ExecutedProcess, Instance, Action, AgentList, DataList, ToolList),
			% Write the ModelState/NextModelState edges	
			write(graphviz, '\t'), write(graphviz, '"'), ModelState::print(graphviz), write(graphviz, '" -> "'), NextModelState::print(graphviz),
			write(graphviz, '" [label="'),
			write(graphviz, 'Action: '),
			write(graphviz, Action),
			write(graphviz, ',\\nProcess/Instance: '), write(graphviz, ExecutedProcess), write(graphviz, '/'), write(graphviz, Instance),
			write(graphviz, ',\\nAgent: '), write(graphviz, AgentList), 
			write(graphviz, ',\\nData: '), write(graphviz, DataList), 
			write(graphviz, ',\\nTool: '), write(graphviz, ToolList), 
			write(graphviz, '"'), 
			write(graphviz, ' style="setlinewidth(0.75)" color="#666666" fontcolor="#666666" fontname="Helvetica" fontsize="8"];'),
			% Write the ModelState node 
			nl(graphviz),
			write(graphviz, '\t'), write(graphviz, '"'), ModelState::print(graphviz), write(graphviz, '" '), 
			write(graphviz, '[label="'), ModelState::print(graphviz), write(graphviz, '" shape=box color="#666666", fontcolor="#666666", fontname="Helvetica" fontsize="8", style="rounded, setlinewidth(0.75)"];'),
			nl(graphviz),
			% Write the NextModelState node
			write(graphviz, '\t'), write(graphviz, '"'), NextModelState::print(graphviz), write(graphviz, '" '), 
			write(graphviz, '[label="'), NextModelState::print(graphviz), write(graphviz, '" shape=box color="#666666", fontcolor="#666666", fontname="Helvetica" fontsize="8", style="rounded, setlinewidth(0.75)"];'),
			nl(graphviz),
			flush_output(graphviz).			
	
		after(_, next_state(_, ModelState, NextModelState, Costs), _) :-
			ModelState::model_state_changes(NextModelState, ExecutedProcess, Instance, Action, AgentList, DataList, ToolList),
			% Write the ModelState/NextModelState edges	
			write(graphviz, '\t'), write(graphviz, '"'), ModelState::print(graphviz), write(graphviz, '" -> "'), NextModelState::print(graphviz),
			write(graphviz, '" [label="'),
			write(graphviz, 'Action: '),
			write(graphviz, Action),
			write(graphviz, ',\\nProcess/Instance: '), write(graphviz, ExecutedProcess), write(graphviz, '/'), write(graphviz, Instance),
			write(graphviz, ',\\nAgent: '), write(graphviz, AgentList), 
			write(graphviz, ',\\nData: '), write(graphviz, DataList), 
			write(graphviz, ',\\nTool: '), write(graphviz, ToolList), 
			write(graphviz, ',\\nCosts: '), write(graphviz, Costs), 
			write(graphviz, '"'), 
			write(graphviz, ' style="setlinewidth(0.75)" color="#666666" fontcolor="#666666" fontname="Helvetica" fontsize="8"];'),
			% Write the ModelState node 
			nl(graphviz),
			write(graphviz, '\t'), write(graphviz, '"'), ModelState::print(graphviz), write(graphviz, '" '), 
			write(graphviz, '[label="'), ModelState::print(graphviz), write(graphviz, '" shape=box color="#666666", fontcolor="#666666", fontname="Helvetica" fontsize="8", style="rounded, setlinewidth(0.75)"];'),
			nl(graphviz),
			% Write the NextModelState node
			write(graphviz, '\t'), write(graphviz, '"'), NextModelState::print(graphviz), write(graphviz, '" '), 
			write(graphviz, '[label="'), NextModelState::print(graphviz), write(graphviz, '" shape=box color="#666666", fontcolor="#666666", fontname="Helvetica" fontsize="8", style="rounded, setlinewidth(0.75)"];'),
			nl(graphviz),
			flush_output(graphviz).
				
:- end_object.