:- object(heuristic_state_space,
	instantiates(class),
	specializes(state_space)).

	:- info([
		version is 1.1,
		author is 'Written by Paulo Moura, adopted to ESProNa by Michael Igler',
		date is 2011/3/20,
		comment is 'Heuristic state space description predicates including navigation.']).

	:- public(next_state/4).
	:- mode(next_state(+process_model, +nonvar, -nonvar, -number), zero_or_more).
	:- info(next_state/4,
		[comment is 'Generates a state sucessor.',
		 argnames is ['ProcessModelID', 'State', 'Next', 'Cost']]).

	:- public(heuristic/2).
	:- mode(heuristic(+nonvar, -number), one).
	:- info(heuristic/2,
		[comment is 'Estimates state distance to a goal state.',
		 argnames is ['State', 'Estimate']]).
				
	:- public(navigate/6).
	:- mode(navigate(+process_model, +list(state), ?list(state), ?list(path), ?var(costs), +term(conditions)), 
			zero_or_more).
	:- info(navigate/6, [
		comment is '...']).	

	next_state(ProcessModelID, Prev, Next) :-
		::next_state(ProcessModelID, Prev, Next, _).
		
	navigate(ProcessModelID, InState, ToState, Path, Conditions) :-
		::navigate(ProcessModelID, InState, ToState, Path, _, Conditions).

:- end_object.