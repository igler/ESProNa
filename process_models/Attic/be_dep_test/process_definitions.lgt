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
		Process model: behavioral dependency test
	- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
*/

:- object(pid_a(_),
    extends(process)).

		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION STATIC FUNCTIONAL SPECIFICATIONS
		% ---------------------------------------------------------------------------------------------------------------------
			:- dynamic.
		
			% Declaring process title and description
			process_title('Prozess A').
			process_description('...').
			
			% Declaring the membership
			contained_in_process_model(be_dep_test).
		
			% Defining the actions that can be performed.
			process_actions([start, finish, abort]).
		
			% Defining the maximum positve and negative recommendation degree used 
			% by the heuristic planning algorithms	
			highest_positive_recommendation_degree(3).
			highest_negative_recommendation_degree(-3).
			
			% Defining the values range of the process
			process_domain([], (PID_A #= 1)) :-
				parameter(1, PID_A).

		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION FUNCTIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------							
			% Actions must be applicable.
			functional_constraint(necessity, [Action], State, Instance, 
			(
				pid_a(_)::actions_applicable(State, Action, Instance)
			)).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION ORGANIZATIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			% --- Necessary organizational constraints -----------------------------------------------------------------------
			organizational_constraint(necessity, [start, finish, abort], _, _, [Agent],
			(
				instantiates_class(Agent, 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person'),
				Agent::'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor'),
				'http://ai4.inf.uni-bayreuth.de/ontology/individuals#Cardiology'::'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'(Agent)

			)).
				
:- end_object.

:- object(pid_b(_),
    extends(process)).

		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION STATIC FUNCTIONAL SPECIFICATIONS
		% ---------------------------------------------------------------------------------------------------------------------
			:- dynamic.
		
			% Declaring process title and description
			process_title('Prozess B').
			process_description('...').
			
			% Declaring the membership
			contained_in_process_model(be_dep_test).
		
			% Defining the actions that can be performed.
			process_actions([start, finish, abort]).
		
			% Defining the maximum positve and negative recommendation degree used 
			% by the heuristic planning algorithms	
			highest_positive_recommendation_degree(3).
			highest_negative_recommendation_degree(-3).
			
			% Defining the values range of the process
			process_domain([], (PID_B #= 1)) :-
				parameter(1, PID_B).

		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION FUNCTIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------							
			% Actions must be applicable.
			functional_constraint(necessity, [Action], State, Instance, 
			(
				pid_b(_)::actions_applicable(State, Action, Instance)
			)).
			
			
		% ---------------------------------------------------------------------------------------------------------------------
		% BEHAVIORAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			behavioral_constraint(necessity, [start], State, _, 
			(	
				pid_a(_)::exists_instance(State, finish, _)
			)).		
		
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION ORGANIZATIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			% --- Necessary organizational constraints -----------------------------------------------------------------------
			organizational_constraint(necessity, [start, finish, abort], _, _, [Agent],
			(
				instantiates_class(Agent, 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person'),
				Agent::'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor'),
				'http://ai4.inf.uni-bayreuth.de/ontology/individuals#Cardiology'::'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'(Agent)
				
			)).
				
:- end_object.

:- object(pid_c(_),
    extends(process)).

		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION STATIC FUNCTIONAL SPECIFICATIONS
		% ---------------------------------------------------------------------------------------------------------------------
			:- dynamic.
		
			% Declaring process title and description
			process_title('Prozess C').
			process_description('...').
			
			% Declaring the membership
			contained_in_process_model(be_dep_test).
		
			% Defining the actions that can be performed.
			process_actions([start, finish, abort]).
		
			% Defining the maximum positve and negative recommendation degree used 
			% by the heuristic planning algorithms	
			highest_positive_recommendation_degree(3).
			highest_negative_recommendation_degree(-3).
			
			% Defining the values range of the process
			process_domain([], (PID_C #= 1)) :-
				parameter(1, PID_C).

		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION FUNCTIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------							
			% Actions must be applicable.
			functional_constraint(necessity, [Action], State, Instance, 
			(
				pid_c(_)::actions_applicable(State, Action, Instance)
			)).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION ORGANIZATIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			% --- Necessary organizational constraints -----------------------------------------------------------------------
			organizational_constraint(necessity, [start, finish, abort], _, _, [Agent],
			(
				instantiates_class(Agent, 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person'),
				Agent::'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor'),
				'http://ai4.inf.uni-bayreuth.de/ontology/individuals#Cardiology'::'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'(Agent)

			)).
				
:- end_object.

:- object(pid_d(_),
    extends(process)).

		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION STATIC FUNCTIONAL SPECIFICATIONS
		% ---------------------------------------------------------------------------------------------------------------------
			:- dynamic.
		
			% Declaring process title and description
			process_title('Prozess D').
			process_description('...').
			
			% Declaring the membership
			contained_in_process_model(be_dep_test).
		
			% Defining the actions that can be performed.
			process_actions([start, finish, abort]).
		
			% Defining the maximum positve and negative recommendation degree used 
			% by the heuristic planning algorithms	
			highest_positive_recommendation_degree(3).
			highest_negative_recommendation_degree(-3).
			
			% Defining the values range of the process
			process_domain([], (PID_D #= 1)) :-
				parameter(1, PID_D).

		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION FUNCTIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------							
			% Actions must be applicable.
			functional_constraint(necessity, [Action], State, Instance, 
			(
				pid_d(_)::actions_applicable(State, Action, Instance)
			)).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% BEHAVIORAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			behavioral_constraint(necessity, [start], State, _, 
			(	
				pid_a(_)::exists_instance(State, finish, _),
				pid_b(_)::exists_instance(State, finish, _),
				pid_c(_)::exists_instance(State, finish, _)
			)).
		
		% ---------------------------------------------------------------------------------------------------------------------
		% SECTION ORGANIZATIONAL PERSPECTIVE CONSTRAINTS
		% ---------------------------------------------------------------------------------------------------------------------
			% --- Necessary organizational constraints -----------------------------------------------------------------------
			organizational_constraint(necessity, [start, finish, abort], _, _, [Agent],
			(
				instantiates_class(Agent, 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person'),
				Agent::'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor'),
				'http://ai4.inf.uni-bayreuth.de/ontology/individuals#Cardiology'::'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'(Agent)

			)).
				
:- end_object.