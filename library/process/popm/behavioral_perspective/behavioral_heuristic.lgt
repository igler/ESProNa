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

:- object(behavioral_heuristic,
	implements(heuristic_protocol)).
			
		:- info([
			version is 0.8,
			date is 2011/04/6,
			author is 'Michael Igler (michael.igler@uni-bayreuth.de)',
			comment is 'Predicates for heuristic searching and planning algorithms of the behavioral perspective.']).
					
		costs_do_process(Process, Action, ModelState, _, _, Costs) :-
			set_up_graph(Action, Graph),
			max_incoming_edges(Graph, ModelState, MaxIncEdges),
			count_incoming_edges(Process, ModelState, Graph, CIncomingEdgesProcess),
			Costs is MaxIncEdges - CIncomingEdgesProcess.
				
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	set_up_graph/2
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */		
		:- public(set_up_graph/2).
		:- mode(set_up_graph(+var(action), -graph), 
				one). 
		:- info(set_up_graph/2, [
			comment is 'Sets up a graph representing the dependencies between the different processes.']).
					
		set_up_graph(Action, Graph) :-
			findall(Proc-List, 
			        (	extends_object(Proc, process),
						bagof(	Constraints,
								(	Proc::behavioral_constraint(necessity, ActionList, _, _, Constraints),
									list::member(Action, ActionList)
								),
								List
						)
					),
					Proc_DepProcs
			),
			findall(M-CleanDepList,
					(	list::member(M-DepList, Proc_DepProcs),	
						clean_dep_list(DepList, CleanDepList)
					),
					Edges4Graph
			),
			ugraphs:edges(Edges4Graph, Graph).	
		

		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	max_incoming_edges/2
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		max_incoming_edges(Graph, ModelState, MaxIncEdges) :-	
			findall(Count,
					(	extends_object(Process, process),
						count_incoming_edges(Process, ModelState, Graph, Count)
					),
					Counts
			),
			numberlist::max(Counts, MaxIncEdges).
			


		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	count_incoming_edges/4
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		count_incoming_edges(Process, ModelState, Graph, Count) :-
			% Done processes aren't recognized for the evaluation of incoming edges
			\+ Process::in_domain(ModelState),
			count(Graph, Process, Count).
		
		
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	count/3
			Counts the incoming edges into a given process for a given graph.	
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		count(Graph, Process, Count) :-
			count(Graph, Process, 0, Count).


		count([], _, Count, Count).
		
		count([_-Process| Graph], Process, Count0, Count) :-
			!,
			Count1 is Count0 + 1,
			count(Graph, Process, Count1, Count).
		
		count([_| Graph], Process, Count0, Count) :-
			count(Graph, Process, Count0, Count).
	
		
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	clean_dep_list/2,3
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */	
		clean_dep_list(DirtyList, CleanList) :-
			clean_dep_list(DirtyList, [], CleanList).
			
		clean_dep_list([DP::_], CleanListAcc, CleanList) :-
			list::append(CleanListAcc, [DP], CleanList),
			!.
			
		clean_dep_list([DP::_ | T], CleanListAcc, CleanList) :-
			list::append(CleanListAcc, [DP], CL),
			clean_dep_list(T, CL, CleanList),
			!.
			
		clean_dep_list([(Conjunction)], CleanListAcc, CleanList) :-	
			conjunction_to_list(Conjunction, List),
			clean_dep_list(List, CleanListAcc, CleanList),
			!.
		
		
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	conjunction_to_list/2
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		conjunction_to_list(Term, [Term]) :-
		   var(Term),
		   !.
		
		conjunction_to_list((Term, Conjunction), [Term| Terms]) :-
		   !,
		   conjunction_to_list(Conjunction, Terms).

		conjunction_to_list(Term, [Term]).
				
			
:- end_object.