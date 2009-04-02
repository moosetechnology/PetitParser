"
A memoized parser, for refraining redundant computations.
"
Class {
	#name : #PPMemoizedParser,
	#superclass : #PPDelegateParser,
	#instVars : [
		'stream',
		'buffer'
	],
	#category : #'PetitParser-Core'
}

{ #category : #operations }
PPMemoizedParser >> memoized [
	^ self
]

{ #category : #parsing }
PPMemoizedParser >> parse: aStream [
	| position memento |
	aStream == stream
		ifFalse: [ self reset: aStream ].
	position := stream position.
	memento := (buffer at: position + 1)
		ifNil: [ buffer at: position + 1 put: PPMemento new ].
	memento result isNil
		ifTrue: [
			memento result: (stream size - position + 1 < memento count
				ifTrue: [ PPFailure reason: 'overflow' at: position ]
				ifFalse: [ memento increment. super parse: aStream ]).
			memento position: position ]
		ifFalse: [ stream position: memento position ].
	^ memento result
]

{ #category : #private }
PPMemoizedParser >> reset: aStream [
	stream := aStream.
	buffer := Array new: aStream size + 1
]
