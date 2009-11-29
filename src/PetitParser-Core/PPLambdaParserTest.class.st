Class {
	#name : #PPLambdaParserTest,
	#superclass : #PPCompositeParserTest,
	#category : #'PetitParser-Tests'
}

{ #category : #accessing }
PPLambdaParserTest >> parserClass [
	^ PPLambdaParser
]

{ #category : #testing }
PPLambdaParserTest >> testAbstraction [
	self assert: '\x.y' is: #('x' 'y').
	self assert: '\x.\y.z' is: #('x' ('y' 'z'))
]

{ #category : #'testing-curch' }
PPLambdaParserTest >> testAnd [
	self assert: self parserClass and = #('p' ('q' (('p' 'q') 'p')))
]

{ #category : #testing }
PPLambdaParserTest >> testApplication [
	self assert: '(x x)' is: #('x' 'x').
	self assert: '(x y)' is: #('x' 'y').
	self assert: '((x y) z)' is: #(('x' 'y') 'z').
	self assert: '(x (y z))' is: #('x' ('y' 'z'))
]

{ #category : #'testing-curch' }
PPLambdaParserTest >> testFalse [
	self assert: self parserClass false = #('x' ('y' 'y'))
]

{ #category : #'testing-curch' }
PPLambdaParserTest >> testIfThenElse [
	self assert: self parserClass ifthenelse = #('p' 'p')
]

{ #category : #'testing-curch' }
PPLambdaParserTest >> testNot [
	self assert: self parserClass not = #('p' ('a' ('b' (('p' 'b') 'a'))))
]

{ #category : #'testing-curch' }
PPLambdaParserTest >> testOr [
	self assert: self parserClass or = #('p' ('q' (('p' 'p') 'q')))
]

{ #category : #testing }
PPLambdaParserTest >> testParseIfError [
	| result beenHere |
	result := self parserClass
		parse: '\x.y'
		ifError: [ :fail | self fail ].
	self assert: result = #('x' 'y').
	
	beenHere := false.
	result := self parserClass
		parse: '\x.'
		ifError: [ :fail | 
			beenHere := true.
			fail ].
	self assert: beenHere.
	self assert: result reason = 'letter expected'.
	self assert: result position = 3
]

{ #category : #'testing-utilities' }
PPLambdaParserTest >> testProductionAt [
	self assert: (parser productionAt: #foo) isNil.
	self assert: (parser productionAt: #foo ifAbsent: [ true ]).
	
	self assert: (parser productionAt: #start) notNil.
	self assert: (parser productionAt: #start ifAbsent: [ true ]) notNil.
	
	self assert: (parser productionAt: #variable) notNil.
	self assert: (parser productionAt: #variable ifAbsent: [ true ]) notNil
]

{ #category : #'testing-curch' }
PPLambdaParserTest >> testTrue [
	self assert: self parserClass true = #('x' ('y' 'x'))
]

{ #category : #testing }
PPLambdaParserTest >> testVariable [
	self assert: 'x' is: 'x'.
	self assert: 'xy' is: 'xy'.
	self assert: 'x12' is: 'x12'
]
