:- object(state_space,
	instantiates(class),
	specializes(object)).

	:- info([
		version is 1.2,
		author is 'Written by Paulo Moura, adopted to ESProNa by Michael Igler',
		date is 2011/3/20,
		comment is 'State space description predicates including navigation.']).

	:- public(initial_state/2).
	:- mode(initial_state(+process_model, ?nonvar), one_or_more).
	:- info(initial_state/2,
		[comment is 'Initial state.',
		 argnames is ['ProcessModelID', 'State']]).

	:- public(goal_state/2).
	:- mode(goal_state(+process_model, ?nonvar), one_or_more).
	:- info(goal_state/2,
		[comment is 'Goal state.',
		 argnames is ['ProcessModelID', 'State']]).

	:- public(next_state/3).
	:- mode(next_state(+process_model, +nonvar, -nonvar), zero_or_more).
	:- info(next_state/3,
		[comment is 'Generates a state sucessor.',
		 argnames is ['ProcessModelID', 'State', 'Next']]).

	:- public(member_path/2).
	:- mode(member_path(+nonvar, +list), zero_or_one).
	:- info(member_path/2,
		[comment is 'True if a state is member of a list of states.',
		 argnames is ['State', 'Path']]).

	:- public(navigate/5).
	:- mode(navigate(+process_model, +list(state), ?list(state), ?list(path), +term(conditions)), 
			zero_or_more).
	:- info(navigate/5, [
		comment is '...']).
			
	:- public(print_state/1).
	:- mode(print_state(+nonvar), one).
	:- info(print_state/1,
		[comment is 'Pretty print state.',
		 argnames is ['State']]).

	:- public(print_path/1).
	:- mode(print_path(+list), one).
	:- info(print_path/1,
		[comment is 'Pretty print a path (list of states).',
		 argnames is ['Path']]).
		
	print_state(State) :-
		writeq(State), nl.

	member_path(State, [State| _]) :-
		!.
	member_path(State, [_| Path]) :-
		member_path(State, Path).

	print_path([]).
	print_path([State| States]) :-
		::print_state(State),
		print_path(States).

:- end_object.