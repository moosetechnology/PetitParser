"
A parser that answers a token of the range my delegate parses. The receiver silently consumes spaces before and after the actual token.
"
Class {
	#name : #PPTokenParser,
	#superclass : #PPFlattenParser,
	#category : #'PetitParser-Core'
}

{ #category : #hooks }
PPTokenParser >> consumeSpaces: aStream [
	[ aStream atEnd not and: [ aStream peek isSeparator ] ]
		whileTrue: [ aStream next ]
]

{ #category : #hooks }
PPTokenParser >> create: aCollection start: aStartInteger stop: aStopInteger [
	^ PPToken on: aCollection start: aStartInteger stop: aStopInteger
]

{ #category : #parsing }
PPTokenParser >> parseAfter: aStream [
	self consumeSpaces: aStream
]

{ #category : #parsing }
PPTokenParser >> parseBefore: aStream [
	self consumeSpaces: aStream
]
