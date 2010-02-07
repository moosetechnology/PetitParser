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
	stream := aCollection asPetitStream.
	result := aParser parse: stream.
	self assert: result isPetitFailure.
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
	stream := aParseObject asPetitStream.
	result := aParser parse: stream.
	aTargetObject isNil
		ifTrue: [ self deny: result isPetitFailure ]
		ifFalse: [ self assert: result = aTargetObject ].
	self assert: stream position = anInteger
]

{ #category : #utilities }
PPAbstractParseTest >> assert: aParser parse: aParserObject toToken: from stop: to [
	| token |
	token := PPToken on: aParserObject start: from stop: to.
	^ self assert: aParser parse: aParserObject to: token
]

{ #category : #utilities }
PPAbstractParseTest >> assert: aParser parse: aParserObject toToken: from stop: to end: end [
	| token |
	token := PPToken on: aParserObject start: from stop: to.
	^ self assert: aParser parse: aParserObject to: token end: end
]
