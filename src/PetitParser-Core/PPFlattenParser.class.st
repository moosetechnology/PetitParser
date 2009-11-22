"
A parser that answers a flat copy of the range my delegate parses.
"
Class {
	#name : #PPFlattenParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Core'
}

{ #category : #hooks }
PPFlattenParser >> create: aCollection start: aStartInteger stop: aStopInteger [
	^ aCollection copyFrom: aStartInteger to: aStopInteger
]

{ #category : #parsing }
PPFlattenParser >> parse: aStream [
	| start element stop |
	self parseBefore: aStream.
	start := aStream position.
	element := super parse: aStream.
	element isFailure ifTrue: [ ^ element ].
	stop := aStream position.
	self parseAfter: aStream.
	^ self create: aStream collection start: start + 1 stop: stop
]

{ #category : #parsing }
PPFlattenParser >> parseAfter: aStream [
	"Consume input after the actual parse."
]

{ #category : #parsing }
PPFlattenParser >> parseBefore: aStream [
	"Consume input before the actual parse."
]
