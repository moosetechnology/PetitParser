"
A parser that silently consumes spaces before and after the delegate parser.
"
Class {
	#name : #PPTrimmingParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Core'
}

{ #category : #private }
PPTrimmingParser >> consumeSpaces: aStream [
	[ aStream atEnd not and: [ aStream peek isSeparator ] ]
		whileTrue: [ aStream next ]
]

{ #category : #parsing }
PPTrimmingParser >> parseAfterOn: aStream [
	self consumeSpaces: aStream
]

{ #category : #parsing }
PPTrimmingParser >> parseBeforeOn: aStream [
	self consumeSpaces: aStream
]

{ #category : #parsing }
PPTrimmingParser >> parseOn: aStream [
	| position element |
	position := aStream position.
	self parseBeforeOn: aStream.
	element := super parseOn: aStream.
	element isPetitFailure ifTrue: [
		aStream position: position.
		^ element ].
	self parseAfterOn: aStream.
	^ element
]
