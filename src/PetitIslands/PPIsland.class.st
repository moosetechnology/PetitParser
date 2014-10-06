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
		'beforeWaterDelegate'
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
		afterWaterDelegate setParser: afterWaterParser.
	].
	^ afterWaterDelegate
]

{ #category : #parsing }
PPIsland >> beforeWaterParser: aPPContext [
	context == aPPContext ifFalse: [ self reset: aPPContext ].

	beforeWaterParser ifNil: [
		beforeWaterParser := self createBeforeWaterParser: aPPContext.
		beforeWaterDelegate setParser: beforeWaterParser.
	].
	^ beforeWaterDelegate
]

{ #category : #accessing }
PPIsland >> children [
	"
		the delegates are for nicer view in debugger. Because before/after water parsers
		are created on-demand during parsing, we hide them behind the delegate, that
		is created before parsing.
	"
	^ Array with: beforeWaterDelegate with: island with: afterWaterDelegate
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
PPIsland >> createBeforeWaterParser: aPPContext [
	| nextSet p |
	nextSet := Set new.
	nextSet addAll: (self nextSet: aPPContext).
	nextSet add: PPInputEnds new.
	
	nextSet := nextSet collect: [:e | PPNonEmptyParser on: e].
	
	p := (PPChoiceParser withAll: nextSet) not, (PPNonEmptyParser on: island) not.
	^ PPWater on: p.
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
	beforeWaterDelegate := PPDelegateParser on: nil asParser.
	beforeWaterDelegate disableDebuggerOutput.
	afterWaterDelegate := PPDelegateParser on: nil asParser.
	afterWaterDelegate disableDebuggerOutput.
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
		retval := PPFailure message: 'IMO should not happen :(' context: aPPContext.
		aPPContext restore: memento.
		^ retval.
	].

	retval := OrderedCollection with: bwr with: result with: awr.
	^ retval



]

{ #category : #accessing }
PPIsland >> replace: parser with: anotherParser [ 
	super replace: parser with: anotherParser.
	
	(beforeWaterDelegate == parser) ifTrue: [ beforeWaterDelegate := anotherParser ].
	(afterWaterDelegate == parser) ifTrue: [ afterWaterDelegate := anotherParser ].
	
	(island == parser) ifTrue: [ island := anotherParser ].
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