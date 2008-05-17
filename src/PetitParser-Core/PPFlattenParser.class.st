"
A parser that produces a token from the range my delegate parses.
"
Class {
	#name : #PPFlattenParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Core'
}

{ #category : #parsing }
PPFlattenParser >> basicParse: aStream [
	| start element stop |
	start := aStream position.
	element := super basicParse: aStream.
	element isFailure ifTrue: [ ^ element ].
	stop := aStream position.
	self consumeSpaces: aStream.
	^ self create: aStream collection from: start + 1 to: stop
]

{ #category : #hooks }
PPFlattenParser >> consumeSpaces: aStream [
	[ aStream atEnd not and: [ aStream peek isSeparator ] ]
		whileTrue: [ aStream next ]
]

{ #category : #hooks }
PPFlattenParser >> create: aCollection from: aStartInteger to: aStopInteger [
	^ aCollection copyFrom: aStartInteger to: aStopInteger
]
