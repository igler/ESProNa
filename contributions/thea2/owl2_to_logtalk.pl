:- module(owl2_to_logtalk,
          [load_axioms/1,
           load_axioms/2,
           load_axioms/3,
           
           save_axioms_ontology/2,
           save_axioms_ontology/3,
           save_axioms_individuals/2,
           save_axioms_individuals/3,
           
           set_up_swrl_rule/3,
           predicate_characteristics/1,
           write_inheritence/2,
           write_predicates_and_SWRL_rules/1,
           
           transitive_predicate/1,
           asymmetric_predicate/1,
           symmetric_predicate/1,
           reflexive_predicate/1,
           irreflexive_predicate/1,
           
           characteristical_predicate/1,
           cleanup/0,
           
           predicate_transitive/1,
           predicate_asymmetric/1,
           predicate_symmetric/1,
           predicate_reflexive/1,
           predicate_irreflexive/1 ]).

:- use_module('owl2_model.pl', [consult_axioms/1, axiom/1]).

:- multifile load_axioms_hook/3.
:- multifile save_axioms_ontology_hook/3.
:- multifile save_axioms_individuals_hook/3.

%% load_axioms(+File)
% populates owl2_model axioms from File. Attempts to guess format from extension
load_axioms(File) :-
      load_axioms(File,_).

%% load_axioms(+File,+Fmt)
% populates owl2_model axioms from File.
% Fmt = rdf | owlx | prolog | ...
% (for non-standard fmts you may have to ensure the required io model is loaded
%  so the hooks are visible)
load_axioms(File,Fmt) :-
        load_axioms(File,Fmt,[]).

%% load_axioms(+File,+Fmt,+Opts)
% as load_axioms/2 with options
% Opts are Fmt specific - see individual modules for details
load_axioms(File,Fmt,Opts) :-
	    var(Fmt),
        guess_format(File,Fmt,Opts),
        !,
        load_axioms(File,Fmt,Opts).

load_axioms(File,Fmt,_Opts) :-
        nonvar(Fmt),
        (   Fmt=prolog
        ;   Fmt=owlpl
        ;   Fmt=pl),
        !,
		load_prolog_axioms(File).
		
load_axioms(File,Fmt,Opts) :-
        load_handler(read,Fmt),
        load_axioms_hook(File,Fmt,Opts),
        !.

load_axioms(File,Fmt,Opts) :-
        throw(owl2_to_logtalk('cannot parse fmt for',File,Fmt,Opts)).

load_prolog_axioms(File) :-
		\+ predicate_property(qcompile(_),_), % e.g. Yap
		!,
        style_check((-discontiguous)),
		consult_axioms(File).
		
load_prolog_axioms(File) :-
        style_check((-discontiguous)),
		style_check(-atom),	
		file_name_extension(Base, _Ext, File),
		file_name_extension(Base, qlf, QlfFile),
        debug(load,'checking for: ~w',[QlfFile]),
		(   exists_file(QlfFile),
	    	time_file(QlfFile, QlfTime),
	    	time_file(File, PlTime),
	    	QlfTime >= PlTime ->  
			consult_axioms(QlfFile)
			;   
			access_file(QlfFile, write) ->  
			qcompile(File),
            consult_axioms(QlfFile)
        	;   
			debug(load,'  cannot write to qlf (permission problem?), loading from: ~w',[File]),
            consult_axioms(File)
	).

%% save_axioms_individuals(+File,+Fmt)
% saves owl2_model axioms to File.
% Fmt = rdf | owlx | prolog | ...
% (for non-standard fmts you may have to ensure the required io model is loaded
%  so the hooks are visible)
save_axioms_ontology(File,Fmt) :-
        save_axioms_ontology(File,Fmt,[]).
		
save_axioms_individuals(File,Fmt) :-
        save_axioms_individuals(File,Fmt,[]).

cleanup :-
	retractall(owl2_model:axiom(_)).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  														save_axioms_ontology

http://www.w3.org/TR/owl-features/
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

save_axioms_ontology(File,Fmt,_) :-
	nonvar(Fmt),
	(   Fmt=prolog
    	;   
		Fmt=owlpl
    	;   
		Fmt=pl),
    !,

	(   nonvar(File) ->  
		tell(File)
        ;   
		true
	),

	% This is for debugging...
	format('/*'),
	%format('Call: Retract all axioms'),
	nl,
	forall( axiom(Axiome), (format('~q', [Axiome]), nl)),
	format('*/'),
	nl,
	
	format('% In OWL everything is-a thing'),
	format('~n:- object(~q,', ['http://ai4.inf.uni-bayreuth.de/ontology#Thing']), 
	format('~n    instantiates(~q)).', ['http://ai4.inf.uni-bayreuth.de/ontology#Thing']),
	format('~n:- end_object.'),
	
	format('~n~n'),

	forall( axiom(A), 
			(	
				% class('http://ai4.inf.uni-bayreuth.de/ontology/organization#Role').
				/*
				owl2_model:class(Class), 
				string_concat(Namespace, Hash_plus_Classname, Class), 
				string_concat('#', Classname, Hash_plus_Classname),
				string_concat(Namespace, '#', Full_Namespace),
				rdf_db:rdf_current_ns(NS_alias, Full_Namespace).
				
				% rdf_db:rdf_current_ns(NS_alias, 'http://ai4.inf.uni-bayreuth.de/ontology/organization#').
				*/
				(	A = class(Class) -> 
					(	format('% class(~q)',[Class]),
						format('~n:- object(~q,~n',[Class]),
				
						% 2nd arg false => works with LogTalk
						% 2nd arg true => can LogTalk deal with those complex OWL inheritence???
						write_inheritence(Class, false),
				
						write_predicates_and_SWRL_rules(Class),
																
						format('~n~n:- end_object.~n~n',[])
					)
					;
					true
				)%,
				%owl2_model:retract_axiom(axiom(A))
			)
	),
	told.
	
	
save_axioms_ontology(File,Fmt,Opts) :-
        load_handler(write,Fmt),
        save_axioms_ontology_hook(File,Fmt,Opts),
        !.
save_axioms_ontology(File,Fmt,Opts) :-
        throw(owl2_to_logtalk('cannot save fmt for',File,Fmt,Opts)).

/*
subClassOf('http://ai4.inf.uni-bayreuth.de/ontology/organization#Division',
'http://ai4.inf.uni-bayreuth.de/ontology/organization#Group').

TODO: WriteComplexInheritance (has_value, exactCardinality, someValuesFrom, etc.)   can this be expressed in LogTalk at all???

subClassOf('http://www.w3.org/TR/2003/PR-owl-guide-20031209/wine#Sauternes',
	hasValue('http://www.w3.org/TR/2003/PR-owl-guide-20031209/wine#locatedIn','http://www.w3.org/TR/2003/PR-owl-guide-20031209/wine#SauterneRegion'))
subClassOf('http://www.w3.org/TR/2003/PR-owl-guide-20031209/wine#Sauternes',
	hasValue('http://www.w3.org/TR/2003/PR-owl-guide-20031209/wine#hasBody','http://www.w3.org/TR/2003/PR-owl-guide-20031209/wine#Medium'))
subClassOf('http://www.w3.org/TR/2003/PR-owl-guide-20031209/wine#Sauternes',
	hasValue('http://www.w3.org/TR/2003/PR-owl-guide-20031209/wine#hasColor','http://www.w3.org/TR/2003/PR-owl-guide-20031209/wine#White'))

subClassOf('http://www.w3.org/TR/2003/PR-owl-guide-20031209/wine#Anjou',
	hasValue('http://www.w3.org/TR/2003/PR-owl-guide-20031209/wine#hasColor','http://www.w3.org/TR/2003/PR-owl-guide-20031209/wine#Rose'))
	
equivalentClasses(['http://www.w3.org/TR/2003/PR-owl-guide-20031209/wine#Anjou',
	intersectionOf(
		[
			'http://www.w3.org/TR/2003/PR-owl-guide-20031209/wine#Loire',
			hasValue('http://www.w3.org/TR/2003/PR-owl-guide-20031209/wine#locatedIn','http://www.w3.org/TR/2003/PR-owl-guide-20031209/wine#AnjouRegion')
		]
	)
])
*/
write_inheritence(Class, WriteComplexInheritance) :-
	
	findall( 	SuperClass,
				(	owl2_model:axiom(B), 
					B = subClassOf(Class, SuperClass),
					functor(SuperClass, _, 0)
				),
				SClassList_zero
	),
	
	findall( 	SuperClass,
				(	owl2_model:axiom(B), 
					B = subClassOf(Class, SuperClass),
					functor(SuperClass, _, 2)
				),
				SClassList_binary
	),
	
	length(SClassList_zero, Count_SClassList_zero),
	length(SClassList_binary, Count_SClassList_binary),
	
	% COverallElements = Count_SClassList_zero + Count_SClassList_binary,
	
	
	(	(Count_SClassList_zero = 0, Count_SClassList_binary = 0) ->
		format('    specializes(~q)).~n', ['http://ai4.inf.uni-bayreuth.de/ontology#Thing'])
		;
		(	forall(	member(SpecializesSuperClass, SClassList_zero),
					(	format('    specializes(~q)', [SpecializesSuperClass]),
						(	\+ last(SClassList_zero, SpecializesSuperClass) ->
							format(',~n')
							;
							(	( WriteComplexInheritance, Count_SClassList_binary \= 0 ) ->
								format(',~n')
								;
								format(').~n')
							)
						)
					)
			),
			(	WriteComplexInheritance ->
				forall(	member(SpecializesSuperClass_binary, SClassList_binary),
						(	format('    specializes(~q)', [SpecializesSuperClass_binary]),
							(	\+ last(SClassList_binary, SpecializesSuperClass_binary) ->
								format(',~n')
								;
								format(').~n')
							)
						)
				)
				;
				true
			)
		)
	).
						

% propertyDomain('http://ai4.inf.uni-bayreuth.de/ontology/organization#plays',
%	'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person').
write_predicates_and_SWRL_rules(Class) :-
	forall( axiom(C),
			( 	C = propertyDomain(Predicate, Class) ->
				(	format('~n        % propertyDomain(~q, ~q)',[Predicate, Class]),
					format('~n        :- public(~q/1).~n',[Predicate]),
					
					% Predicate characteristics: transitive, symmetric, ...
					predicate_characteristics(Predicate),
													
					% translate SWRL rules and fill code
					(	forall(	axiom(E), 
								(	E = implies(TailImplication, [HeadImplication]) ->
									set_up_swrl_rule(Predicate, TailImplication, [HeadImplication])
									;
									true
								)
						)
					)
				)
				;
				true
			)
	).


% Checks if 'Predicate' is a predicate that is e.g. transitive, asymmetric, ...
characteristical_predicate(Predicate) :-
	axiom(C),
	( 	C = transitiveProperty(Predicate)
		;
		C = asymmetricProperty(Predicate)
		;
		C = symmetricProperty(Predicate)
		;
		C = reflexiveProperty(Predicate)
		;
		C = irreflexiveProperty(Predicate)
	).
	
predicate_transitive(Predicate) :-
	axiom(C),
	C = transitiveProperty(Predicate).

predicate_asymmetric(Predicate) :-
	axiom(C),
	C = asymmetricProperty(Predicate).
	
predicate_symmetric(Predicate) :-
	axiom(C),
	C = symmetricProperty(Predicate).	
	
predicate_reflexive(Predicate) :-
	axiom(C),
	C = reflexiveProperty(Predicate).
		
predicate_irreflexive(Predicate) :-
	axiom(C),
	C = irreflexiveProperty(Predicate).	
	
	
predicate_characteristics(Predicate) :-
	(	(	predicate_transitive(Predicate)
			;
			predicate_asymmetric(Predicate)
			;
			predicate_symmetric(Predicate)
		) ->
		(
			format('~n        :- public(predicate/2).'),
			format('~n        predicate(~q, Y) :-', [Predicate]),
			
			(	predicate_transitive(Predicate) -> 
				(	format('~n            transitive_property(~q, Y)', [Predicate]),
					(	(	predicate_asymmetric(Predicate)
							;
							predicate_symmetric(Predicate)
							;
							predicate_reflexive(Predicate)
							;
							predicate_irreflexive(Predicate)
					 	) ->
						format(',')
						;
						format('.')
					)
				)
				;
				true
			),
			
			(	predicate_asymmetric(Predicate) -> 
				(	format('~n            asymmetric_property(~q, Y)', [Predicate]),
					(	(	predicate_symmetric(Predicate)
							;
							predicate_reflexive(Predicate)
							;
							predicate_irreflexive(Predicate)
					 	) ->
						format(',')
						;
						format('.')
					)
				)
				;
				true
			),

			(	predicate_symmetric(Predicate) -> 
				(	format('~n            symmetric_property(~q, Y)', [Predicate]),
					(	(	predicate_reflexive(Predicate)
							;
							predicate_irreflexive(Predicate)
					 	) ->
						format(',')
						;
						format('.')
					)
				)
				;
				true
			),
			
			(	predicate_reflexive(Predicate) -> 
				(	format('~n            reflexive_property(~q, Y)', [Predicate]),
					(	(	predicate_irreflexive(Predicate)
					 	) ->
						format(',')
						;
						format('.')
					)
				)
				;
				true
			),
			
			(	predicate_irreflexive(Predicate) -> 
				(	format('~n            irreflexive_property(~q, _)', [Predicate]),
					format('.')
				)
				;
				true
			),
			
			format('~n'),

			(	predicate_transitive(Predicate) ->
				transitive_predicate(Predicate)
				;
				true
			),

			(	predicate_asymmetric(Predicate) ->
				asymmetric_predicate(Predicate)
				;
				true
			),
			
			(	predicate_symmetric(Predicate) ->
				symmetric_predicate(Predicate)
				;
				true
			),
			
			(	predicate_reflexive(Predicate) ->
				reflexive_predicate(Predicate)
				;
				true
			),
			
			(	predicate_irreflexive(Predicate) ->
				irreflexive_predicate(Predicate)
				;
				true
			)
		)
		;
		true
	).
		
/*
Predicate characteristics: transitive, symmetric, ...
transitiveProperty('http://ai4.inf.uni-bayreuth.de/ontology/organization#supervises')

path(X,Z) :- edge(X,Y), path(Y,Z).
path(X,Y) :- edge(X,Y).

edge(1,2).
edge(2,2).
edge(2,4).
edge(2,3).
edge(3,5).
*/	
% transitivity (a R b), (b R c) ==> (a R c)
transitive_predicate(Predicate) :-
	format('~n        :- public(transitive_property/2).'),
	format('~n        transitive_property(~q, Y) :-', [Predicate]),
	format('~n            ::~q(Y).', [Predicate]),
	format('~n'),
	format('~n        transitive_property(~q, Z) :-', [Predicate]),
	format('~n            ::~q(Y),', [Predicate]),		% Important that this call is before the following call; otherwise endless-loop!
	format('~n            Y::transitive_property(~q, Z).', [Predicate]),
	format('~n').

% symmetric: (a R b) ==> (b R a) 
symmetric_predicate(Predicate) :-
	format('~n        :- public(symmetric_property/2).'),
	format('~n        symmetric_property(~q, Y) :-', [Predicate]),	
	format('~n            self(X),'),
	format('~n            X::~q(Y),', [Predicate]),
	format('~n            Y::~q(X).', [Predicate]),
	format('~n').
		
% asymmetry (a R b) ==> \+ (b R a) 
asymmetric_predicate(Predicate) :-
	format('~n        :- public(asymmetric_property/2).'),
	format('~n        asymmetric_property(~q, Y) :-', [Predicate]),	
	format('~n            self(X),'),
	format('~n            X::~q(Y),', [Predicate]),
	format('~n            \\+ Y::~q(X).', [Predicate]),
	format('~n').
			
% reflexive (a R a)
reflexive_predicate(Predicate) :-
	format('~n        :- public(reflexive_property/2).'),
	format('~n        reflexive_property(~q, _) :-', [Predicate]),	
	format('~n            self(X),'),
	format('~n            X::~q(X).', [Predicate]),
	format('~n').
	
	
% irreflexive \+ (a R a)
irreflexive_predicate(Predicate) :-
	format('~n        :- public(irreflexive_property/2).'),
	format('~n        irreflexive_property(~q, _) :-', [Predicate]),	
	format('~n            self(X),'),
	format('~n            \\+ X::~q(X).', [Predicate]),
	format('~n').

			
/*
SWRL RULES:

It is important that descriptions (see *) of the variables used in the SWRL rule are stated in the rule, e.g.
Division(?d), 	==> ?d is a Devision
Person(?a), 	==> ?a is a Person
Person(?b), 
Role(?r), 
Role(?s), 

member(?d, ?a), 	==> ?d used here
member(?d, ?b), 
plays(?a, ?s), 		==> ?a used here
plays(?b, ?r), 
supervises(?s, ?r) 
-> 
supervisorOf(?a, ?b)

Code output of Thea2:
implies(
	[
		description('http://ai4.inf.uni-bayreuth.de/ontology/organization#Division',i('http://ai4.inf.uni-bayreuth.de/ontology/d')),
		'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'(i('http://ai4.inf.uni-bayreuth.de/ontology/d'),i('http://ai4.inf.uni-bayreuth.de/ontology/a')),
		'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'(i('http://ai4.inf.uni-bayreuth.de/ontology/d'),i('http://ai4.inf.uni-bayreuth.de/ontology/b')),
		'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'(i('http://ai4.inf.uni-bayreuth.de/ontology/a'),i('http://ai4.inf.uni-bayreuth.de/ontology/s')),
		'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'(i('http://ai4.inf.uni-bayreuth.de/ontology/b'),i('http://ai4.inf.uni-bayreuth.de/ontology/r')),
		'http://ai4.inf.uni-bayreuth.de/ontology/organization#supervises'(i('http://ai4.inf.uni-bayreuth.de/ontology/s'),i('http://ai4.inf.uni-bayreuth.de/ontology/r'))
	],
	['http://ai4.inf.uni-bayreuth.de/ontology/organization#supervisorOf'(i('http://ai4.inf.uni-bayreuth.de/ontology/a'),i('http://ai4.inf.uni-bayreuth.de/ontology/b'))])

)																
*/	
set_up_swrl_rule(Predicate, TailImplication, [HeadImplication]) :-
	% If the Predicate matches the object then...
	functor(HeadImplication, Predicate, _) ->
	(
		arg(1, HeadImplication, i(FirstArgOfImplication)),
		arg(2, HeadImplication, i(SecondArgOfImplication)),
		
		string_to_list(SecondArgOfImplication, ListSecondArgOfImplication),
		last(ListSecondArgOfImplication, VariableCodeSecondArgOfImplication),
		char_code(VariableNameSecondArgOfImplication, VariableCodeSecondArgOfImplication),
		
		format('~n        % ~q ~n',[HeadImplication]),	% Comment
		format('        ~q(_~q) :- ~n',[Predicate, VariableNameSecondArgOfImplication]),
		
		string_to_list(FirstArgOfImplication, ListFirstArgOfImplication),
		last(ListFirstArgOfImplication, VariableCodeFirstArgOfImplication),
		char_code(VariableNameFirstArgOfImplication, VariableCodeFirstArgOfImplication),
		
		format('            % the used variables are instances of the following classes:'),	% Comment
		format('~n            self(_~q), ~n',[VariableNameFirstArgOfImplication]),
		
		% The first arguments of 'implies' build the 'content' of the predicate									
		forall(	
				member(TIMember, TailImplication),
				(	
					(
						% The description(...) axiom emphasizes of which instances the SWRL variables are.
						TIMember = description(OfClass, i(OfClassVariable)) ->
						(
							string_to_list(OfClassVariable, ListOfClassVariable),
							last(ListOfClassVariable, VariableCodeOfClassVariable),
							char_code(VariableNameOfClassVariable, VariableCodeOfClassVariable),
							
							(	% 'VariableNameFirstArgOfImplication' is the object itself, so skip it	
								VariableNameFirstArgOfImplication \= VariableNameOfClassVariable ->	
								format('            instantiates_class(_~q, ~q),~n',[VariableNameOfClassVariable, OfClass])
								;
								true
							)
						)
						;
						(
							functor(TIMember, PredicateTIMember, _),
							arg(1, TIMember, i(FirstArgOfTIMember)),
							arg(2, TIMember, i(SecondArgOfTIMember)),

							string_to_list(FirstArgOfTIMember, ListFirstArgOfTIMember),
							last(ListFirstArgOfTIMember, VariableCodeFirstArgOfTIMember),
							char_code(VariableNameFirstArgOfTIMember, VariableCodeFirstArgOfTIMember),

							string_to_list(SecondArgOfTIMember, ListSecondArgOfTIMember),
							last(ListSecondArgOfTIMember, VariableCodeSecondArgOfTIMember),
							char_code(VariableNameSecondArgOfTIMember, VariableCodeSecondArgOfTIMember),

							format('~n            % ~q ~n',[TIMember]),	% Comment
							(	FirstArgOfTIMember = FirstArgOfImplication ->
								(
									format('            _~q::~q(_~q)',[VariableNameFirstArgOfImplication, PredicateTIMember, VariableNameSecondArgOfTIMember])
								)
								;
								(	characteristical_predicate(PredicateTIMember) ->
									format('            _~q::predicate(~q, _~q)',[VariableNameFirstArgOfTIMember, PredicateTIMember, VariableNameSecondArgOfTIMember])
									;
									format('            _~q::~q(_~q)',[VariableNameFirstArgOfTIMember, PredicateTIMember, VariableNameSecondArgOfTIMember])
								)
							),
							(	last(TailImplication, TIMember) ->
								format('.~n')
								;
								format(',~n')
							)
						)
					)
				)
			)
		)
		;
		true.	% ... else we do not write anything, so return true.
		
		
				
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  														save_axioms_individuals
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */


save_axioms_individuals(File,Fmt,_) :-
        nonvar(Fmt),
        (   Fmt=prolog
        ;   Fmt=owlpl
        ;   Fmt=pl),
        !,


        (   nonvar(File)
        ->  tell(File)
        ;   true),

		% This is for debugging...
		format('/*'),
		nl,
		forall( axiom(Axiome), (format('~q', [Axiome]), nl)),
		format('*/'),
		nl,
		
	
		forall( axiom(A), 
		(	
			% classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#Person','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Jacob').
			(	(	A = classAssertion(Class, Individual),
					% Skip a few instantiations
					Class \= 'http://www.w3.org/2003/11/swrl#Variable',
					Class \= 'http://www.w3.org/2003/11/swrl#AtomList',
					Class \= 'http://www.w3.org/2003/11/swrl#IndividualPropertyAtom',
					Class \= 'http://www.w3.org/2003/11/swrl#Imp',
					Class \= 'http://www.w3.org/2002/07/owl#annotatedTargetProperty'
					) -> 
					(	format('% classAssertion(~q, ~q)~n',[Individual, Class]),
						format(':- object(~q,~n instantiates(~q)).~n',[Individual, Class]),
						
						/*
							propertyAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#plays',
								'http://ai4.inf.uni-bayreuth.de/ontology/individuals#Jacob',
								'http://ai4.inf.uni-bayreuth.de/ontology/individuals#MedicalSuperintendent').
						*/
						forall( axiom(B),
								( 	B = propertyAssertion(FactName, Individual, Object) ->
									format('~n     ~q(~q).',[FactName, Object])
									;
									true
								)
						),
						
						format('~n~n:- end_object.~n~n',[])
					)
					;
					true
				)
			)
		),
		told.
	

save_axioms_individuals(File,Fmt,Opts) :-
        load_handler(write,Fmt),
        save_axioms_individuals_hook(File,Fmt,Opts),
        !.
save_axioms_individuals(File,Fmt,Opts) :-
        throw(owl2_to_logtalk('cannot save fmt for',File,Fmt,Opts)).



% TODO - check if this is the best way of doing this
load_handler(Dir,Fmt) :-
        forall(	format_module(Dir,Fmt,Mod),
	       		ensure_loaded(Mod)
		).

guess_format(File,Fmt,_Opts) :-
        concat_atom(Toks,'.',File),
        reverse(Toks,[Suffix,_|_]),
        suffix_format(Suffix,Fmt).

suffix_format(pro,prolog).
suffix_format(prolog,prolog).
suffix_format(pl,prolog).
suffix_format(owlpl,prolog).
suffix_format(plsyn,plsyn).
suffix_format(owl,owl).
suffix_format(ttl,owl).
suffix_format(owlx,owlx).
suffix_format(owlms,owlms).
suffix_format(owlapi(F),owlapi(F)).
suffix_format(owlapi,owlapi).

:- multifile format_module/3.
format_module(read,rdf, 'owl2_from_rdf.pl').
%format_module(read,owl, 'owl2_from_rdf.pl').
format_module(read,ttl, 'owl2_from_rdf.pl').
%format_module(read,xml, 'owl2_xml.pl').
%format_module(read,owlx, 'owl2_xml.pl').
%format_module(read,owlms, 'owl2_manchester_parser.pl').
format_module(read,pl_swrl, 'swrl.pl').
format_module(read,pl_swrl_owl, 'swrl.pl').
%format_module(read,plsyn, 'owl2_plsyn.pl').
%format_module(read,owlapi, 'owl2_java_owlapi.pl').
%format_module(read,owlapi(_), 'owl2_java_owlapi.pl').

%format_module(write,owl, 'owl2_export_rdf.pl').
%format_module(write,owlx, 'owl2_xml.pl').
%format_module(write,plsyn, 'owl2_plsyn.pl').
%format_module(write,dl_syntax, 'owl2_dl_syntax.pl').
%format_module(write,dlp, 'owl2_to_prolog_dlp.pl').



