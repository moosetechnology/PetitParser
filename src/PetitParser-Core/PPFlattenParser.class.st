"
A parser that answers a flat copy of the range my delegate parses.
"
Class {
	#name : #PPFlattenParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Parsers'
}

{ #category : #hooks }
PPFlattenParser >> create: aCollection start: aStartInteger stop: aStopInteger [
	^ aCollection copyFrom: aStartInteger to: aStopInteger
]

{ #category : #parsing }
PPFlattenParser >> parseOn: aStream [
	| start element stop |
	start := aStream position.
	element := parser parseOn: aStream.
	element isPetitFailure ifTrue: [
		aStream position: start.
		^ element ].
	stop := aStream position.
	^ self create: aStream collection start: start + 1 stop: stop
]
