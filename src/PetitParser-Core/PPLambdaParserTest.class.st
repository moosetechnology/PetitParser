Class {
	#name : #PPLambdaParserTest,
	#superclass : #PPCompositeParserTest,
	#category : #'PetitParser-Tests'
}

{ #category : #accessing }
PPLambdaParserTest >> parseClass [
	^ PPLambdaParser
]

{ #category : #testing }
PPLambdaParserTest >> testAbstraction [
	self assert: '\x.y' is: #('x' 'y').
	self assert: '\x.\y.z' is: #('x' ('y' 'z'))
]

{ #category : #'testing-curch' }
PPLambdaParserTest >> testAnd [
	self assert: self parseClass and = #('p' ('q' (('p' 'q') 'p')))
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
	self assert: self parseClass false = #('x' ('y' 'y'))
]

{ #category : #'testing-curch' }
PPLambdaParserTest >> testIfThenElse [
	self assert: self parseClass ifthenelse = #('p' 'p')
]

{ #category : #'testing-curch' }
PPLambdaParserTest >> testNot [
	self assert: self parseClass not = #('p' ('a' ('b' (('p' 'b') 'a'))))
]

{ #category : #'testing-curch' }
PPLambdaParserTest >> testOr [
	self assert: self parseClass or = #('p' ('q' (('p' 'p') 'q')))
]

{ #category : #'testing-curch' }
PPLambdaParserTest >> testTrue [
	self assert: self parseClass true = #('x' ('y' 'x'))
]

{ #category : #testing }
PPLambdaParserTest >> testVariable [
	self assert: 'x' is: 'x'.
	self assert: 'xy' is: 'xy'.
	self assert: 'x12' is: 'x12'
]
