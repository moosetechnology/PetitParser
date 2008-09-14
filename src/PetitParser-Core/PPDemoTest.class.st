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
	add := PPChoiceParser new.
	mul := PPChoiceParser new.
	prim := PPChoiceParser new.
	dec := (PPPredicateParser between: $0 and: $9) ==> [ :token | token asciiValue - $0 asciiValue ].
	add | ((mul , $+ asParser , add) 				==> [ :nodes | (nodes at: 1) + (nodes at: 3) ])
		| mul.
	mul | ((prim , $* asParser , mul) 			==> [ :nodes | (nodes at: 1) * (nodes at: 3) ])
		| prim.
	prim | (($( asParser , add , $) asParser) 		==> [ :nodes | nodes at: 2 ])
		| dec.
	^ add
]

{ #category : #examples }
PPDemoTest >> addMulParser [
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

	^ add
]

{ #category : #examples }
PPDemoTest >> straightLineParser [
	| goal stm stmList id char dec exp expList mulExp primExp nonzero num lower upper |
	stmList := PPSequenceParser new.
	stm := PPChoiceParser new.
	exp := PPSequenceParser new.
	expList := PPSequenceParser new.
	mulExp := PPSequenceParser new.
	primExp := PPChoiceParser new.
	
	lower := PPPredicateParser between: $a and: $z.
	upper := PPPredicateParser between: $A and: $Z.
	char := lower | upper.
	nonzero := PPPredicateParser between: $1 and: $9.
	dec := PPPredicateParser between: $0 and: $9.
	id := char, ( char | dec ) star.
	num := $0 asParser | ( nonzero, dec star).
"	eof := PPEndOfInputParser new.
	"
	goal := stmList. ", eof"
	stmList , stm , ( $; asParser, stm ) star.
	stm | ( id, ':=' asParser, exp )
		| ( 'print' asParser, $( asParser, expList, $) asParser ). 
	exp , mulExp, ( ( $+ asParser | $- asParser ), mulExp ) star.
	expList , exp, ( $, asParser, exp ) star.
	mulExp , primExp, ( ( $* asParser | $/ asParser ), primExp ) star.
	primExp | id
		| num
		| ( $( asParser, stmList, $, asParser, exp, $) asParser ).
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
		to: #(#($a #($b $c) #($: $=) #(#(#($1 #()) #()) #())) #())
]

{ #category : #tests }
PPDemoTest >> testSLprint [
	
	self assert: self straightLineParser
		parse: 'print(3,4)'
		to:  #(#($p $r $i $n $t $( #(#(#(#($3 #()) #()) #()) #(#($, #(#(#($4 #()) #()) #())))) $)) #())
]
