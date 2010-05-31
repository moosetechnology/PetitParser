"
A memoized parser, for refraining redundant computations.

Instance Variables:
	stream	<PositionableStream>	The stream of the associated memento objects.
	buffer	<Array of: PPMemento>	The buffer of memento objects.

"
Class {
	#name : #PPMemoizedParser,
	#superclass : #PPDelegateParser,
	#instVars : [
		'stream',
		'buffer'
	],
	#category : #'PetitParser-Parsers'
}

{ #category : #operations }
PPMemoizedParser >> memoized [
	"Ther is no point in memoizing more than once."

	^ self
]

{ #category : #parsing }
PPMemoizedParser >> parseOn: aStream [
	| memento |
	stream == aStream
		ifFalse: [ self reset: aStream ].
	memento := (buffer at: stream position + 1)
		ifNil: [ buffer at: stream position + 1 put: PPMemento new ].
	memento position isNil
		ifTrue: [
			memento result: (stream size - stream position + 2 < memento count
				ifTrue: [ PPFailure message: 'overflow' at: stream position ]
				ifFalse: [ memento increment. super parseOn: stream ]).
			memento position: stream position ]
		ifFalse: [ stream position: memento position ].
	^ memento result
]

{ #category : #private }
PPMemoizedParser >> reset: aStream [
	stream := aStream.
	buffer := Array new: aStream size + 1
]
