/*
subClassOf('http://ai4.inf.uni-bayreuth.de/ontology/organization#Division','http://ai4.inf.uni-bayreuth.de/ontology/organization#Group')
subClassOf('http://ai4.inf.uni-bayreuth.de/ontology/tool#Application','http://ai4.inf.uni-bayreuth.de/ontology/tool#Tool')
subClassOf('http://ai4.inf.uni-bayreuth.de/ontology/tool#Computer','http://ai4.inf.uni-bayreuth.de/ontology/tool#Tool')
subClassOf('http://ai4.inf.uni-bayreuth.de/ontology/tool#Machine','http://ai4.inf.uni-bayreuth.de/ontology/tool#Tool')
transitiveProperty('http://ai4.inf.uni-bayreuth.de/ontology/organization#supervises')
subPropertyOf('http://ai4.inf.uni-bayreuth.de/ontology/tool#can_consume','http://www.w3.org/2002/07/owl#topObjectProperty')
subPropertyOf('http://ai4.inf.uni-bayreuth.de/ontology/tool#can_produce','http://www.w3.org/2002/07/owl#topObjectProperty')
irreflexiveProperty('http://ai4.inf.uni-bayreuth.de/ontology/organization#supervises')
propertyDomain('http://ai4.inf.uni-bayreuth.de/ontology/organization#member','http://ai4.inf.uni-bayreuth.de/ontology/organization#Group')
propertyDomain('http://ai4.inf.uni-bayreuth.de/ontology/organization#plays','http://ai4.inf.uni-bayreuth.de/ontology/organization#Person')
propertyDomain('http://ai4.inf.uni-bayreuth.de/ontology/organization#supervises','http://ai4.inf.uni-bayreuth.de/ontology/organization#Role')
propertyDomain('http://ai4.inf.uni-bayreuth.de/ontology/organization#supervisorOf','http://ai4.inf.uni-bayreuth.de/ontology/organization#Person')
propertyDomain('http://ai4.inf.uni-bayreuth.de/ontology/tool#can_consume','http://ai4.inf.uni-bayreuth.de/ontology/tool#Application')
propertyDomain('http://ai4.inf.uni-bayreuth.de/ontology/tool#can_produce','http://ai4.inf.uni-bayreuth.de/ontology/tool#Application')
propertyRange('http://ai4.inf.uni-bayreuth.de/ontology/organization#member','http://ai4.inf.uni-bayreuth.de/ontology/organization#Person')
propertyRange('http://ai4.inf.uni-bayreuth.de/ontology/organization#plays','http://ai4.inf.uni-bayreuth.de/ontology/organization#Role')
propertyRange('http://ai4.inf.uni-bayreuth.de/ontology/organization#supervises','http://ai4.inf.uni-bayreuth.de/ontology/organization#Role')
propertyRange('http://ai4.inf.uni-bayreuth.de/ontology/organization#supervisorOf','http://ai4.inf.uni-bayreuth.de/ontology/organization#Person')
propertyRange('http://ai4.inf.uni-bayreuth.de/ontology/tool#can_consume','http://ai4.inf.uni-bayreuth.de/ontology/tool#Type')
propertyAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#supervises','http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor','http://ai4.inf.uni-bayreuth.de/ontology/individuals#MTA')
propertyAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#supervises','http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantMedicalDirector','http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor')
propertyAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#member','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Cardiology','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Hugo')
propertyAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#member','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Cardiology','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Jack')
propertyAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#member','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Cardiology','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Jacob')
propertyAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#member','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Cardiology','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Kate')
propertyAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#plays','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Charles','http://ai4.inf.uni-bayreuth.de/ontology/individuals#MedicalSuperintendent')
propertyAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#plays','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Claire','http://ai4.inf.uni-bayreuth.de/ontology/individuals#MTA')
propertyAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#plays','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Hugo','http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantMedicalDirector')
propertyAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#plays','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Jack','http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor')
propertyAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#plays','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Jacob','http://ai4.inf.uni-bayreuth.de/ontology/individuals#MedicalSuperintendent')
propertyAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#plays','http://ai4.inf.uni-bayreuth.de/ontology/individuals#John','http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor')
propertyAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#plays','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Kate','http://ai4.inf.uni-bayreuth.de/ontology/individuals#MTA')
propertyAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#supervises','http://ai4.inf.uni-bayreuth.de/ontology/individuals#MedicalSuperintendent','http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantMedicalDirector')
propertyAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#plays','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Peter','http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantMedicalDirector')
propertyAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#member','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Surgery','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Charles')
propertyAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#member','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Surgery','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Claire')
propertyAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#member','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Surgery','http://ai4.inf.uni-bayreuth.de/ontology/individuals#John')
propertyAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#member','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Surgery','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Peter')
classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#Role','http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor')
classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#Role','http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantMedicalDirector')
classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#Division','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Cardiology')
classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#Person','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Charles')
classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#Person','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Claire')
classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#Person','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Hugo')
classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#Person','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Jack')
classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#Person','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Jacob')
classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#Person','http://ai4.inf.uni-bayreuth.de/ontology/individuals#John')
classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#Person','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Kate')
classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#Role','http://ai4.inf.uni-bayreuth.de/ontology/individuals#MTA')
classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#Role','http://ai4.inf.uni-bayreuth.de/ontology/individuals#MedicalSuperintendent')
classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#Person','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Peter')
classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/organization#Division','http://ai4.inf.uni-bayreuth.de/ontology/individuals#Surgery')
classAssertion('http://www.w3.org/2003/11/swrl#Variable','http://ai4.inf.uni-bayreuth.de/ontology/d')
classAssertion('http://www.w3.org/2003/11/swrl#Variable','http://ai4.inf.uni-bayreuth.de/ontology/a')
classAssertion('http://www.w3.org/2003/11/swrl#Variable','http://ai4.inf.uni-bayreuth.de/ontology/b')
classAssertion('http://www.w3.org/2003/11/swrl#Variable','http://ai4.inf.uni-bayreuth.de/ontology/r')
classAssertion('http://www.w3.org/2003/11/swrl#Variable','http://ai4.inf.uni-bayreuth.de/ontology/s')
classAssertion('http://www.w3.org/2003/11/swrl#AtomList','__organization.owl#__Description2')
classAssertion('http://www.w3.org/2003/11/swrl#AtomList','__organization.owl#__Description4')
classAssertion('http://www.w3.org/2003/11/swrl#AtomList','__organization.owl#__Description6')
classAssertion('http://www.w3.org/2003/11/swrl#AtomList','__organization.owl#__Description8')
classAssertion('http://www.w3.org/2003/11/swrl#AtomList','__organization.owl#__Description10')
classAssertion('http://www.w3.org/2003/11/swrl#AtomList','__organization.owl#__Description12')
classAssertion('http://www.w3.org/2003/11/swrl#AtomList','__organization.owl#__Description13')
classAssertion('http://www.w3.org/2003/11/swrl#AtomList','__organization.owl#__Description15')
classAssertion('http://www.w3.org/2003/11/swrl#AtomList','__organization.owl#__Description16')
classAssertion('http://www.w3.org/2003/11/swrl#AtomList','__organization.owl#__Description17')
classAssertion('http://www.w3.org/2003/11/swrl#AtomList','__organization.owl#__Description19')
namedIndividual('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor')
namedIndividual('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantMedicalDirector')
namedIndividual('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Cardiology')
namedIndividual('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Charles')
namedIndividual('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Claire')
namedIndividual('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Hugo')
namedIndividual('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Jack')
namedIndividual('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Jacob')
namedIndividual('http://ai4.inf.uni-bayreuth.de/ontology/individuals#John')
namedIndividual('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Kate')
namedIndividual('http://ai4.inf.uni-bayreuth.de/ontology/individuals#MTA')
namedIndividual('http://ai4.inf.uni-bayreuth.de/ontology/individuals#MedicalSuperintendent')
namedIndividual('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Peter')
namedIndividual('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Surgery')
objectProperty('http://ai4.inf.uni-bayreuth.de/ontology/organization#member')
objectProperty('http://ai4.inf.uni-bayreuth.de/ontology/organization#plays')
objectProperty('http://ai4.inf.uni-bayreuth.de/ontology/organization#supervises')
objectProperty('http://ai4.inf.uni-bayreuth.de/ontology/organization#supervisorOf')
objectProperty('http://ai4.inf.uni-bayreuth.de/ontology/tool#can_consume')
objectProperty('http://ai4.inf.uni-bayreuth.de/ontology/tool#can_produce')
objectProperty('http://www.w3.org/2002/07/owl#topObjectProperty')
annotationProperty('http://www.w3.org/2000/01/rdf-schema#label')
annotationProperty('http://www.w3.org/2000/01/rdf-schema#comment')
annotationProperty('http://www.semanticweb.org/owlapi#nodeID')
annotationProperty('http://www.semanticweb.org/owlapi#iri')
annotationProperty('http://www.w3.org/2000/01/rdf-schema#label')
annotationProperty('http://www.w3.org/2000/01/rdf-schema#comment')
class('http://ai4.inf.uni-bayreuth.de/ontology/organization#Division')
class('http://ai4.inf.uni-bayreuth.de/ontology/organization#Group')
class('http://ai4.inf.uni-bayreuth.de/ontology/organization#Person')
class('http://ai4.inf.uni-bayreuth.de/ontology/organization#Role')
class('http://ai4.inf.uni-bayreuth.de/ontology/tool#Application')
class('http://ai4.inf.uni-bayreuth.de/ontology/tool#Computer')
class('http://ai4.inf.uni-bayreuth.de/ontology/tool#Machine')
class('http://ai4.inf.uni-bayreuth.de/ontology/tool#Tool')
class('http://ai4.inf.uni-bayreuth.de/ontology/tool#Type')
ontology('http://ai4.inf.uni-bayreuth.de/ontology/organization')
ontology('http://ai4.inf.uni-bayreuth.de/ontology/tool')
implies([description('http://ai4.inf.uni-bayreuth.de/ontology/organization#Division',i('http://ai4.inf.uni-bayreuth.de/ontology/d')),description('http://ai4.inf.uni-bayreuth.de/ontology/organization#Person',i('http://ai4.inf.uni-bayreuth.de/ontology/a')),description('http://ai4.inf.uni-bayreuth.de/ontology/organization#Person',i('http://ai4.inf.uni-bayreuth.de/ontology/b')),description('http://ai4.inf.uni-bayreuth.de/ontology/organization#Role',i('http://ai4.inf.uni-bayreuth.de/ontology/r')),description('http://ai4.inf.uni-bayreuth.de/ontology/organization#Role',i('http://ai4.inf.uni-bayreuth.de/ontology/s')),'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'(i('http://ai4.inf.uni-bayreuth.de/ontology/d'),i('http://ai4.inf.uni-bayreuth.de/ontology/a')),'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'(i('http://ai4.inf.uni-bayreuth.de/ontology/d'),i('http://ai4.inf.uni-bayreuth.de/ontology/b')),'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'(i('http://ai4.inf.uni-bayreuth.de/ontology/a'),i('http://ai4.inf.uni-bayreuth.de/ontology/s')),'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'(i('http://ai4.inf.uni-bayreuth.de/ontology/b'),i('http://ai4.inf.uni-bayreuth.de/ontology/r')),'http://ai4.inf.uni-bayreuth.de/ontology/organization#supervises'(i('http://ai4.inf.uni-bayreuth.de/ontology/s'),i('http://ai4.inf.uni-bayreuth.de/ontology/r'))],['http://ai4.inf.uni-bayreuth.de/ontology/organization#supervisorOf'(i('http://ai4.inf.uni-bayreuth.de/ontology/a'),i('http://ai4.inf.uni-bayreuth.de/ontology/b'))])
*/
% classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor', 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Role')
:- object('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor',
 instantiates('http://ai4.inf.uni-bayreuth.de/ontology/organization#Role')).

     'http://ai4.inf.uni-bayreuth.de/ontology/organization#supervises'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#MTA').

:- end_object.

% classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantMedicalDirector', 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Role')
:- object('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantMedicalDirector',
 instantiates('http://ai4.inf.uni-bayreuth.de/ontology/organization#Role')).

     'http://ai4.inf.uni-bayreuth.de/ontology/organization#supervises'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor').

:- end_object.

% classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Cardiology', 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Division')
:- object('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Cardiology',
 instantiates('http://ai4.inf.uni-bayreuth.de/ontology/organization#Division')).

     'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Hugo').
     'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Jack').
     'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Jacob').
     'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Kate').

:- end_object.

% classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Charles', 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person')
:- object('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Charles',
 instantiates('http://ai4.inf.uni-bayreuth.de/ontology/organization#Person')).

     'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#MedicalSuperintendent').

:- end_object.

% classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Claire', 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person')
:- object('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Claire',
 instantiates('http://ai4.inf.uni-bayreuth.de/ontology/organization#Person')).

     'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#MTA').

:- end_object.

% classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Hugo', 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person')
:- object('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Hugo',
 instantiates('http://ai4.inf.uni-bayreuth.de/ontology/organization#Person')).

     'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantMedicalDirector').

:- end_object.

% classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Jack', 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person')
:- object('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Jack',
 instantiates('http://ai4.inf.uni-bayreuth.de/ontology/organization#Person')).

     'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor').

:- end_object.

% classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Jacob', 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person')
:- object('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Jacob',
 instantiates('http://ai4.inf.uni-bayreuth.de/ontology/organization#Person')).

     'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#MedicalSuperintendent').

:- end_object.

% classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/individuals#John', 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person')
:- object('http://ai4.inf.uni-bayreuth.de/ontology/individuals#John',
 instantiates('http://ai4.inf.uni-bayreuth.de/ontology/organization#Person')).

     'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantDoctor').

:- end_object.

% classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Kate', 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person')
:- object('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Kate',
 instantiates('http://ai4.inf.uni-bayreuth.de/ontology/organization#Person')).

     'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#MTA').

:- end_object.

% classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/individuals#MTA', 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Role')
:- object('http://ai4.inf.uni-bayreuth.de/ontology/individuals#MTA',
 instantiates('http://ai4.inf.uni-bayreuth.de/ontology/organization#Role')).


:- end_object.

% classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/individuals#MedicalSuperintendent', 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Role')
:- object('http://ai4.inf.uni-bayreuth.de/ontology/individuals#MedicalSuperintendent',
 instantiates('http://ai4.inf.uni-bayreuth.de/ontology/organization#Role')).

     'http://ai4.inf.uni-bayreuth.de/ontology/organization#supervises'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantMedicalDirector').

:- end_object.

% classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Peter', 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Person')
:- object('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Peter',
 instantiates('http://ai4.inf.uni-bayreuth.de/ontology/organization#Person')).

     'http://ai4.inf.uni-bayreuth.de/ontology/organization#plays'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#AssistantMedicalDirector').

:- end_object.

% classAssertion('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Surgery', 'http://ai4.inf.uni-bayreuth.de/ontology/organization#Division')
:- object('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Surgery',
 instantiates('http://ai4.inf.uni-bayreuth.de/ontology/organization#Division')).

     'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Charles').
     'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Claire').
     'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#John').
     'http://ai4.inf.uni-bayreuth.de/ontology/organization#member'('http://ai4.inf.uni-bayreuth.de/ontology/individuals#Peter').

:- end_object.

