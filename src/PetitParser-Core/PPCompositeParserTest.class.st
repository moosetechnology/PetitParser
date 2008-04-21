Class {
	#name : #PPCompositeParserTest,
	#superclass : #TestCase,
	#instVars : [
		'parser'
	],
	#category : #'PetitParser-Tests'
}

{ #category : #utilities }
PPCompositeParserTest >> assert: aCollection fails: aString at: anInteger [
	| result |
	result := parser parse: aCollection readStream.
	self assert: (result isFailure).
	self assert: (result position = anInteger).
	self assert: (result reason includesSubstring: aString)
]

{ #category : #utilities }
PPCompositeParserTest >> assert: aCollection is: anObject [
	| result |
	result := parser parse: aCollection readStream.
	self assert: result = anObject
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
