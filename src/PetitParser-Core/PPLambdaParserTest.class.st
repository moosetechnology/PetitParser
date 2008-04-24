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
	self assert: '\x.y' is: #($\ 'x' $. 'y').
	self assert: '\x.\y.z' is: #($\ 'x' $. ($\ 'y' $. 'z'))
]

{ #category : #testing }
PPLambdaParserTest >> testApplication [
	self assert: 'x x' is: #('x' 'x').
	self assert: 'x y' is: #('x' 'y').
	self assert: 'x y z' is: #(('x' 'y') 'z')
]

{ #category : #testing }
PPLambdaParserTest >> testVariable [
	self assert: 'x' is: 'x'.
	self assert: 'xy' is: 'xy'
]
