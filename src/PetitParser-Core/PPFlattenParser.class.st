"
A parser that produces a token from the range my delegate parses.
"
Class {
	#name : #PPFlattenParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Core'
}

{ #category : #hooks }
PPFlattenParser >> consumeSpaces: aStream [
	[ aStream atEnd not and: [ aStream peek isSeparator ] ]
		whileTrue: [ aStream next ]
]

{ #category : #hooks }
PPFlattenParser >> create: aCollection start: aStartInteger stop: aStopInteger [
	^ aCollection copyFrom: aStartInteger to: aStopInteger
]

{ #category : #parsing }
PPFlattenParser >> parse: aStream [
	| start element stop |
	start := aStream position.
	element := super parse: aStream.
	element isFailure ifTrue: [ ^ element ].
	stop := aStream position.
	self consumeSpaces: aStream.
	^ self create: aStream collection start: start + 1 stop: stop
]
