"
A parser that answers a flat copy of the range my delegate parses.
"
Class {
	#name : #PPFlattenParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Parsers'
}

{ #category : #private }
PPFlattenParser >> on: aCollection start: aStartInteger stop: aStopInteger value: anObject [
	^ aCollection copyFrom: aStartInteger to: aStopInteger
]

{ #category : #parsing }
PPFlattenParser >> parseOn: aStream [
	| start element |
	start := aStream position.
	element := parser parseOn: aStream.
	element isPetitFailure ifTrue: [ ^ element ].
	^ self on: aStream collection start: start + 1 stop: aStream position value: element
]
