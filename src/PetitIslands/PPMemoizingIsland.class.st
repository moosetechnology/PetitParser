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
		'rootParser',
		'memoizationDictionaries'
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

	memoizationDictionaries := IdentityDictionary new.

]

{ #category : #accessing }
PPMemoizingIsland >> island: anObject [

	island ifNil: [
		super island: anObject.
	] ifNotNil: [
		self error: 'JK: I do not want to do this' .
	] 
]

{ #category : #memoization }
PPMemoizingIsland >> memoizationDictionaryForContext: aPPContext [
	^ memoizationDictionaries at: aPPContext ifAbsentPut: [IdentityDictionary new].
]

{ #category : #memoization }
PPMemoizingIsland >> memoizeResult: result onContext: aPPContext position: pos [
	| memento |
	
	memento := PPMemento new.
	memento contextMemento: aPPContext remember.
	memento result: result.
	
	(self memoizationDictionaryForContext: aPPContext) at: pos put: memento.

]

{ #category : #parsing }
PPMemoizingIsland >> memoized [
	"We have our own implementation of memoization"
	^ self
]

{ #category : #memoization }
PPMemoizingIsland >> memoizedResult: aPPContext [
	^ (self memoizationDictionaryForContext: aPPContext) at: (aPPContext position) ifAbsent: [ nil ].
	
]

{ #category : #parsing }
PPMemoizingIsland >> nonMemoized [ 
	^ PPIsland new
		island: self island;
		yourself
]

{ #category : #parsing }
PPMemoizingIsland >> parseOn: aPPContext [ 
	|  memoizedResult parsingPosition retval |
	memoizedResult := self memoizedResult: aPPContext.
	memoizedResult ifNotNil: [ 
		aPPContext restore: memoizedResult contextMemento.
		^ memoizedResult result 
	].
	parsingPosition := aPPContext position.
	
	retval := super parseOn: aPPContext.

	(aPPContext waterPosition == aPPContext position) ifFalse: [ 
		self memoizeResult: retval onContext: aPPContext position: parsingPosition.
	].

	^ retval.


]
