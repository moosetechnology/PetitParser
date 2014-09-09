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
		'buffer',
		'context',
		'hash'
	],
	#category : #'PetitParser-Parsers'
}

{ #category : #operators }
PPMemoizedParser >> memoized [
	"Ther is no point in memoizing more than once."

	^ self
]

{ #category : #parsing }
PPMemoizedParser >> parseOn: aPPContext [
	| memento contextMemento  aStream |
	"TODO: JK memoizing needs review!"
	
	contextMemento := aPPContext remember.
	(hash == aPPContext hash)
		ifFalse: [ self reset: aPPContext ].
	memento := (buffer at: contextMemento ifAbsentPut: [ PPMemento new ]).
	
	memento contextMemento isNil
		ifTrue: [
			aStream := aPPContext stream.
			memento result: (aStream size - aStream position + 2 < memento count
				ifTrue: [ PPFailure message: 'overflow' context: aPPContext ]
				ifFalse: [ memento increment. parser parseOn: aPPContext ]).
			memento contextMemento: aPPContext remember ]
		ifFalse: [ context restore: memento contextMemento ].
	^ memento result.
]

{ #category : #parsing }
PPMemoizedParser >> reset: aPPContext [
	hash := aPPContext hash.
	context := aPPContext.
	buffer := Dictionary new.
]
