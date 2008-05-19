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
	| stream result |
	stream := PPStream on: aCollection.
	result := parser parse: stream.
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
