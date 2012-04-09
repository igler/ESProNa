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
/*				
	- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
		Process model: Surgery plan confirmation
	- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
*/

:- object('set_up_surgery_plan_extended#pid_0'(_),
    extends(process)).

		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION STATIC FUNCTIONAL SPECIFICATIONS
		% ---------------------------------------------------------------------------------------------------------------------
			:- dynamic.
		
			% Declaring process title and description
			process_title('Anamnese').
			process_description('Im Prozess Anamnese wird...').
			
			% Declaring the membership
			contained_in_process_model(set_up_surgery_plan_extended).
		
			% Defining the actions that can be performed.
			process_actions([start, finish, abort]).
		
			% Defining the maximum positive and negative recommendation degree used 
			% by the heuristic planning algorithms	
			highest_positive_recommendation_degree(3).
			highest_negative_recommendation_degree(-3).
			
			% Defining the values range of the process
			process_domain([], (PID_0 #= 1)) :-
				parameter(1, PID_0).

		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION FUNCTIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------							
			% Actions must be applicable.
			functional_constraint(necessity, [Action], State, Instance, 
			(
				'set_up_surgery_plan_extended#pid_0'(_)::actions_applicable(State, Action, Instance)
			)).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION ORGANIZATIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			% --- Necessary organizational constraints -----------------------------------------------------------------------
			organizational_constraint(necessity, [start, finish, abort], _, _, [Agent],
			(
				instantiates_class(Agent, 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person'),
				Agent::'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor')
			)).
				
			% Recommendation: ++ (very recommended)
			organizational_constraint(recommendation(-2), [finish], State, Instance, AgentList,
			(
				'set_up_surgery_plan_extended#pid_0'(_)::instance_agent_data_tool(State, start, Instance, AgentList, _, _)
			)).
				
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION DATA PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			% ... produces
			data_production([finish], ['Patientenakte']).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION OPERATIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			operational_constraint(necessity, [start, finish, abort], _, _, [Tool], 
			(
				Tool = 'HIS'
			)).
				
:- end_object.


:- object('set_up_surgery_plan_extended#pid_1'(_),
    extends(process)).

		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION STATIC FUNCTIONAL SPECIFICATIONS
		% ---------------------------------------------------------------------------------------------------------------------
			:- dynamic.
		
			% Declaring process title and description
			process_title('Operationsplan vorbereiten').
			process_description('Im Prozess wird...').
			
			% Declaring the membership
			contained_in_process_model(set_up_surgery_plan_extended).
		
			% Defining the actions that can be performed.
			process_actions([start, finish, suspend, abort]).
					
			% Defining the maximum positive and negative recommendation degree used 
			% by the heuristic planning algorithms
			highest_positive_recommendation_degree(3).
			highest_negative_recommendation_degree(-3).
			
			% Defining the values range of the process
			process_domain([], (PID_1 #= 1)) :-
				parameter(1, PID_1).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION FUNCTIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------							
			% Actions must be applicable.
			functional_constraint(necessity, [Action], State, Instance, 
			(
				'set_up_surgery_plan_extended#pid_1'(_)::actions_applicable(State, Action, Instance)
			)).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% BEHAVIORAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			% Process PID 0 must be started
			behavioral_constraint(necessity, [start], State, _, 
			(	
				'set_up_surgery_plan_extended#pid_0'(_)::exists_instance(State, start, _)
			)).
			
			% Recommendation: ++ (very recommended): Process PID 0 should be finished
			behavioral_constraint(recommendation(-2), [start], State, _, 
			(	
				'set_up_surgery_plan_extended#pid_0'(_)::exists_instance(State, finish, _)
			)).
			
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION ORGANIZATIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			organizational_constraint(necessity, [start, finish, abort], _, _, [Agent], 
			(
				instantiates_class(Agent, 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person'),
				'http://ai4.inf.uni-bayreuth.de/ontology/individuals#Surgery'::'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'(Agent)
			)).
			
			% Recommendation: ++ (very recommended)
			organizational_constraint(recommendation(-2), [start, finish], _, _, [Agent],
			(
				instantiates_class(Agent, 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person'),
				Agent::'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor')
			)).
		
			% ---------------------------------------------------------------------------------------------------------------------
			% SECTION DATA PERSPECTIVE CONSTRAINTS
			% ---------------------------------------------------------------------------------------------------------------------	
			% ... produces
			data_production([finish], ['Operationsplan']).
		
			% ... requires
			data_constraint(necessity, [start], State, _, RequiredDataItemsList, 
			(
				'set_up_surgery_plan_extended#pid_0'(_)::instance_agent_data_tool(State, _, _, _, RequiredDataItemsList, _),
				RequiredDataItemsList = ['Patientenakte']
			)).
		
			% ---------------------------------------------------------------------------------------------------------------------
			% SECTION OPERATIONAL PERSPECTIVE CONSTRAINTS
			% ---------------------------------------------------------------------------------------------------------------------
			operational_constraint(necessity, [start, finish, abort], _, _, [Tool], 
			(
				Tool = 'HIS'
			)).
					
:- end_object.

:- object('set_up_surgery_plan_extended#pid_2'(_),
    extends(process)).

		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION STATIC FUNCTIONAL SPECIFICATIONS
		% ---------------------------------------------------------------------------------------------------------------------
			:- dynamic.
		
			% Declaring process title and description
			process_title('Operatinsplan überprüfen').
			process_description('Im Prozess wird...').
			
			% Declaring the membership
			contained_in_process_model(set_up_surgery_plan_extended).
		
			% Defining the actions that can be performed.
			process_actions([start, finish, suspend, abort]).
			
			% Defining the maximum positive and negative recommendation degree used 
			% by the heuristic planning algorithms			
			highest_positive_recommendation_degree(3).
			highest_negative_recommendation_degree(-3).
			
			% Defining the values range of the process
			process_domain(['set_up_surgery_plan_extended#pid_1'(PID_1)], (PID_2 #>= 0, PID_2 #=< PID_1)) :-
				parameter(1, PID_2).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION FUNCTIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------				
			% Actions must be applicable.
			functional_constraint(necessity, [Action], State, Instance, 
			(
				'set_up_surgery_plan_extended#pid_2'(_)::actions_applicable(State, Action, Instance)
			)).

		% ---------------------------------------------------------------------------------------------------------------------
		% BEHAVIORAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			% ... for starting the process
			% Process pid_1 must be finished
			behavioral_constraint(necessity, [start], State, _, 
			(	
				'set_up_surgery_plan_extended#pid_1'(_)::exists_instance(State, finish, _)
			)).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION ORGANIZATIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			organizational_constraint(necessity, [start, finish, abort], _, _, [Agent], 
			(
				instantiates_class(Agent, 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person'),
				Agent::'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor')
			)).

		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION DATA PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------	
			% ... produces
			data_production([finish], ['überprüfter Operationsplan']).
		
			% ... requires
			data_constraint(necessity, [start], State, _, RequiredDataItemsList, 
			(
				'set_up_surgery_plan_extended#pid_1'(_)::instance_agent_data_tool(State, _, _, _, RequiredDataItemsList, _),
				RequiredDataItemsList = ['Operationsplan']
			)).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION OPERATIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			operational_constraint(necessity, [start, finish, suspend, abort], _, _, [Tool], 
			(
				Tool = 'HIS'
			)).

:- end_object.
			
:- object('set_up_surgery_plan_extended#pid_3'(_),
    extends(process)).

		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION STATIC FUNCTIONAL SPECIFICATIONS
		% ---------------------------------------------------------------------------------------------------------------------
			:- dynamic.
		
			% Declaring process title and description
			process_title('Operatinsplan genehmigen').
			process_description('Im Prozess wird...').
			
			% Declaring the membership
			contained_in_process_model(set_up_surgery_plan_extended).
		
			% Defining the actions that can be performed.
			process_actions([start, finish, abort]).
			
			% Defining the maximum positive and negative recommendation degree used 
			% by the heuristic planning algorithms			
			highest_positive_recommendation_degree(3).
			highest_negative_recommendation_degree(-3).
			
			% Defining the values range of the process
			process_domain(['set_up_surgery_plan_extended#pid_1'(PID_1)], (PID_3 #= PID_1)) :-
				parameter(1, PID_3).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION FUNCTIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------				
			% Actions must be applicable.
			functional_constraint(necessity, [Action], State, Instance, 
			(
				'set_up_surgery_plan_extended#pid_3'(_)::actions_applicable(State, Action, Instance)
			)).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% BEHAVIORAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			% ... for starting the process
			% If process pid_1 was done by MTA then pid_2 must be performed.
			behavioral_constraint(necessity, [start], State, _, 
			(	
				'set_up_surgery_plan_extended#pid_1'(_)::exists_instance(State, start, _)
			
				%(	pid_1(_)::instance_agent_data_tool(State, start, _, StartAgents, _, _),
				%	member(StartAgent, StartAgents),
				%	(	StartAgent::'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#MTA') ->
				%		pid_2(_)::exists_instance(State, finish, _)
				%		;
				%		true
				%	)
				%)
				
				
			)).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION ORGANIZATIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			% ... for starting the process
			% Start the process by the supervisor of the person who did pid_1
			organizational_constraint(necessity, [start, finish, abort], State,  Instance, [Supervisor], 
			(				
				% get the person who started it
				'set_up_surgery_plan_extended#pid_1'(_)::instance_agent_data_tool(State, start, Instance, StartAgents, _, _),
				member(StartAgent, StartAgents),
				% retrieve supervisor(s)
				instantiates_class(Supervisor, 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person'),
				Supervisor::'http://ai4.inf.uni-bayreuth.de/ontology/organization#supervisorOf'(StartAgent)
			)).
			
			organizational_constraint(recommendation(-3), [start], _, _, [Agent],
			(
				instantiates_class(Agent, 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person'),
				Agent::'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#MedicalSuperintendent')
			)).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION DATA PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------	
			% ... produces
			data_production([finish], ['genehmigter Operationsplan']).
		
			% ... requires
			data_constraint(necessity, [start], State, _, RequiredDataItemsList, 
			(
				(	'set_up_surgery_plan_extended#pid_1'(_)::instance_agent_data_tool(State, start, _, StartAgents, _, _),
					member(StartAgent, StartAgents),
					(	StartAgent::'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#MTA') ->
						(
							'set_up_surgery_plan_extended#pid_2'(_)::instance_agent_data_tool(State, _, _, _, RequiredDataItemsList, _),
							RequiredDataItemsList = ['überprüfter Operationsplan']
						)
						;
						(	'set_up_surgery_plan_extended#pid_1'(_)::instance_agent_data_tool(State, _, _, _, RequiredDataItemsList, _),
							RequiredDataItemsList = ['Operationsplan']
						)
					)
				)
			)).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION OPERATIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			operational_constraint(necessity, [start, finish, abort], _, _, [Tool], 
			(
				Tool = 'HIS'
			)).
					
:- end_object.