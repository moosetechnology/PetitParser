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
PPFlattenParser >> parseAfterOn: aStream [
	"Consume input after the actual parse."
]

{ #category : #parsing }
PPFlattenParser >> parseBeforeOn: aStream [
	"Consume input before the actual parse."
]

{ #category : #parsing }
PPFlattenParser >> parseOn: aStream [
	| begin start element stop |
	begin := aStream position.
	self parseBeforeOn: aStream.
	start := aStream position.
	element := super parseOn: aStream.
	element isPetitFailure ifTrue: [ 
		aStream position: begin.
		^ element ].
	stop := aStream position.
	self parseAfterOn: aStream.
	^ self create: aStream collection start: start + 1 stop: stop
]
