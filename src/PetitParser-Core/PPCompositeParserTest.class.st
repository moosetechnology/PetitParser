Class {
	#name : #PPCompositeParserTest,
	#superclass : #TestCase,
	#instVars : [
		'parser'
	],
	#category : #'PetitParser-Tests'
}

{ #category : #utilities }
PPCompositeParserTest >> assert: aCollection is: anObject [
	| result |
	result := parser
		parse: aCollection asParserStream
		ifError: [ :err | self error: err printString ].
	self
		assert: result = anObject
		description: 'Got: ' , result printString , '; Expected: ' , anObject printString
		resumable: true
]

{ #category : #accessing }
PPCompositeParserTest >> parseClass [
	self subclassResponsibility
]

{ #category : #running }
PPCompositeParserTest >> setUp [
	super setUp.
	parser := self parseClass new
]
