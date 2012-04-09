%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ESProNa - 	Modeling, Execution and SmartNavigation(c) of Declarative Business Processes
%  Release 0.8
%  
%  Copyright (c) 2007-2011 Michael Igler.       All Rights Reserved.
%  ESProNa is free software.  You can redistribute it and/or modify it under the terms 
%  of the "Artistic License 2.0" as published by The Perl Foundation. 
%  Consult the "LICENSE.txt" file for details.
%
%  Contact: 	Michael Igler (michael.igler@uni-bayreuth.de)
%				University of Bayreuth
%				Chair for Applied Computer Science IV
%				Databases and Information Systems
%				Universitaetsstrasse 30
%				D-95440 Bayreuth
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*				
	- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
		Process model: Surgery plan confirmation
	- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
*/

:- object(pid_0(_),
    extends(process)).

		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION STATIC FUNCTIONAL SPECIFICATIONS
		% ---------------------------------------------------------------------------------------------------------------------
			:- dynamic.
		
			% Declaring process title and description
			process_title('Anamnese').
			process_description('Im Prozess Anamnese wird...').
			
			% Declaring the membership
			contained_in_process_model(set_up_surgery_plan).
		
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
				pid_0(_)::actions_applicable(State, Action, Instance)
			)).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION ORGANIZATIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			% --- Necessary organizational constraints -----------------------------------------------------------------------
			organizational_constraint(necessity, [start, finish, abort], _, _, [Agent],
			(
				instantiates_class(Agent, 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person'),
				'http://ai4.inf.uni-bayreuth.de/ontology/individuals#Cardiology'::'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'(Agent)
			)).
		
			% --- Recommended organizational constraints ----------------------------------------------------------------------
			% Recommendation: +++ (absolutely recommended)
			organizational_constraint(recommendation(-3), [start], _, _, [Agent],
			(
				instantiates_class(Agent, 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person'),
				Agent::'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor')
			)).
		
			% Recommendation: + (recommended)
			organizational_constraint(recommendation(-1), [abort], _, _, [Agent],
			(
				instantiates_class(Agent, 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person'),
				Agent::'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantMedicalDirector')
			)).
			
			% Recommendation: --- (absolutely not recommended)
			organizational_constraint(recommendation(3), [start, abort], _, _, [Agent],
			(
				instantiates_class(Agent, 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person'),
				Agent::'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#MedicalSuperintendent')
			)).
			
			% Recommendation: ++ (very recommended)
			organizational_constraint(recommendation(-2), [finish], State, Instance, AgentList,
			(
				pid_0(_)::instance_agent_data_tool(State, start, Instance, AgentList, _, _)
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

:- object(pid_1(_),
    extends(process)).

		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION STATIC FUNCTIONAL SPECIFICATIONS
		% ---------------------------------------------------------------------------------------------------------------------
			:- dynamic.
		
			% Declaring process title and description
			process_title('Operatinsplan vorbereiten').
			process_description('Im Prozess wird...').
			
			% Declaring the membership
			contained_in_process_model(set_up_surgery_plan).
		
			% Defining the actions that can be performed.
			process_actions([start, finish, abort]).
					
			% Defining the maximum positive and negative recommendation degree used 
			% by the heuristic planning algorithms
			highest_positive_recommendation_degree(3).
			highest_negative_recommendation_degree(-3).
			
			% Defining the values range of the process
			process_domain([], (PID_1 #>= 1)) :-
				parameter(1, PID_1).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION FUNCTIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------							
			% Actions must be applicable.
			functional_constraint(necessity, [Action], State, Instance, 
			(
				pid_1(_)::actions_applicable(State, Action, Instance)
			)).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% BEHAVIORAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			% Process PID 0 must be started
			behavioral_constraint(necessity, [start], State, _, 
			(	
				pid_0(_)::exists_instance(State, start, _)
			)).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION ORGANIZATIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			organizational_constraint(necessity, [start, finish, abort], _, _, [Agent], 
			(
				instantiates_class(Agent, 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person'),
				Agent::'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor'),
				'http://ai4.inf.uni-bayreuth.de/ontology/individuals#Surgery'::'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'(Agent)
			)).
		
			% ---------------------------------------------------------------------------------------------------------------------
			% SECTION DATA PERSPECTIVE CONSTRAINTS
			% ---------------------------------------------------------------------------------------------------------------------	
			% ... produces
			data_production([finish], ['Operationsplan']).
		
			% ... requires
			data_constraint(necessity, [start], _, _, RequiredDataItemsList, 
			(
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

:- object(pid_2(_),
    extends(process)).

		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION STATIC FUNCTIONAL SPECIFICATIONS
		% ---------------------------------------------------------------------------------------------------------------------
			:- dynamic.
		
			% Declaring process title and description
			process_title('Operatinsplan genehmigen').
			process_description('Im Prozess wird...').
			
			% Declaring the membership
			contained_in_process_model(set_up_surgery_plan).
		
			% Defining the actions that can be performed.
			process_actions([start, finish, abort]).
			
			% Defining the maximum positive and negative recommendation degree used 
			% by the heuristic planning algorithms			
			highest_positive_recommendation_degree(3).
			highest_negative_recommendation_degree(-3).
			
			% Defining the values range of the process
			process_domain([pid_1(PID_1)], (PID_2 #= PID_1)) :-
				parameter(1, PID_2).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION FUNCTIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------				
			% Actions must be applicable.
			functional_constraint(necessity, [Action], State, Instance, 
			(
				pid_2(_)::actions_applicable(State, Action, Instance)
			)).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% BEHAVIORAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			% ... for starting the process
			% Process pid_1 must be done
			behavioral_constraint(necessity, [start], State, _, 
			(	
				pid_1(_)::in_domain(State)
			)).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION ORGANIZATIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			% ... for starting the process
			% Start the process by the supervisor of the person who did pid_1
			%organizational_constraint(necessity, [start, finish, abort], State,  Instance, [Supervisor], 
			organizational_constraint([start, finish, abort], State,  Instance, [Supervisor], 
			(	
				% get the person who started it
				pid_1(_)::instance_agent_data_tool(State, start, Instance, StartAgents, _, _),
				member(StartAgent, StartAgents),
				instantiates_class(Supervisor, 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person'),
				Supervisor::'http://ai4.inf.uni-bayreuth.de/ontology/organization#supervisorOf'(StartAgent)
			)).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION DATA PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------	
			% ... produces
			data_production([finish], ['genehmigter Operationsplan']).
		
			% ... requires
			data_constraint(necessity, [start], _, _, RequiredDataItemsList, 
			(
				RequiredDataItemsList = ['Operationsplan']
			)).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION OPERATIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			operational_constraint(necessity, [start, finish, abort], _, _, [Tool], 
			(
				Tool = 'HIS'
			)).
					
:- end_object.