Class {
	#name : #PPCompositeParserTest,
	#superclass : #TestCase,
	#instVars : [
		'parser'
	],
	#category : #'PetitParser-Tests'
}

{ #category : #testing }
PPCompositeParserTest class >> isAbstract [
	^ self name = #PPCompositeParserTest
]

{ #category : #utilities }
PPCompositeParserTest >> assert: aCollection is: anObject [
	| result |
	result := parser parse: aCollection asParserStream.
	result isFailure
		ifTrue: [ self error: result printString ].
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

{ #category : #testing }
PPCompositeParserTest >> testProductionAt [
	self assert: (parser productionAt: #foo) isNil.
	self assert: (parser productionAt: #foo ifAbsent: [ true ])
	
]
