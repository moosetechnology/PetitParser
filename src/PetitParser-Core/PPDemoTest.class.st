"
These are some simple demos of parser combinators for the compiler construction course.
http://www.iam.unibe.ch/~scg/Teaching/CC/index.html
"
Class {
	#name : #PPDemoTest,
	#superclass : #PPAbstractParseTest,
	#category : #'PetitParser-Tests'
}

{ #category : #'as yet unclassified' }
PPDemoTest >> testMiniGrammar [
	| add mul prim dec |
	add := PPChoiceParser new.
	mul := PPChoiceParser new.
	prim := PPChoiceParser new.
	dec := PPPredicateParser between: $0 and: $9.

	add | ( mul, $+ asParser, add )
		| mul.
	mul | ( prim, $* asParser, mul)
		| prim.
	prim | ( $( asParser, add, $) asParser)
		| dec.

	self assert: add parse: '2*(3+4)' to: #($2 $* #($( #($3 $+ $4) $))).
]
