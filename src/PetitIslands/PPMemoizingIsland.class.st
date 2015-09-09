"
A PPMemoizingIsland is memoized version of PPIsland. Use this one, unless you don't mind really bad performance. If the memoized version is not working flawlessly, its a bug!

Please see help of the PPIsland for how to use...

Instance Variables
	memoizationDictionaries:		<Object>
	rootParser:		<Object>

memoizationDictionaries
	- memoization cache

rootParser
	- used for memoizing, once the root changes, flushes the caches

"
Class {
	#name : #PPMemoizingIsland,
	#superclass : #PPIsland,
	#instVars : [
		'dictionary'
	],
	#category : #'PetitIslands-Parsers'
}

{ #category : #'as yet unclassified' }
PPMemoizingIsland class >> initialize [ 
	super initialize 

]

{ #category : #initialization }
PPMemoizingIsland >> initialize [ 
	super initialize.

]

{ #category : #memoization }
PPMemoizingIsland >> memoizeResult: result onContext: aPPContext memento: ctxMemento [
	| memento |
	
	memento := PPMemento new.
	memento contextMemento: aPPContext remember.
	memento result: result.
	
	dictionary at: ctxMemento put: memento.

]

{ #category : #parsing }
PPMemoizingIsland >> memoized [
	"We have our own implementation of memoization"
	^ self
]

{ #category : #memoization }
PPMemoizingIsland >> memoizedResult: aPPContext [
	^ dictionary at: (aPPContext remember) ifAbsent: [ nil ].
	
]

{ #category : #parsing }
PPMemoizingIsland >> nonMemoized [ 
	^ PPIsland new
		island: self island;
		yourself
]

{ #category : #parsing }
PPMemoizingIsland >> parseOn: aPPContext [ 
	|  memoizedResult retval memento |
	self check: aPPContext.
	
	memoizedResult := self memoizedResult: aPPContext.
	memoizedResult ifNotNil: [ 
		aPPContext restore: memoizedResult contextMemento.
		^ memoizedResult result 
	].
	memento := aPPContext remember.
	
	retval := super parseOn: aPPContext.

	(aPPContext waterPosition == aPPContext position) ifFalse: [ 
		self memoizeResult: retval onContext: aPPContext memento: memento.
	].

	^ retval.


]

{ #category : #parsing }
PPMemoizingIsland >> reset: aPPContext [
	super reset: aPPContext.
	dictionary := Dictionary new.
]
