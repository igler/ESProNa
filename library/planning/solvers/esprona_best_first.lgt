%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ESProNa - 	Modeling, Execution and SmartNavigation(c) of Declarative Business Processes
%  Release 0.7
%  
%  Copyright (c) 2007-2011 Michael Igler.       All Rights Reserved.
%
%  Contact: 	Michael Igler (michael.igler@uni-bayreuth.de)
%				University of Bayreuth
%				Chair for Applied Computer Science IV
%				Databases and Information Systems
%				Universitaetsstrasse 30
%				D-95440 Bayreuth
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- object(esprona_best_first(Threshold),
	instantiates(esprona_heuristic_search(Threshold))).

	:- info([
		version is 1.2,
		author is 'Written by Paulo Moura, adopted to ESProNa by Michael Igler',
		date is 2008/6/9,
		comment is 'Best first heuristic state space search strategy.',
		source is 'Example adapted from the book "Prolog Programming for Artificial Intelligence" by Ivan Bratko.',
		parnames is ['Threshold']]).

	:- uses(list, [member/2, reverse/2]).

	:- private(expand/10).
	:- private(succlist/5).
	:- private(bestf/3).
	:- private(continue/11).
	:- private(f/2).
	:- private(insert/4).

	search(ProcessModelID, Space, State, GoalState, Threshold, Solution, Cost) :-
		expand(ProcessModelID, [], l(State, 0/0), Threshold, _, yes, Path, Space, GoalState, Cost),
		reverse(Path, Solution).

	expand(_, Path, l(GoalState,Cost/_), _, _, yes, [_|Path], _, GoalState, Cost).
	
	% expand/10	
	expand(ProcessModelID, Path, l(State,F/G), Threshold, Tree, Solved, Solution, Space, GoalState, Cost) :-
		F =< Threshold,
		(	bagof(Next/Cost2, (Space::next_state(ProcessModelID, State, Next, Cost2), \+ Space::member_path(Next, Path)), Successors) ->
			succlist(G, Successors, Trees, Threshold, Space),
			bestf(Trees, F2, Threshold),
			expand(ProcessModelID, Path, t(State, F2/G, Trees), Threshold, Tree, Solved, Solution, Space, GoalState, Cost)
      	;	
			Solved = never
		).
	expand(ProcessModelID, Path, t(State, F/G,[Tree| Trees]), Threshold, Tree3, Solved, Solution, Space, GoalState, Cost) :-
		F =< Threshold,
		bestf(Trees, Threshold2, Threshold),
		expand(ProcessModelID, [State|Path], Tree, Threshold2, Tree2, Solved2, Solution, Space, GoalState, Cost),
		continue(ProcessModelID, Path, t(State, F/G, [Tree2| Trees]), Threshold, Tree3, Solved2, Solved, Solution, Space, GoalState, Cost).
	expand(_, _, t(_, _, []), _, _, never, _, _, _) :-
		!.
	expand(_, _, Tree, Threshold, Tree, no, _, _, _) :-
		f(Tree, F),
		F > Threshold.

	continue(_, _, _, _, _, yes, yes, _, _, _, _).
	continue(ProcessModelID, Path, t(State, _/G, [Tree| Trees]), Threshold, Tree2, no, Solved, Solution, Space, GoalState, Cost) :-
		insert(Tree, Trees, NewTrees, Threshold),
		bestf(NewTrees, F, Threshold),
		expand(ProcessModelID, Path, t(State, F/G, NewTrees), Threshold, Tree2, Solved, Solution, Space, GoalState, Cost).
	continue(ProcessModelID, Path, t(State, _/G, [_| Trees]), Threshold, Tree2, never, Solved, Solution, Space, GoalState, Cost) :-
		bestf(Trees, F, Threshold),
		expand(ProcessModelID, Path, t(State, F/G, Trees), Threshold, Tree2, Solved, Solution, Space, GoalState, Cost).

	succlist(_, [], [], _, _).
	succlist(G0, [State/Cost| Rest], Trees, Threshold, Space) :-
		G is G0 + Cost,
		Space::heuristic(State, H),
		F is G + H,
		succlist(G0, Rest, Trees2, Threshold, Space),
		insert(l(State, F/G), Trees2, Trees, Threshold).

	insert(Tree, [], [Tree], _) :-
		!.
	insert(Tree, Trees, [Tree| Trees], Threshold) :-
		f(Tree, F),
		bestf(Trees, F2, Threshold),
		F =< F2,
		!.
	insert(Tree, [Tree1| Trees], [Tree1| Trees1], Threshold) :-
		insert(Tree, Trees, Trees1, Threshold).

	f(l(_, F/_), F).
	f(t(_, F/_, _), F).

	bestf([Tree| _], F, _) :-
		f(Tree, F).
	bestf([], Threshold, Threshold).

:- end_object.