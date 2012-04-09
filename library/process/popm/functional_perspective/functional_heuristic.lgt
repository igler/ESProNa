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

:- object(functional_heuristic,
	implements(heuristic_protocol)).
		
		:- info([
			version is 0.8,
			date is 2011/04/6,
			author is 'Michael Igler (michael.igler@uni-bayreuth.de)',
			comment is 'Predicates for heuristic searching and planning algorithms of the functional perspective.']).

		costs_do_process(Process, Action, ModelState, _, _, Costs_FU) :-
			bagof(	Costs,
					::costs_do_process(Process, ModelState, Action, Costs),
					Cost_List
			),
			numberlist::sum(Cost_List, Costs_FU).
			
						
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		   	costs_do_process/4
		   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		:- private(costs_do_process/4).
		:- mode(costs_do_process(+process_object, +modelstate, +var(action), -number), zero_or_one). 
		:- info(costs_do_process/4, [
			comment is 'Calculates the costs for executing a given process ID.']).
								
		costs_do_process(Process, ModelState, start, Costs) :-
			Process::interval_infimum(IntervalInfimum),
			Process::id(PID),	
			ModelState::get_process_state(PID, ProcessState),
			ProcessState::instance_successtype_agents_data_tools_counter(_, start, _, _, _, Times),
			!,
			(	Times < IntervalInfimum ->
				Costs is 0 	% We do not have reached the interval infimum:
				;
				Costs is 1	% We are over the interval infimum:
			).
			
		% Restrict the started and/but not finished processes to a minimum.
		costs_do_process(Process, ModelState, start, Costs) :-
			findall(	FInstance, 
						Process::finishable_instance(ModelState, FInstance),
						FinishableInstances
			),
			!,
			list::length(FinishableInstances, Costs).			
						
		% Finishing an active process instance instead of starting a second one has lower costs.	
		costs_do_process(Process, ModelState, finish, Costs) :-
			% There must be a started 'Instance' that is not finished yet
			Process::actions_applicable(ModelState, finish, Instance),
			Process::id(PID),	
			ModelState::get_process_state(PID, ProcessState),
			ProcessState::instance_successtype_agents_data_tools_counter(_, start, Instance, _, _, StartCounts),
			ProcessState::instance_successtype_agents_data_tools_counter(_, finish, Instance, _, _, FinishCounts),
			!,
			Costs is StartCounts - FinishCounts - 1.
		
		% Aborting has higher costs than start or finish	
		costs_do_process(Process, ModelState, abort, CostsAbort) :-
			costs_do_process(Process, ModelState, start, CostsStart),
			costs_do_process(Process, ModelState, finish, CostsFinish),
			CostsAbort is CostsStart + CostsFinish + 1.
				
:- end_object.