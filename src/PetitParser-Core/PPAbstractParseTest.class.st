Class {
	#name : #PPAbstractParseTest,
	#superclass : #TestCase,
	#category : #'PetitParser-Tests'
}

{ #category : #testing }
PPAbstractParseTest class >> isAbstract [
	^ self name = #PPAbstractParseTest
]

{ #category : #accessing }
PPAbstractParseTest class >> packageNamesUnderTest [
	^ #('PetitParser')
]

{ #category : #utilities }
PPAbstractParseTest >> assert: aParser fail: aCollection [
	| stream result |
	stream := aCollection asParserStream.
	result := aParser parse: stream.
	self assert: result isFailure.
	self assert: stream position = 0
]

{ #category : #utilities }
PPAbstractParseTest >> assert: aParser parse: aCollection [
	self assert: aParser parse: aCollection to: nil end: aCollection size 
]

{ #category : #utilities }
PPAbstractParseTest >> assert: aParser parse: aCollection end: anInteger [
	self assert: aParser parse: aCollection to: nil end: anInteger
]

{ #category : #utilities }
PPAbstractParseTest >> assert: aParser parse: aCollection to: anObject [
	self assert: aParser parse: aCollection to: anObject end: aCollection size 
]

{ #category : #utilities }
PPAbstractParseTest >> assert: aParser parse: aParseObject to: aTargetObject end: anInteger [
	| stream result |
	stream := aParseObject asParserStream.
	result := aParser parse: stream.
	aTargetObject isNil
		ifTrue: [ self deny: result isFailure ]
		ifFalse: [ self assert: result value = aTargetObject ].
	self assert: stream position = anInteger
]
