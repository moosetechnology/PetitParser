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
	"Simple demo of scripting a parser"
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

{ #category : #'as yet unclassified' }
PPDemoTest >> testMiniSemanticActions [
	"Same as testMiniGrammar but with semantic actions"
	| add mul prim dec |
	add := PPChoiceParser new.
	mul := PPChoiceParser new.
	prim := PPChoiceParser new.
	dec := (PPPredicateParser between: $0 and: $9) ==> [:token | token asciiValue - $0 asciiValue].

	add | (( mul, $+ asParser, add ) ==> [:nodes | (nodes at: 1) + (nodes at: 3) ])
		| mul.
	mul | (( prim, $* asParser, mul) ==> [:nodes | (nodes at: 1) * (nodes at: 3) ])
		| prim.
	prim | (( $( asParser, add, $) asParser) ==> [:nodes | nodes at: 2 ])
		| dec.

	self assert: add parse: '2*(3+4)' to: 14.
]
