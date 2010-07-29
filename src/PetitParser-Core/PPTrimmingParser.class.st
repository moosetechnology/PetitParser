"
A parser that silently consumes spaces before and after the delegate parser.
"
Class {
	#name : #PPTrimmingParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Parsers'
}

{ #category : #private }
PPTrimmingParser >> consumeSpaces: aStream [
	self subclassResponsibility
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
