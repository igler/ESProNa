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

:- object(esprona_heuristic_search(_),
	instantiates(class),
	specializes(esprona_search_strategy)).

	:- info([
		version is 1.0,
		author is 'Written by Paulo Moura, adopted to ESProNa by Michael Igler',
		date is 2009/12/3,
		comment is 'Heuristic state space search strategies.',
		parnames is ['Threshold']]).

	:- public(threshold/1).
	:- mode(threshold(?number), one).
	:- info(threshold/1,
		[comment is 'Search cost threshold.',
		 argnames is ['Threshold']]).

	:- public(solve/6).
	:- mode(solve(+process_model, +object, +nonvar, +nonvar, -list, -number), zero_or_more).
	:- info(solve/6,
		[comment is 'State space search solution.',
		 argnames is ['ProcessModel', 'Space', 'State', 'GoalState', 'Path', 'Cost']]).

	:- protected(search/7).
	:- mode(search(+process_model, +object, +nonvar, +nonvar, +number, -list, -number), zero_or_more).
	:- info(search/7,
		[comment is 'State space search solution.',
		 argnames is ['ProcessModel', 'Space', 'State', 'GoalState', 'Threshold', 'Path', 'Cost']]).

	solve(ProcessModelID, Space, State, GoalState, Path) :-
		::solve(ProcessModelID, Space, State, GoalState, Path, _).

	solve(ProcessModelID, Space, State, GoalState, Path, Cost) :-
		::threshold(Threshold),
		::search(ProcessModelID, Space, State, GoalState, Threshold, Path, Cost).

	threshold(Threshold) :-
		parameter(1, Threshold).

:- end_object.