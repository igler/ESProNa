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