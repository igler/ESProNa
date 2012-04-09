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

:- initialization((
	nl(user_output),
	write(user_output, ' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -'), 
	nl(user_output),
	write(user_output, '	Loading process model: Surgery plan confirmation (extended version)       '), 
	nl(user_output),
	write(user_output, ' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -'), 
	nl(user_output),
	write(user_output, '+++ Transforming ontologies used within process model...                      '),
	owl2_to_logtalk:load_axioms('organization.owl'),
	owl2_to_logtalk:load_axioms('tools.owl'),
	owl2_to_logtalk:save_axioms_ontology('popm_objects.lgt', owlpl, [no_base(_)]),
	owl2_to_logtalk:save_axioms_individuals('popm_individuals.lgt', owlpl, [no_base(_)]),
	owl2_to_logtalk:cleanup,
	nl(user_output),
	
	write(user_output, '+++ Loading transformed ontologies...                                         '),
	logtalk_load(popm_objects, [unknown(silent)]),
	logtalk_load(popm_individuals, [unknown(silent)]),
	nl(user_output),
	
	write(user_output, '+++ Loading process model and process definitions...                          '),
	% logtalk_load(process_model_definition, [unknown(silent)]),
	logtalk_load(process_definitions, [unknown(silent)])
)).