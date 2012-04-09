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

:- object(esprona_hill_climbing(Threshold),
	instantiates(esprona_heuristic_search(Threshold))).

	:- info([
		version is 1.2,
		author is 'Written by Paulo Moura, adopted to ESProNa by Michael Igler',
		date is 2009/12/3,
		comment is 'Hill climbing heuristic state space search strategy.',
		parnames is ['Threshold']]).

	:- uses(list, [member/2, reverse/2, sort/2]).

	:- private(hill/9).

	search(ProcessModelID, Space, State, GoalState, Threshold, Solution, Cost) :-
		hill(ProcessModelID, Space, State, GoalState, Threshold, [], Path, 0, Cost),
		reverse(Path, Solution).

	hill(_, _, GoalState, GoalState, _, Path, [GoalState| Path], Cost, Cost).
	
	hill(ProcessModelID, Space, State, GoalState, Threshold, Path, Solution, SoFar, Total) :-
		findall((Estimate, Cost, Next),
				(	Space::next_state(ProcessModelID, State, Next, Cost),
             		\+ Space::member_path(Next, [State| Path]),
             		Space::heuristic(Next, Guess),
             		Estimate is Guess + Cost
				),
				States),
		sort(States, SortedStates),
		member((_, Cost2, Next2), SortedStates),
		SoFar2 is SoFar + Cost2,
		SoFar2 =< Threshold,
		hill(ProcessModelID, Space, Next2, GoalState, Threshold, [State| Path], Solution, SoFar2, Total).

:- end_object.