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
	self flag: 'HACK ???'.
	(beforeWaterParser isNotNil and: [afterWaterParser isNotNil]) ifTrue: [ 
		^ Array with: beforeWaterParser with: island with: afterWaterParser
	].
 	^ Array with: water with: island with: water

]

{ #category : #parsing }
PPIsland >> createAfterWaterParser: aPPContext [
	^ self createAfterWaterParserFromNextSet: (self nextSet: aPPContext).
]

{ #category : #parsing }
PPIsland >> createAfterWaterParserFromNextSet: nextSet [
	| set p |
	set := nextSet copy.
	set := self filterOutNextSet: set.
	(set anySatisfy: [ :e | e acceptsEpsilon  ]) ifTrue: [ set add: PPEndOfFileParser new ].
	
	set := set collect: [ :e | e nonEmpty ].
	set := set select: [ :e | e class ~= PPFailingParser ].
		
	p := (PPChoiceParser withAll: set) and.
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
	set := self filterOutNextSet: nextSet.
	(set anySatisfy: [ :e | e acceptsEpsilon ]) ifTrue: [ set add: PPEndOfFileParser new ].
	
	set add: island.

	set := set collect: [:e | e nonEmpty].
	set := set select: [ :e | e class ~= PPFailingParser ].
	
	p := (PPChoiceParser withAll: set) and.
	^ PPWater on: p waterToken: water.
]

{ #category : #analysis }
PPIsland >> createWaterForRoot: root [
	| nextSet |
	"
		Be careful, why you call this method.
		I guess this is usefull when only debugging island gramamrs
	"
	nextSet := root nextSets at: self.
	defaultBeforeWaterParser := beforeWaterParser := self createBeforeWaterParserFromNextSet: nextSet.
	defaultAfterWaterParser := afterWaterParser := self createAfterWaterParserFromNextSet: nextSet.
	

]

{ #category : #parsing }
PPIsland >> exampleOn: aStream [
	aStream nextPutAll: '~~~~ '.
	island exampleOn: aStream .
	aStream nextPutAll:  ' ~~~~'.
]

{ #category : #analysis }
PPIsland >> filterOutNextSet: nextSet [
	| newNextSet |
	newNextSet := nextSet.
	
	"This should remove the most patological cases of exponential complexity of islands"
"	newNextSet := newNextSet collect: [ :e | 
		((e isKindOf: PPIsland) and: [e island == island ]) 
			ifTrue: [ island ] 
			ifFalse: [ e ]].
	newNextSet := newNextSet collect: [ :e | 
		((e isKindOf: PPActionParser) and: [ (e child isKindOf: PPIsland)  and: [ e child island == island ]]) 			ifTrue: [ island ] 
			ifFalse: [ e ]].
"
	^ newNextSet
]

{ #category : #analysis }
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
	island := anObject "memoized"
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
	^ super name ifNil: [ 
		island name ifNil: ['unknown island'] ifNotNil: [ island name, ' island' ] ].
]

{ #category : #analysis }
PPIsland >> nextSet: aPPContext [
	^ aPPContext root nextSets at: self.
]

{ #category : #analysis }
PPIsland >> nextSets: aNextDictionary into: aSet [
	"return true/false, if something has changed or not...."
	| islandSet change tally |
	
	change := false.
	
	"
		I rewrite the super implementation in order not to avoid updates in the
		before/after water (that would be unfortunate...)
	"
	islandSet := aNextDictionary at: island.
	tally := islandSet size.
	islandSet addAll: aSet.
	change := tally ~= islandSet size.

	^ change
	
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
	
	aPPContext islandInvoke.
	
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
	
	(beforeWaterParser == parser) ifTrue: [ beforeWaterParser := anotherParser ].
	(afterWaterParser == parser) ifTrue: [ afterWaterParser := anotherParser ].
	(defaultBeforeWaterParser == parser) ifTrue: [ defaultBeforeWaterParser := anotherParser ].
	(defaultAfterWaterParser == parser) ifTrue: [ defaultAfterWaterParser := anotherParser ].
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
