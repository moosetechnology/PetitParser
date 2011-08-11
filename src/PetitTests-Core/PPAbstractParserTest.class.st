Class {
	#name : #PPAbstractParserTest,
	#superclass : #TestCase,
	#category : #'PetitTests-Core'
}

{ #category : #testing }
PPAbstractParserTest class >> isAbstract [
	^ self name = #PPAbstractParserTest
]

{ #category : #accessing }
PPAbstractParserTest class >> packageNamesUnderTest [
	^ #('PetitParser' 'PetitTests')
]

{ #category : #utilities }
PPAbstractParserTest >> assert: aParser fail: aCollection [
	^ self assert: aParser fail: aCollection end: 0
]

{ #category : #utilities }
PPAbstractParserTest >> assert: aParser fail: aCollection end: anInteger [
	| stream result |
	self 
		assert: aParser isPetitParser
		description: 'Parser invalid'.
	stream := aCollection asPetitStream.
	result := aParser parse: stream.
	self 
		assert: result isPetitFailure
		description: 'Parser did not fail'.
	self
		assert: stream position = anInteger
		description: 'Parser failed at wrong position'.
	^ result
]

{ #category : #utilities }
PPAbstractParserTest >> assert: aParser parse: aCollection [
	^ self assert: aParser parse: aCollection to: nil end: aCollection size 
]

{ #category : #utilities }
PPAbstractParserTest >> assert: aParser parse: aCollection end: anInteger [
	^ self assert: aParser parse: aCollection to: nil end: anInteger
]

{ #category : #utilities }
PPAbstractParserTest >> assert: aParser parse: aCollection to: anObject [
	^ self assert: aParser parse: aCollection to: anObject end: aCollection size 
]

{ #category : #utilities }
PPAbstractParserTest >> assert: aParser parse: aParseObject to: aTargetObject end: anInteger [
	| stream result |
	self 
		assert: aParser isPetitParser
		description: 'Parser invalid'.
	stream := aParseObject asPetitStream.
	result := aParser parse: stream.
	aTargetObject isNil
		ifTrue: [ self deny: result isPetitFailure ]
		ifFalse: [ self assert: result = aTargetObject ].
	self 
		assert: stream position = anInteger
		description: 'Parser accepted at wrong position'.
	^ result
]

{ #category : #utilities }
PPAbstractParserTest >> assert: aParser parse: aParserObject toToken: from stop: to [
	| token |
	token := PPToken on: aParserObject start: from stop: to.
	^ self assert: aParser parse: aParserObject to: token
]

{ #category : #utilities }
PPAbstractParserTest >> assert: aParser parse: aParserObject toToken: from stop: to end: end [
	| token |
	token := PPToken on: aParserObject start: from stop: to.
	^ self assert: aParser parse: aParserObject to: token end: end
]
