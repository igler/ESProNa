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

:- category(functional_constraint).
	
		:- info([
			version is 0.8,
			date is 2010/04/19,
			author is 'Michael Igler (michael.igler@uni-bayreuth.de)',
			comment is 'This perspective is conform when the given functional constraints evaluate to true.']).
			
		:- public(functional_constraint/4).
		:- mode(functional_constraint(+list(actions), +modelstate, -instance_identifier, +callable), 
				zero_or_more).
		:- info(functional_constraint/4, [
			comment is 'Contains the POPM constraints of the functional perspective.']).		
					
		:- public(functional_constraint/5).
		:- mode(functional_constraint(+modal_prefix, +list(actions), +modelstate, -instance_identifier, +callable), 
				zero_or_more).
		:- info(functional_constraint/5, [
			comment is 'Contains the POPM constraints of the functional perspective.']).	


		% Functional constraints without modal prefix are necessary functional constraints.	
		functional_constraint(necessity, ActionList, ModelState, Instance, Constraints) :-
			::functional_constraint(ActionList, ModelState, Instance, Constraints).
					
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	functional_constraints_conform/3
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */		
		:- public(functional_constraints_conform/3).
		:- mode(functional_constraints_conform(?action, +modelstate, ?instance_identifier), 
				zero_or_more).
		:- info(functional_constraints_conform/3, [
			comment is 'This predicate expects: instantiated Action(+var), 
						 						instantiated ModelState(+list) and
												a free or instantiated Instance(?var).']).
						
		% 1st case: Action is in the list given by a functional_constraint
		functional_constraints_conform(Action, ModelState, Instance) :-
			bagof(	Constraints, 
					(	::functional_constraint(necessity, ActionList, ModelState, Instance, Constraints),
						list::member(Action, ActionList)
					),
					List
			),
			meta::map({call}, List).

		% 2nd case: No functional_constraint given
		functional_constraints_conform(_, ModelState, Instance) :-
			\+ ::functional_constraint(_, _, ModelState, Instance, _).

		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	counter_increasable/1
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(counter_increasable/1).
		:- mode(counter_increasable(+var), zero_or_one).
		:- info(counter_increasable/1, [
			comment is 'Verifies if the counter can be increased by 1. The current counter has to be smaller than supremum of the counter_interval.']).
		
		counter_increasable(Counter) :-
			::interval_supremum(IntervalSupremum),
			(	IntervalSupremum = sup -> 
				true
			;
				Counter < IntervalSupremum
			),
			!.
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	interval_supremum/1
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(interval_supremum/1).
		:- mode(interval_supremum(?var), zero_or_one). 
		:- info(interval_supremum/1, [
			comment is 'Retrieves the interval supremum of a process.']).
						
		interval_supremum(IntervalSupremum) :-
			::counter_interval(Interval),
			arg(2, Interval, IntervalSupremum).
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	interval_infimum/1
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(interval_infimum/1).
		:- mode(interval_infimum(?var), zero_or_one). 
		:- info(interval_infimum/1, [
			comment is 'Retrieves the interval infimum of a process.']).

		interval_infimum(IntervalInfimum) :-
			::counter_interval(Interval),
			arg(1, Interval, IntervalInfimum).
					
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	counter_interval/1
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(counter_interval/1).
		:- mode(counter_interval(-interval), one_or_more).
		:- info(counter_interval/1, [
			comment is 'Retrieves the interval of a process.']).
		
		counter_interval(Interval) :-
			findall(Process-(Deps-Domain), 
				    (
						extends_object(Process, process), 
						Process::process_domain(Deps, Domain)
					), 
					ProcessDepsDomains),
			pairs::keys_values(ProcessDepsDomains, Processes, DepsDomains),
			pairs::keys_values(DepsDomains, Deps, Domains),
			list::flatten(Deps, ListDeps),
			% Unify the upper list of Processes with ListDeps
			helper_predicates::unify_ids(ListDeps, Processes),
			meta::map({call}, Domains),
			self(Self),
			list::memberchk(Self, Processes),
			arg(1, Self, Var),
			clpfd:fd_dom(Var, Interval).
								
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	correlated_to_other_processes/1
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */	
		:- public(correlated_to_other_processes/1).
		:- mode(correlated_to_other_processes(+modelstate), zero_or_one).
		:- info(correlated_to_other_processes/1, [
			comment is 'Checks if the counter_interval of the process is dependent/correlated to other processes.']).
		
		correlated_to_other_processes(ModelState) :-
			(	::id(MyID),
				ModelState::get_process_state(MyID, ProcessState),
				ProcessState::instance_successtype_agents_data_tools_counter(_, start, _, _, _, Counter),
				% The counter must be increasable so correlation can take place
				::counter_increasable(Counter),				
				::process_domain(Refs, _), 
				Refs \= [] ->
				% First: There is a references in the domain of the process to other processes.
				true
			;	% OR second: It is referenced in the domain of other processes.
				self(Self),
				extends_object(Process, process),
				Process::process_domain(Refs, _),
				list::memberchk(Self, Refs) ->
				true		% We cut here, because one successful evaluation in the second case is already enough.
			).
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	exists_instance/3
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(exists_instance/3).
		:- mode(exists_instance(+modelstate, ?action, ?instance_identifier), zero_or_more). 
		:- info(exists_instance/3, [
			comment is 'Verifies if a certain instance has been executed in the given model state.']).

		exists_instance(ModelState, Action, Instance) :-
			instance_agent_data_tool(ModelState, Action, Instance, _, _, _).
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	actions_applicable/3
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */		
		:- public(actions_applicable/3).
		:- mode(actions_applicable(+modelstate, ?action, ?instance_identifier), zero_or_more). 
		:- info(actions_applicable/3, [
			comment is 'Checks of the actions are applicable in the given model state.']).

		actions_applicable(ModelState, start, Instance) :-
			% An instance can only be generated/started when the counter of the process is increasable.
			::id(PID),
			ModelState::get_process_state(PID, ProcessState),
			ProcessState::instance_successtype_agents_data_tools_counter(_, start, _, _, _, StartCounts),
			::counter_increasable(StartCounts),
			% Calculate the new Instance-ID:
			ProcessState::get_highest_instance_id(MaxIID),
			Instance is MaxIID + 1.
		
		actions_applicable(ModelState, Action, Instance) :-
			% There must exist a started 'Instance' ...
			::exists_instance(ModelState, start, Instance),
			% ... where none of the other actions have been performed yet.
			::process_actions(ActionList),
			list::member(Action, ActionList),
			list::member(DifferentAction, ActionList),
			Action \== start,
			Action \== DifferentAction,
			\+ ::exists_instance(ModelState, Action, Instance),
			\+ ::exists_instance(ModelState, DifferentAction, Instance).
					
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	in_domain/1
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(in_domain/1).
		:- mode(in_domain(+modelstate), zero_or_one). 
		:- info(in_domain/1, [
			comment is 'Checks if process counter is in the domain interval in a given model state.']).

		in_domain(ModelState) :-
			::id(PID),
			ModelState::get_process_state(PID, ProcessState),
			ProcessState::instance_successtype_agents_data_tools_counter(_, finish, _, _, _, Counter),
			::counter_interval(Interval),
			clpfd:(Counter in Interval).
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	all_done/1
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(all_done/1).
		:- mode(all_done(+modelstate), zero_or_one). 
		:- info(all_done/1, [
			comment is 'Checks if the counters of all processes build a solution in the given model state.']).

		all_done(ModelState) :-
			findall(Process-{PVar is Counter}, 
					(
					 	extends_object(Process, process), 
						Process::id(PID), 
						ModelState::get_process_state(PID, ProcessState),
						ProcessState::instance_successtype_agents_data_tools_counter(_, finish, _, _, _, Counter),
						arg(1, Process, PVar)
					), 
					ProcessesCounters),
			% write('ProcessesCounters: '), write(ProcessesCounters), nl,
			findall(Process-(Deps-{Domain}), 
				    (
						extends_object(Process, process), 
					 	Process::process_domain(Deps, Domain)
					), 
					ProcessDepsDomains),
			pairs::keys_values(ProcessDepsDomains, Processes, DepsDomains),
			pairs::keys_values(ProcessesCounters, ProcessesCs, CounterSituation),
			pairs::keys_values(DepsDomains, Deps, Domains),
			list::append(Domains, CounterSituation, Query),
			list::flatten(Deps, ListDeps),
			helper_predicates::unify_ids(ListDeps, Processes),
			helper_predicates::unify_ids(ProcessesCs, Processes),
			meta::map(call, Query).
							
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	instance_agent_data_tool/6
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(instance_agent_data_tool/6).
		:- mode(instance_agent_data_tool(	+modelstate, +action, ?instance_identifier, ?list(agent_identifiers), ?list(data_identifiers), ?list(tool_identifiers)), 			
											zero_or_one). 
		:- info(instance_agent_data_tool/6, [
			comment is 'Returns which instances are started/finished/aborted in a given model state. 
						Lists of agents, data and tools are also retrieved expressing more detailed information about the execution.']).

		instance_agent_data_tool(ModelState, Action, Instance, AgentList, DataList, ToolList) :-
			::id(MyID),
			ModelState::get_process_state(MyID, ProcessState),
			ProcessState::instance_successtype_agents_data_tools(Instance, Action, AgentList, DataList, ToolList).
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	optional/0
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(optional/0).
		:- mode(optional, zero_or_one). 
		:- info(optional/0, [
			comment is 'Checks if a process is optional.']).

		optional :-
			::interval_infimum(0),
			!.
			
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	highest_instance_id/2
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- public(highest_instance_id/2).
		:- mode(highest_instance_id(+list, -number), zero_or_one). 
		:- info(highest_instance_id/2, [
			comment is 'Retrieves highest instance-ID of a process.']).

		highest_instance_id(ModelState, MaxIID) :-
			::id(MyID),
			ModelState::get_process_state(MyID, ProcessState),
			ProcessState::get_highest_instance_id(MaxIID).	
			
:- end_category.