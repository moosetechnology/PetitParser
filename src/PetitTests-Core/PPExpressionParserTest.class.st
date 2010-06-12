Class {
	#name : #PPExpressionParserTest,
	#superclass : #PPArithmeticParserTest,
	#category : #'PetitTests-Tests'
}

{ #category : #testing }
PPExpressionParserTest class >> shouldInheritSelectors [
	^ true
]

{ #category : #accessing }
PPExpressionParserTest >> parserInstance [
	| expression parens number |
	expression := PPExpressionParser new.
	parens := $( asParser token trim , expression , $) asParser token trim
		==> [ :nodes | nodes second ].
	number := (#digit asParser plus , ($. asParser , #digit asParser plus) optional) token trim
		==> [ :token | token value asNumber ].
	expression term: parens / number.
	expression
		group: [ :g |
			g prefix: $- asParser token trim do: [ :op :a | a negated ] ];
		group: [ :g |
			g postfix: '++' asParser token trim do: [ :a :op | a + 1 ].
			g postfix: '--' asParser token trim do: [ :a :op | a - 1 ] ];
		group: [ :g |
			g right: $^ asParser token trim do: [ :a :op :b | a raisedTo: b ] ];
		group: [ :g |
			g left: $* asParser token trim do: [ :a :op :b | a * b ].
			g left: $/ asParser token trim do: [ :a :op :b | a / b ] ];
		group: [ :g |
			g left: $+ asParser token trim do: [ :a :op :b | a + b ].
			g left: $- asParser token trim do: [ :a :op :b | a - b ] ].
	^ expression end
]

{ #category : #testing }
PPExpressionParserTest >> testPostfixAdd [
	self assert: '0++' is: 1.
	self assert: '0++++' is: 2.
	self assert: '0++++++' is: 3.

	self assert: '0+++1' is: 2.
	self assert: '0+++++1' is: 3.
	self assert: '0+++++++1' is: 4
]

{ #category : #testing }
PPExpressionParserTest >> testPostfixSub [
	self assert: '1--' is: 0.
	self assert: '2----' is: 0.
	self assert: '3------' is: 0.

	self assert: '2---1' is: 0.
	self assert: '3-----1' is: 0.
	self assert: '4-------1' is: 0.
]

{ #category : #testing }
PPExpressionParserTest >> testPrefixNegate [
	self assert: '1' is: 1.
	self assert: '-1' is: -1.
	self assert: '--1' is: 1.
	self assert: '---1' is: -1
]
