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

:- object(esprona_depth_first(Bound),
	instantiates(esprona_blind_search(Bound))).

	:- info([
		version is 1.2,
		author is 'Written by Paulo Moura, adopted to ESProNa by Michael Igler',
		date is 2009/12/3,
		comment is 'Depth first state space search strategy.',
		parnames is ['Bound']]).

	:- uses(list, [member/2, reverse/2]).

	search(ProcessModelID, Space, FromState, ToState, Bound, Solution) :-
		depth(ProcessModelID, Space, FromState, ToState, Bound, [], Path),
		reverse(Path, Solution).

	depth(_, _, ToState, ToState, _, Path, [ToState| Path]).
		
	depth(ProcessModelID, Space, FromState, ToState, Bound, Path, Solution) :-
		Bound > 0,
		Space::next_state(ProcessModelID, FromState, Next),
		\+ Space::member_path(Next, [FromState| Path]),
		Bound2 is Bound - 1,
		depth(ProcessModelID, Space, Next, ToState, Bound2, [FromState| Path], Solution).
	
:- end_object.