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
	| parser |
	parser := PPLambdaParser new.
	self assert: parser parse: '\x.y' to: #($\ 'x' $. 'y').
	self assert: parser parse: '\x.\y.z' to: #($\ 'x' $. ($\ 'y' $. 'z'))
]

{ #category : #testing }
PPLambdaParserTest >> testApplication [
	| parser |
	parser := PPLambdaParser new.
	self assert: parser parse: 'x x' to: #('x' 'x').
	self assert: parser parse: 'x y' to: #('x' 'y').
	self assert: parser parse: 'x y z' to: #(('x' 'y') 'z')
]

{ #category : #testing }
PPLambdaParserTest >> testVariable [
	| parser |
	parser := PPLambdaParser new.
	self assert: parser parse: 'x' to: 'x'.
	self assert: parser parse: 'xy' to: 'xy'
]
