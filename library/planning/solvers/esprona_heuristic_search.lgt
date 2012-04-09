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