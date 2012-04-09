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

:- multifile(logtalk_library_path/2).
:- dynamic(logtalk_library_path/2).

:- use_module(library(aggregate)).
:- use_module(library(clpfd)).
:- use_module(library(lists)).

% JSON support
:- use_module(library('http/json')).
:- use_module(library('http/json_convert')).
:- use_module(library('http/http_json')).

% REST support
:- use_module(library('http/thread_httpd')).
:- use_module(library('http/http_wrapper')).
:- use_module(library('http/http_dispatch')).
:- use_module(library('http/html_write')).

logtalk_library_path(esprona, './').
logtalk_library_path(esprona_library, esprona('library/')).
logtalk_library_path(esprona_contributions, esprona('contributions/')).
logtalk_library_path(rest, esprona_library('REST/')).
logtalk_library_path(planning, esprona_library('planning/')).
logtalk_library_path(process, esprona_library('process/')).
logtalk_library_path(state, esprona_library('state/')).
logtalk_library_path(utilities, esprona_library('utilities/')).
logtalk_library_path(solvers, planning('solvers/')).
logtalk_library_path(visualize, planning('visualize/')).
logtalk_library_path(debug, esprona_contributions('debug/')).
logtalk_library_path(performance, esprona_contributions('performance/')).
logtalk_library_path(popm, process('popm/')).
logtalk_library_path(fu_perspective, popm('functional_perspective/')).
logtalk_library_path(be_perspective, popm('behavioral_perspective/')).
logtalk_library_path(org_perspective, popm('organizational_perspective/')).
logtalk_library_path(data_perspective, popm('data_perspective/')).
logtalk_library_path(op_perspective, popm('operational_perspective/')).
logtalk_library_path(heuristics, popm('heuristics/')).

% location process models
logtalk_library_path(process_models, esprona('process_models/')).
logtalk_library_path(set_up_surgery_plan_extended, process_models('set_up_surgery_plan_extended/')).
logtalk_library_path(be_dep_test, process_models('be_dep_test/')).

% location unit tests
logtalk_library_path(unit_tests, esprona('unit_tests/')).
logtalk_library_path(unit_test_1, unit_tests('unit_test_1/')).

:- initialization((	
	logtalk_load(library(types_loader)),
	logtalk_load(library(metapredicates_loader)),
	logtalk_load(metapredicates(loader)),
	logtalk_load(library(pairs), [reload(skip)]),
	logtalk_load(library(dates_loader)),	
	logtalk_load(roots(loader)),
	
	write('                                                                                     '), nl,
	write('	___________ ___________________                _______                              '), nl,        
	write('	\\_   _____//   _____/\\______   \\_______  ____  \\      \\ _____                  '), nl, 
	write('	 |    __)_ \\_____  \\  |     ___/\\_  __ \\/  _ \\ /   |   \\\\__  \\              '), nl, 
	write('	 |        \\/        \\ |    |     |  | \\(  <_> )    |    \\/ __ \\_               '), nl, 
	write('	/_______  /_______  / |____|     |__|   \\____/\\____|__  (____  /                  '), nl, 
	write('	        \\/        \\/                                  \\/     \\/                 '), nl,
	write('+++ Modeling, Execution and Navigation of Declarative Business Processes +++         '), nl,
	write('                                                                                     '), nl,
	
	write('+++ Loading (modified) OWL2 parser Thea2...'),
	ensure_loaded('contributions/thea2/owl2_to_logtalk.pl'),
	ensure_loaded('contributions/thea2/swrl_rdf_hooks'),
	nl,

	write('+++ Loading state-space definitions...'),
	logtalk_load(state(model_state)),
	logtalk_load(state(process_state)), 
	logtalk_load(solvers(state_space)),
	logtalk_load(solvers(heuristic_state_space)),
	nl,
	
	write('+++ Loading debugging tools...'),
	logtalk_load(debug(hooks)),
	set_logtalk_flag(code_prefix, '.'), 
	set_logtalk_flag(optimize, off), 
	set_prolog_flag(optimise, off),
	set_logtalk_flag(debug, off),
	set_logtalk_flag(smart_compilation, off),
	set_logtalk_flag(reload, always),
	set_logtalk_flag(unknown, warning),
	set_logtalk_flag(misspelt, warning),
	set_logtalk_flag(singletons, warning),
	set_logtalk_flag(missing_directives, warning),
	set_logtalk_flag(context_switching_calls, allow),
	set_logtalk_flag(code_prefix, '.'),
	set_logtalk_flag(optimize, off),
	set_prolog_flag(optimise, off),
	nl,
	
	write('+++ Loading performance measurement tools...'),
	logtalk_load(performance(performance)),	
	nl,
		
	write('+++ Loading heuristics and solvers...'),
	logtalk_load(solvers(esprona_search_strategy)),
		
	logtalk_load(solvers(esprona_blind_search)),	
	logtalk_load(solvers(esprona_breadth_first), [events(allow)]),
	logtalk_load(solvers(esprona_depth_first), [events(allow)]),
	
	logtalk_load(heuristics(heuristic_protocol)),
	logtalk_load(heuristics(heuristic_perspective)),
	
	logtalk_load(solvers(esprona_heuristic_search)),
	logtalk_load(solvers(esprona_best_first), [events(allow)]),
	logtalk_load(solvers(esprona_hill_climbing), [events(allow)]),
	nl,
	
	write('+++ Loading helper predicates/utilities...'),
	logtalk_load(utilities(helper_predicates)),
	logtalk_load(utilities(export_state_transitions)),
	nl,
	
	write('+++ Loading POPM Functional Perspective definitions...'),
	logtalk_load(fu_perspective(functional_constraint)),
	logtalk_load(fu_perspective(functional_heuristic)), 
	nl,
	
	write('+++ Loading POPM Behavioral Perspective definitions...'),
	logtalk_load(be_perspective(behavioral_constraint)), 
	logtalk_load(be_perspective(behavioral_heuristic)), 
	nl,
		
	write('+++ Loading POPM Organizational Perspective definitions...'),
	logtalk_load(org_perspective(organizational_constraint)),
	logtalk_load(org_perspective(organizational_heuristic)),
	nl,
	
	write('+++ Loading POPM Data Perspective definitions...'),
	logtalk_load(data_perspective(data_constraint)), 
	logtalk_load(data_perspective(data_heuristic)),
	nl,
	
	write('+++ Loading POPM Operational Perspective definitions...'),
	logtalk_load(op_perspective(operational_constraint)),
	logtalk_load(op_perspective(operational_heuristic)), 
	nl,
	
	write('+++ Loading process and constraint predicates definitions...'),
	logtalk_load(process(process)),
	nl,
	
	write('+++ Loading process model definitions...'),
	logtalk_load(process(process_model)),
	logtalk_load(set_up_surgery_plan_extended(process_model_definition)),
	logtalk_load(be_dep_test(process_model_definition)),
	nl,
		
	write('+++ Loading planning components...'),
	logtalk_load(planning(process_planning), [hook(hook_debug), events(allow)]),
	nl,
	
	write('+++ Loading visualization (dot-export)...'),
	logtalk_load(visualize(graphviz)),		
	nl,
	
	write('+++ Loading REST/JSON interface to ESProNa...'),
	logtalk_load(rest(rest)),
	consult('./library/REST/rest_proxy_module'),
	nl,
	
	write('+++ Starting ESProNa-server on port 2600...'),
	rest::start_server(2600),
	nl,
			
	/*
	write('+++ Generating architecture overview...'),
	logtalk_load(diagrams(loader)),
	diagram::rlibrary(esprona),
	shell('dot -Tpdf esprona.dot > esprona.pdf'),
	nl,
	*/
	
	nl
)).