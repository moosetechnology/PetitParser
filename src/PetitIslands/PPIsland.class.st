"
A PPIsland allows for imprecise parsing. One can create it on a parser p by calling: 'p island' E.g.:

p := x, a island, y              accepts following inputs:
x.....a.....b 
xab

yet fails on:
x....a....c
xb
xac
x..b....a....b

The input represented by dots is called water and water can appear before and after the island. Use it, if you don't want to define all the grammar rules and you want to skip something.

I am still an experiment, but if you know how to improve me, please contact Jan Kurs at: kurs@iam.unibe.ch

Instance Variables
	afterWaterParser:		<Object>
	awp:		<Object>
	beforeWaterParser:		<Object>
	bwp:		<Object>
	context:		<Object>
	island:		<Object>

afterWaterParser
	- xxxxx

awp
	- xxxxx

beforeWaterParser
	- xxxxx

bwp
	- xxxxx

context
	- xxxxx

island
	- xxxxx

"
Class {
	#name : #PPIsland,
	#superclass : #PPParser,
	#instVars : [
		'island',
		'afterWaterParser',
		'beforeWaterParser',
		'context',
		'afterWaterDelegate',
		'beforeWaterDelegate',
		'water'
	],
	#category : #'PetitIslands-Parsers'
}

{ #category : #queries }
PPIsland >> acceptsEpsilon [
	"JK: Hack alert?"
	"Let us suppose island is always nullable, it helps to sequences of islands"
	^ true
	"^ island isNullableOpenSet: (IdentitySet with: self)"
]

{ #category : #queries }
PPIsland >> acceptsEpsilonOpenSet: set [
	"JK: Hack alert?"
	^ true
"	^ island isNullableOpenSet: set"
]

{ #category : #parsing }
PPIsland >> afterWaterParser: aPPContext [
	context == aPPContext ifFalse: [ self reset: aPPContext ].

	afterWaterParser ifNil: [
		afterWaterParser := self createAfterWaterParser: aPPContext.
	].
	^ afterWaterParser

]

{ #category : #parsing }
PPIsland >> beforeWaterParser: aPPContext [
	context == aPPContext ifFalse: [ self reset: aPPContext ].

	beforeWaterParser ifNil: [
		beforeWaterParser := self createBeforeWaterParser: aPPContext.
	].
	^ beforeWaterParser

]

{ #category : #accessing }
PPIsland >> children [

	^ Array with: water with: island with: water

]

{ #category : #parsing }
PPIsland >> createAfterWaterParser: aPPContext [
	|  nextSet  p |

	nextSet := Set new.
	nextSet addAll: (self nextSet: aPPContext).
	(nextSet anySatisfy: [ :e | e acceptsEpsilon  ]) ifTrue: [ nextSet add: PPInputEnds new ].
	
	nextSet := nextSet collect: [ :e | PPNonEmptyParser on: e ].
	
	p := (PPChoiceParser withAll: nextSet) and.
	^ PPWater on: p waterToken: water
]

{ #category : #parsing }
PPIsland >> createBeforeWaterParser: aPPContext [
	| nextSet p |
	nextSet := Set new.
	nextSet addAll: (self nextSet: aPPContext).
	
	nextSet := nextSet collect: [:e | PPNonEmptyParser on: e].
	
	p := ((PPChoiceParser withAll: nextSet) / (PPNonEmptyParser on: island)) and.
	^ PPWater on: p waterToken: water.
]

{ #category : #parsing }
PPIsland >> exampleOn: aStream [
	aStream nextPutAll: '~~~~ '.
	island exampleOn: aStream .
	aStream nextPutAll:  ' ~~~~'.
]

{ #category : #accessing }
PPIsland >> followSet: aPPContext [

	^ aPPContext root followSets at: self.	
]

{ #category : #accessing }
PPIsland >> initialize [ 
	super initialize.
	water := #any asParser name: 'water'; yourself.

]

{ #category : #accessing }
PPIsland >> island [

	^ island
]

{ #category : #accessing }
PPIsland >> island: anObject [
	island := anObject.
]

{ #category : #memoization }
PPIsland >> memoized [ 
	^ PPMemoizingIsland new
		island: self island;
		water: water;
		yourself
]

{ #category : #queries }
PPIsland >> name [
	^ super name ifNil: [ 'an island '].
]

{ #category : #accessing }
PPIsland >> nextSet: aPPContext [

	^ aPPContext root nextSets at: self.
]

{ #category : #parsing }
PPIsland >> parseAfterWater: aPPContext [
	^ (self afterWaterParser: aPPContext) parseOn: aPPContext .
]

{ #category : #parsing }
PPIsland >> parseBeforeWater: aPPContext [
	^ (self beforeWaterParser: aPPContext) parseOn: aPPContext.
]

{ #category : #parsing }
PPIsland >> parseOn: aPPContext [ 
	|  bwr awr result retval memento |

	memento := aPPContext remember.
	Halt ifShiftPressed.
	Halt if: [ island name = #primary ].
	
	
	bwr := self parseBeforeWater: aPPContext.
	bwr isPetitFailure ifTrue: 
	[
		retval := PPFailure message: 'Could not find neither the island nor the next' context: aPPContext.
		aPPContext restore: memento.
		^ retval.
	].

	"JK: HACK ALERT, FIX!"
	(aPPContext waterPosition == aPPContext position) ifTrue:[
		result := (PPNonEmptyParser on: island) parseOn: aPPContext.
	] ifFalse: [
		result := island parseOn: aPPContext.
	].
	

	result isPetitFailure ifTrue: [ 
		retval := PPFailure message: 'Island not found between ', memento position asString, ' and ', aPPContext position asString context: aPPContext.
		aPPContext restore: memento.
		^ retval
	].


	awr := self parseAfterWater: aPPContext.	
	awr isPetitFailure ifTrue: 
	[
		retval := PPFailure message: 'Could not find the next' context: aPPContext.
		aPPContext restore: memento.
		^ retval.
	].

	retval := OrderedCollection with: bwr with: result with: awr.
	^ retval



]

{ #category : #accessing }
PPIsland >> replace: parser with: anotherParser [ 
	super replace: parser with: anotherParser.
	
	(water == parser) ifTrue: [ water := anotherParser ].
	(island == parser) ifTrue: [ island := anotherParser ].
]

{ #category : #memoization }
PPIsland >> reset: aPPContext [
	context := aPPContext.
	beforeWaterParser := nil.
	afterWaterParser := nil.
]

{ #category : #accessing }
PPIsland >> water [
	^ water
]

{ #category : #accessing }
PPIsland >> water: aPPParser [
	water := aPPParser
]

{ #category : #parsing }
PPIsland >> waterToken [
	| waterObjects |
	self halt: 'deprecated?'.
	waterObjects := self globalAt: #waterObjects ifAbsent: [ OrderedCollection new ].
	waterObjects add: #any asParser.
	^ PPChoiceParser withAll: waterObjects.
]
