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
		'bwp',
		'awp'
	],
	#category : #'PetitIslands-Parsers'
}

{ #category : #queries }
PPIsland >> acceptsEpsilon [
	"Let us suppose island is always nullable, it helps to sequences of islands"
	^ true
	"^ island isNullableOpenSet: (IdentitySet with: self)"
]

{ #category : #queries }
PPIsland >> acceptsEpsilonOpenSet: set [
	^ true
"	^ island isNullableOpenSet: set"
]

{ #category : #parsing }
PPIsland >> afterWaterParser: aPPContext [
	context == aPPContext ifFalse: [ self reset: aPPContext ].

	afterWaterParser ifNil: [
		afterWaterParser := self createAfterWaterParser: aPPContext.
		awp setParser: afterWaterParser.
	].
	^ awp
]

{ #category : #parsing }
PPIsland >> beforeWaterParser: aPPContext [
	context == aPPContext ifFalse: [ self reset: aPPContext ].

	beforeWaterParser ifNil: [
		beforeWaterParser := self createBeforeWaterParser: aPPContext.
		bwp setParser: beforeWaterParser.
	].
	^ bwp
]

{ #category : #accessing }
PPIsland >> children [
	"
		this all thing with bwp, awp and children
		is a bit hack for debugging purposes
	"
	^ Array with: bwp with: island with: awp
]

{ #category : #parsing }
PPIsland >> createAfterWaterParser: aPPContext [
	|  nextSet  p |
	
	nextSet := Set new.
	nextSet addAll: (self nextSet: aPPContext).
	nextSet add: PPInputEnds new.
	
	nextSet := nextSet collect: [ :e | PPNonEmptyParser on: e ].
	
	p := (PPChoiceParser withAll: nextSet) not.
	^ PPWater on: p
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
	bwp := PPDelegateParser on: nil asParser.
	bwp disableDebuggerOutput.
	awp := PPDelegateParser on: nil asParser.
	awp disableDebuggerOutput.
]

{ #category : #accessing }
PPIsland >> island [

	^ island
]

{ #category : #accessing }
PPIsland >> island: anObject [
	island := anObject.
"	anObject parent: self."
]

{ #category : #memoization }
PPIsland >> memoized [ 
	^ PPMemoizingIsland new
		island: self island;
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
	| awr  |

	awr := (self afterWaterParser: aPPContext) parseOn: aPPContext .
	
	^ awr
]

{ #category : #parsing }
PPIsland >> parseBeforeWater: aPPContext [
	| bwr    |

	bwr := (self beforeWaterParser: aPPContext) parseOn: aPPContext.
	
	^ bwr

]

{ #category : #parsing }
PPIsland >> parseOn: aPPContext [ 
	|  bwr awr result retval memento |

	memento := aPPContext remember.
	"Halt ifShiftPressed."
	
	bwr := self parseBeforeWater: aPPContext.
	bwr isPetitFailure ifTrue: 
	[
		self error: 'IMO should never happen'.
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
		retval := PPFailure message: 'island found, but follow not :(' at: aPPContext position.
		aPPContext restore: memento.
		^ retval.
	].

	retval := OrderedCollection with: bwr with: result with: awr.
	^ retval



]

{ #category : #accessing }
PPIsland >> replace: parser with: anotherParser [ 
	super replace: parser with: anotherParser.
	
	(bwp == parser) ifTrue: [ bwp := anotherParser ].
	(awp == parser) ifTrue: [ awp := anotherParser ].
	
	(island == parser) ifTrue: [
		island := anotherParser.
	].
]

{ #category : #memoization }
PPIsland >> reset: aPPContext [
	context := aPPContext.
	beforeWaterParser := nil.
	afterWaterParser := nil.
]

{ #category : #parsing }
PPIsland >> waterToken [
	| waterObjects |
	waterObjects := self globalAt: #waterObjects ifAbsent: [ OrderedCollection new ].
	waterObjects add: #any asParser.
	^ PPChoiceParser withAll: waterObjects.
]
