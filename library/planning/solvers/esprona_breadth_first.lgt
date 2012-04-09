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

:- object(esprona_breadth_first(Bound),
	instantiates(esprona_blind_search(Bound))).

	:- info([
		version is 1.2,
		author is 'Written by Paulo Moura, adopted to ESProNa by Michael Igler',
		date is 2009/12/3,
		comment is 'Breadth first state space search strategy.',
		source is 'Example adapted from the book "Prolog Programming for Artificial Intelligence" by Ivan Bratko.',
		parnames is ['Bound']]).

	:- uses(list, [member/2, reverse/2]).
	
	search(ProcessModelID, Space, FromState, ToState, Bound, Solution) :-
		breadth(ProcessModelID, Space, l(FromState), ToState, Bound, Path),
		reverse(Path, Solution).

	breadth(ProcessModelID, Space, Tree, ToState, Bound, Solution) :-
		expand(ProcessModelID, [], Tree, Tree2, Solved, Solution, Space, Bound, ToState),
		(	Solved == true ->
			true
		;	
			breadth(ProcessModelID, Space, Tree2, ToState, Bound, Solution)
		).

	expand(_, Path, l(ToState), _, true, [ToState| Path], _, _, ToState).
			
	expand(ProcessModelID, Path, l(FromState), t(FromState, Subs), fail, _, Space, Bound, _) :-
		Bound > 0,
		bagof(	l(Next), 
				(	Space::next_state(ProcessModelID, FromState, Next), 
					\+ Space::member_path(Next, [FromState| Path])
				), 
				Subs
		).
	
	expand(ProcessModelID, Path, t(FromState,Subs), t(FromState, Subs2), Solved, Solution, Space, Bound, ToState) :-
		expandall(ProcessModelID, [FromState| Path], Subs, [], Subs2, Solved, Solution, Space, Bound, ToState).

	expandall(_, _, [], [Tree| Trees], [Tree| Trees], fail, _, _, _, _).
	expandall(ProcessModelID, Path, [Tree| Trees], Trees2, Subs2, Solved, Solution, Space, Bound, ToState) :-
		(	Bound > 0,
			Bound2 is Bound -1,
			expand(ProcessModelID, Path, Tree, Tree2, Solved2, Solution, Space, Bound2, ToState),
			(	Solved2 == true ->
				Solved = true
			;	
				expandall(ProcessModelID, Path, Trees, [Tree2| Trees2], Subs2, Solved, Solution, Space, Bound, ToState)
			)
		;	expandall(ProcessModelID, Path, Trees, Trees2, Subs2, Solved, Solution, Space, Bound, ToState)
		).

:- end_object.