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
		'water',
		'defaultBeforeWaterParser',
		'defaultAfterWaterParser',
		'contextIdentifier'
	],
	#category : #'PetitIslands-Parsers'
}

{ #category : #queries }
PPIsland >> acceptsEpsilon [
	^ island acceptsEpsilon
]

{ #category : #queries }
PPIsland >> acceptsEpsilonOpenSet: set [
	^ island acceptsEpsilonOpenSet: set
]

{ #category : #parsing }
PPIsland >> afterWaterParser: aPPContext [
	self check: aPPContext.

	afterWaterParser ifNil: [
		afterWaterParser := self createAfterWaterParser: aPPContext.
	].
	^ afterWaterParser

]

{ #category : #parsing }
PPIsland >> beforeWaterParser: aPPContext [
	self check: aPPContext.

	beforeWaterParser ifNil: [
		beforeWaterParser := self createBeforeWaterParser: aPPContext.
	].
	^ beforeWaterParser

]

{ #category : #parsing }
PPIsland >> check: aPPContext [
	(contextIdentifier == aPPContext identifier) ifFalse: [ self reset: aPPContext ].
]

{ #category : #accessing }
PPIsland >> children [

	^ Array with: water with: island with: water

]

{ #category : #parsing }
PPIsland >> createAfterWaterParser: aPPContext [
	^ self createAfterWaterParserFromNextSet: (self nextSet: aPPContext).
]

{ #category : #parsing }
PPIsland >> createAfterWaterParserFromNextSet: aNextSet [
	| nextSet p |
	nextSet := aNextSet copy.
	(nextSet anySatisfy: [ :e | e acceptsEpsilon  ]) ifTrue: [ nextSet add: PPEndOfFileParser new ].
	
	nextSet := nextSet collect: [ :e | e nonEmpty ].
	nextSet := nextSet select: [ :e | e class ~= PPFailingParser ].
		
	p := (PPChoiceParser withAll: nextSet) and.
	^ PPWater on: p waterToken: water
]

{ #category : #parsing }
PPIsland >> createBeforeWaterParser: aPPContext [
	^ self createBeforeWaterParserFromNextSet: (self nextSet: aPPContext).
	
]

{ #category : #parsing }
PPIsland >> createBeforeWaterParserFromNextSet: nextSet [
	| set p |
	set := nextSet copy.
	(set anySatisfy: [ :e | e acceptsEpsilon ]) ifTrue: [ set add: PPEndOfFileParser new ].
	
	set := set collect: [:e | e nonEmpty].
	set := set select: [ :e | e class ~= PPFailingParser ].
	
	p := ((PPChoiceParser withAll: set) / (island nonEmpty)) and.
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

{ #category : #queries }
PPIsland >> isIslandBorder [
	^ false
]

{ #category : #queries }
PPIsland >> isIslandBorderOpenSet: set [
	^ false
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
PPIsland >> parseIslandOn: aPPContext [ 
	|  result |

	"Do not allow empty parses, when searching for the island..."
	(aPPContext waterPosition == aPPContext position) ifTrue:[
		result := island nonEmpty parseOn: aPPContext.
	"But allow when boundary found"
	] ifFalse: [
		| tmp |
		"
			Oh, the thing is, if island starts with island parser B, 
			which is nested in another parser A, where B is bounded
			by something else than A. Then the B is not allowed to 
			skip over the boundary of A, but B has different boundary!
			
			Thus I disallow before water of any island parser that starts island
			by setting the water position!
		"
		tmp := aPPContext waterPosition.
		aPPContext waterPosition: aPPContext position.
		result := island parseOn: aPPContext.
		aPPContext waterPosition: tmp.
	].

	^ result

]

{ #category : #parsing }
PPIsland >> parseOn: aPPContext [ 
	|  bwr awr result retval memento |

	memento := aPPContext remember.
	bwr := self parseBeforeWater: aPPContext.
	bwr isPetitFailure ifTrue: 
	[
		retval := PPFailure message: 'Could not find neither the island nor the next' context: aPPContext.
		aPPContext restore: memento.
		^ retval.
	].

	result := self parseIslandOn: aPPContext.

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
	contextIdentifier := aPPContext identifier.
	beforeWaterParser := defaultBeforeWaterParser.
	afterWaterParser := defaultAfterWaterParser.
]

{ #category : #'accessing - private' }
PPIsland >> setAfterWaterParser: parser [
	defaultAfterWaterParser := parser
]

{ #category : #'accessing - private' }
PPIsland >> setBeforeWaterParser: parser [
	defaultBeforeWaterParser  := parser
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
