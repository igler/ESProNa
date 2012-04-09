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

:- object(esprona_blind_search(_),
	instantiates(class),
	specializes(esprona_search_strategy)).

	:- info([
		version is 1.0,
		author is 'Written by Paulo Moura, adopted to ESProNa by Michael Igler',
		date is 2009/12/3,
		comment is 'Blind search state space strategies.',
		parnames is ['Bound']]).

	:- public(bound/1).
	:- mode(bound(?integer), zero_or_one).
	:- info(bound/1,
		[comment is 'Search depth bound.',
		 argnames is ['Bound']]).

	:- protected(search/6).
	:- mode(search(+process_model, +object, +nonvar, +nonvar, +integer, -list), zero_or_more).
	:- info(search/6,
		[comment is 'State space search solution.',
		 argnames is ['ProcessModelID', 'Space', 'FromState', 'ToState', 'Bound', 'Path']]).

	bound(Bound) :-
		parameter(1, Bound).

	solve(ProcessModelID, Space, FromState, ToState, Path) :-
		::bound(Bound),
		::search(ProcessModelID, Space, FromState, ToState, Bound, Path).

:- end_object.