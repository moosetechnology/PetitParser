"
These are some simple demos of parser combinators for the compiler construction course.
http://www.iam.unibe.ch/~scg/Teaching/CC/index.html
"
Class {
	#name : #PPDemoTest,
	#superclass : #PPAbstractParseTest,
	#category : #'PetitParser-Tests'
}

{ #category : #examples }
PPDemoTest >> addMulInterpreter [
	"Same as testMiniGrammar but with semantic actions"
	| mul prim add dec |
	add := PPParser new.
	mul := PPParser new.
	prim := PPParser new.
	dec := (PPPredicateParser between: $0 and: $9) ==> [ :token | token asciiValue - $0 asciiValue ].
	add def: ((mul , $+ asParser , add) 				==> [ :nodes | (nodes at: 1) + (nodes at: 3) ])
		/ mul.
	mul def: ((prim , $* asParser , mul) 			==> [ :nodes | (nodes at: 1) * (nodes at: 3) ])
		/ prim.
	prim def: (($( asParser , add , $) asParser) 		==> [ :nodes | nodes at: 2 ])
		/ dec.
	^ add
]

{ #category : #examples }
PPDemoTest >> addMulParser [
	"Simple demo of scripting a parser"
	| add mul prim dec |
	add := PPParser new.
	mul := PPParser new.
	prim := PPParser new.
	dec := PPPredicateParser between: $0 and: $9.

	add def: ( mul, $+ asParser, add )
		/ mul.
	mul def: ( prim, $* asParser, mul)
		/ prim.
	prim def: ( $( asParser, add, $) asParser)
		/ dec.

	^ add
]

{ #category : #examples }
PPDemoTest >> straightLineParser [
	| goal stm stmList id char dec exp expList mulExp primExp nonzero num lower upper |
	goal := PPParser new.
	stmList := PPParser new.
	stm := PPParser new.
	exp := PPParser new.
	expList := PPParser new.
	mulExp := PPParser new.
	primExp := PPParser new.
	
	lower := PPPredicateParser between: $a and: $z.
	upper := PPPredicateParser between: $A and: $Z.
	char := lower / upper.
	nonzero := PPPredicateParser between: $1 and: $9.
	dec := PPPredicateParser between: $0 and: $9.
	id := char, ( char / dec ) star.
	num := $0 asParser / ( nonzero, dec star).

	goal def: stmList end. "does not work with eof at the end"
	stmList def: stm , ( $; asParser, stm ) star.
	stm def: ( id, ':=' asParser, exp )
		/ ( 'print' asParser, $( asParser, expList, $) asParser ). 
	exp def: mulExp, ( ( $+ asParser / $- asParser ), mulExp ) star.
	expList def: exp, ( $, asParser, exp ) star.
	mulExp def: primExp, ( ( $* asParser / $/ asParser ), primExp ) star.
	primExp def: id
		/ num
		/ ( $( asParser, stmList, $, asParser, exp, $) asParser ).
	^ goal

]

{ #category : #tests }
PPDemoTest >> testMiniGrammar [
	self assert: (self addMulParser) parse: '2*(3+4)' to: #($2 $* #($( #($3 $+ $4) $))).
]

{ #category : #tests }
PPDemoTest >> testMiniSemanticActions [
	self 
		assert: (self addMulInterpreter)
		parse: '2*(3+4)'
		to: 14
]

{ #category : #tests }
PPDemoTest >> testSLassign [
	
	self assert: self straightLineParser
		parse: 'abc:=1'
		to: #(#($a #($b $c) ':=' #(#(#($1 #()) #()) #())) #())
]

{ #category : #tests }
PPDemoTest >> testSLprint [
	self assert: self straightLineParser
		parse: 'print(3,4)'
		to: #(#('print' $( #(#(#($3 #()) #()) #() #(#($, #(#(#($4 #()) #()) #())))) $)) #())
]
