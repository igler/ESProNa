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

:- object(helper_predicates).
	
		:- info([
			version is 0.8,
			date is 2011/03/03,
			author is 'Michael Igler (michael.igler@uni-bayreuth.de)',
			comment is '...']).
		
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	unify_ids/2
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(unify_ids/2).
		:- mode(unify_ids(+list, +list), zero_or_more). 
		:- info(unify_ids/2, [
			comment is 'Unifies Process-IDs.']).
		unify_ids([], _).
		unify_ids([Dep| Deps], Processes) :-
			list::memberchk(Dep, Processes),
			unify_ids(Deps, Processes).
		
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	list_to_conjunction/2
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */	
		:- public(list_to_conjunction/2).
		:- mode(list_to_conjunction(+list, -list), zero_or_one). 
		:- info(list_to_conjunction/2, [
			comment is 'Checks if a process is optional (its domain supremum is 0)']).
		list_to_conjunction([], true).
			list_to_conjunction([Goal| Rest], (Goal, Goals)) :-
			list_to_conjunction(Rest, Goals).

:- end_object.