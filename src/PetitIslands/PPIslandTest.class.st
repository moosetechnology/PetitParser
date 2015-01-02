Class {
	#name : #PPIslandTest,
	#superclass : #PPAbstractParserTest,
	#instVars : [
		'result',
		'context'
	],
	#category : #'PetitIslands-Tests'
}

{ #category : #parsing }
PPIslandTest >> assert: parser parse: input [
	result := super assert: parser parse: input
]

{ #category : #'as yet unclassified' }
PPIslandTest >> context [
	context ifNil: [ ^ super context ].
	^ context
]

{ #category : #'parse support' }
PPIslandTest >> identifier [ 
 	^ ((#letter asParser / $# asParser), (#letter asParser / #digit asParser) star) flatten 
]

{ #category : #'parse support' }
PPIslandTest >> island: parser [
	^ self islandInstance island: parser.
]

{ #category : #'parse support' }
PPIslandTest >> island: parser water: water [
	^ self islandInstance 
		island: parser;
		water: water;
		yourself
	
]

{ #category : #'parse support' }
PPIslandTest >> islandClass [ 
	^ PPIsland  
]

{ #category : #'parse support' }
PPIslandTest >> islandInstance [
	^ self islandClass new 
]

{ #category : #'tests - water objects' }
PPIslandTest >> multilineCommentParser [
	^ '/*' asParser, (#any asParser starLazy: '*/' asParser), '*/' asParser.
]

{ #category : #'parse support' }
PPIslandTest >> nestedBlock [
	| blockIsland block nilIsland |
	blockIsland := self islandInstance.
	nilIsland := self nilIsland.
	
	block := PPDelegateParser new.
	block setParser: (${ asParser,  (blockIsland plus / nilIsland), $} asParser).
	block name: 'block'.
	
	blockIsland island: block.
	blockIsland name: 'block island'.
	^ block
]

{ #category : #'parse support' }
PPIslandTest >> nilIsland [
	|  nilIsland |
	nilIsland := self islandInstance.
	
	nilIsland island: nil asParser.
	nilIsland name: 'nil island'.
	
	^ nilIsland
]

{ #category : #'as yet unclassified' }
PPIslandTest >> setUp [
	super setUp.
	context := nil
]

{ #category : #'tests - water objects' }
PPIslandTest >> singleCommentParser [
	| nl |
	nl := #newline asParser.
	^ '//' asParser, (#any asParser starLazy: nl), nl.
]

{ #category : #testing }
PPIslandTest >> testBlock [
	| block  |

	block := self nestedBlock.
	
	self assert: block parse: '{}'.
	self assert: result size = 3.
	self assert: result first = ${.
	self assert: result third = $}.
	
	self assert: block parse: '{ }'.
	self assert: result size = 3.
	self assert: result first = ${.
	self assert: result third = $}.	
		
	self assert: block parse: '{ { } }'.
	self assert: result size = 3.
	self assert: result first = ${.
	self assert: result third = $}.	
		
		
	self assert: block parse: '{ { {{} } } }'.
	self assert: result isCollection.
	self assert: result  size = 3.
	self assert: result  first = ${.
	self assert: result  second first second first = ${.
	self assert: result  second first second second first second first = ${.
	self assert: result  second first second second first second third = $}.
	self assert: result  second first second third = $}.	
	self assert: result  third = $}.
	
	
	self assert: block parse: '{ { 
		{{} } 
	} }'.
	self assert: result isCollection.
	self assert: result  size = 3.
	self assert: result  first = ${.
	self assert: result  second first second first = ${.
	self assert: result  second first second second first second first = ${.
	self assert: result  second first second second first second third = $}.
	self assert: result  second first second third = $}.	
	self assert: result  third = $}.				
]

{ #category : #testing }
PPIslandTest >> testBlock2 [
	| parser block  |

	block := self nestedBlock.
	parser := (self island: 'a' asParser), block.
	
	self assert: parser parse: '..a..{}'.	
	self assert: result second second second = nil.
	
	self assert: parser parse: '..a..{ {} }'.
	self assert: result second second size = 1.
	
	self assert: parser parse: '..a..{ {} {} }'.
	self assert: result second second size = 2.

	self assert: parser parse: '..a..{ {}'.
	self assert: result second second second = nil.	
]

{ #category : #testing }
PPIslandTest >> testBlock3 [
	| parser block  |

	block := self nestedBlock.
	parser := block trim plus.
	
	self assert: parser parse: ' {} {} '.	
	self assert: result size = 2.
	
	self assert: parser parse: '{ {} } {}'.
	self assert: result size = 2.
		
	self assert: parser parse: '{{{}}{}} {{}} {{}} '.
	self assert: result size = 3.

]

{ #category : #testing }
PPIslandTest >> testInputEnds [
	| parser |
	parser := PPInputEnds new.
	self assert: parser parse: ''.
	
	parser := 'a' asParser, PPInputEnds new.
	self assert: parser parse: 'a'.
	self assert: parser fail: ''.
	self assert: parser fail: 'aa'.
]

{ #category : #testing }
PPIslandTest >> testIsland [
	
	| island    |
	
	island := self island: 'a' asParser.
	
	self assert: island parse: '...a...'.
	self assert: result size = 3.
	self assert: result first = #water.
	self assert: result third = #water.
]

{ #category : #testing }
PPIslandTest >> testIsland2 [
	
	| a b parser |
	
	a := self island: 'a' asParser.
	b := 'b' asParser trimBlanks, 'c' asParser trimBlanks.
	parser := a, b wrapped.
	
	self assert: parser parse: '...a..b..b c '.
	self assert: result size = 2.
	self assert: result first size = 3.
	self assert: result first second = 'a'.
	self assert: result second first = 'b'.
	self assert: result second second = 'c'.

]

{ #category : #testing }
PPIslandTest >> testIsland3 [
	
	| a b parser |
	
	a := self island: 'a' asParser.
	b := 'b' asParser trimBlanks optional.
	parser := a, b wrapped.
	
	self assert: parser parse: '...a..b'.
	self assert: result size = 2.
	self assert: result first size = 3.
	self assert: result first second = 'a'.
	self assert: result second = 'b'.


	self assert: parser parse: '...a...'.
	self assert: result size = 2.
	self assert: result first size = 3.
	self assert: result first second = 'a'.
	self assert: result second = nil.

]

{ #category : #testing }
PPIslandTest >> testIslandDetection [
	| island parser |
	island := 'class' asParser, self identifier trim, 'endclass' asParser.
	parser := self island: island.
	
	self assert: parser parse: 'class Foo endclass'.
	self assert: result size = 3.
	self assert: result second second = 'Foo'.

	self assert: parser parse: '/*comment*/ class Foo endclass'.
	self assert: result size = 3.
	self assert: result second second = 'Foo'.

	self assert: parser parse: '/*comment class Bar */ class Foo endclass'.
	self assert: result size = 3.
	self assert: result second second = 'Foo'.

	self assert: parser parse: '/*comment class Bar */ class Foo endclass //something more'.
	self assert: result size = 3.
	self assert: result second second = 'Foo'.

	self assert: parser parse: '/*comment class Bar endclass */ class Foo endclass //something more'.
	self assert: result size = 3.
	self assert: result second second = 'Bar'.

]

{ #category : #testing }
PPIslandTest >> testIslandPlus [
	
	| island  parser |
	island := self island: 'a' asParser.
	parser := island plus.
	
	self assert: parser parse: '..a..'.
	self assert: result size = 1.

	self assert: parser parse: '..a..a..aa'.
	self assert: result size = 4.

	self assert: parser fail: '..'.
]

{ #category : #testing }
PPIslandTest >> testIslandPlus2 [
	
	| island  parser |
	island := self island: ('class' asParser, self identifier trim).
	parser := island plus.
	
	self assert: parser parse: '....class Foo....'.
	self assert: result size = 1.
	self assert: result first second second = 'Foo'.


	self assert: parser parse: '....class . class Foo....'.
	self assert: result size = 1.
	self assert: result first second second = 'Foo'.

	self assert: parser parse: '....class . class Foo class Bar....'.
	self assert: result size = 2.
	self assert: result first second second = 'Foo'.
	self assert: result second second second = 'Bar'.



	self assert: parser fail: '.....'.
]

{ #category : #testing }
PPIslandTest >> testIslandSequence [
	
	|  parser   a b c |
	"Island sequence will never cross the boundery of 'c'"
	a := 'a' asParser.
	b := 'b' asParser.
	c := 'c' asParser.
	
	parser := ((self island: a), (self island: b)) wrapped, c.
	
	self assert: parser parse: '..a...b...c'.
	self assert: parser fail: '..a..c...b..c'.
	self assert: parser fail: '..c..a.....b..c'.
]

{ #category : #testing }
PPIslandTest >> testIslandSequence2 [
	| p a b |
	
	a := self island: ('a' asParser plus).
	a name: 'a island'.
	
	b := self island: 'b' asParser.
	b name: 'b island'.
	
	p := a optional, (b / self nilIsland).
	self assert: p  parse: 'a'.
	self assert: result size = 2.
	self assert: result first notNil.
	self assert: result second size = 3.
	self assert: result second second = nil.
	
	self assert: p parse: '..ab'.
	
	self assert: result isPetitFailure not.
	self assert: result size = 2.
	self assert: result first notNil.
	self assert: result second size = 3.
	self assert: result second second = 'b'.
	
	self assert: p parse: 'a..b'.
	
	self assert: result isPetitFailure not.
	self assert: result size = 2.
	self assert: result first notNil.
	self assert: result second size = 3.
	self assert: result second second = 'b'.
	
	self assert: p parse: 'ab...'.
	
	self assert: result isPetitFailure not.
	self assert: result size = 2.
	self assert: result first notNil.
	self assert: result second size = 3.
	self assert: result second second = 'b'.
	
	self assert: p parse: '...a...b...'.
	
	self assert: result isPetitFailure not.
	self assert: result size = 2.
	self assert: result first notNil.
	self assert: result second size = 3.
	self assert: result second second = 'b'.
	
	self assert: p parse: '...a...b...'.
	
	self assert: result isPetitFailure not.
	self assert: result size = 2.
	self assert: result first notNil.
	self assert: result second size = 3.
	self assert: result second second = 'b'.
	
	self assert: p end parse: '...b...'.
	
	self assert: result isPetitFailure not.
	self assert: result size = 2.
	self assert: result first isNil.
	self assert: result second size = 3.
	self assert: result second second = 'b'.
]

{ #category : #testing }
PPIslandTest >> testIslandSequence3 [
	
	| parser   a b c |
	a := self island: 'a' asParser.
	b := self island: 'b' asParser.
	c := self island: 'c' asParser.

	parser := (a, b optional, c) plus.
	self assert: parser parse: '
	..a..c..
	..a..b..c..'.
	
	self assert: result isPetitFailure not.
	self assert: result size = 2. 
]

{ #category : #testing }
PPIslandTest >> testIslandSequence4 [
	
	| parser  a b |
	a := self island: 'a' asParser.
	b := self island: 'b' asParser.
	

	parser := a optional, b.
	self assert: parser parse: '...a...b'.
		
	self assert: result isPetitFailure not.
	self assert: result size = 2. 
	self assert: result first second = 'a'.
	self assert: result second second = 'b'.
	
	self assert: parser parse: '...b'.
		
	self assert: result isPetitFailure not.
	self assert: result size = 2. 
	self assert: result first = nil.
	self assert: result second second = 'b'.
]

{ #category : #testing }
PPIslandTest >> testIslandSequence5 [
	
	| parser  a b c|
	a := self island: 'a' asParser.
	b := self island: 'b' asParser.
	c := 'c' asParser.
	

	parser := a optional, b, c.
	self assert: parser parse: '...a...b..c'.
		
	self assert: result isPetitFailure not.
	self assert: result size = 3. 
	self assert: result first second = 'a'.
	self assert: result second second = 'b'.
	
	self assert: parser parse: '...b..c'.
		
	self assert: result isPetitFailure not.
	self assert: result size = 3. 
	self assert: result first = nil.
	self assert: result second second = 'b'.
]

{ #category : #testing }
PPIslandTest >> testIslandSequence6 [
	
	| parser  aba a |
	aba := self island: 'aba' asParser.
	a := 'a' asParser, #endOfLine asParser.
	

	parser := aba, aba optional, a.

	self assert: parser parse: '...aba...aba..a'.
	self assert: result isPetitFailure not.
	self assert: result size = 3. 
	self assert: result first second = 'aba'.
	self assert: result second second = 'aba'.
	self assert: result third = #('a' #endOfLine).


	self assert: parser parse: '...aba...a'.
		
	self assert: result isPetitFailure not.
	self assert: result size = 3. 
	self assert: result first second = 'aba'.
	self assert: result second = nil.
	self assert: result third = #('a' #endOfLine).
	

	self assert: parser parse: '...aba...aba'.
		
	self assert: result isPetitFailure not.
	self assert: result size = 3. 
	self assert: result first second = 'aba'.
	self assert: result second = nil.
	self assert: result third =  #('a' #endOfLine)..

]

{ #category : #testing }
PPIslandTest >> testIslandSequence7 [
	
	| parser a b c|
	b := PPDelegateParser new.
	
	a := (self island: 'a' asParser, b).
	b setParser: (self island: 'b' asParser).
	c := 'c' asParser, #endOfLine asParser.
	

	parser := a, c.

	self assert: parser parse: 'abc'.
	self assert: result isPetitFailure not.
	self assert: result size = 2. 
	self assert: result first second first = 'a'.
	self assert: result first second second second = 'b'.
	self assert: result second = #('c' #endOfLine).
]

{ #category : #testing }
PPIslandTest >> testIslandSequence8 [
	
	| parser a b c |
	a := self island: 'a' asParser.
	b := self island: 'b' asParser.
	c := self island: 'c' asParser.
	
	parser := a, b, c.

	self assert: parser parse: '..a..b..c'.
	self assert: result size = 3. 
	self assert: result first second = 'a'.
	self assert: result second second = 'b'.
	self assert: result third second = 'c'.	
]

{ #category : #testing }
PPIslandTest >> testIslandSequence9 [
	
	| parser a b  |
	a := self island: 'a' asParser.
	b := '{' asParser, (self island: 'b' asParser), '}' asParser.
	
	parser := a, b.

	self assert: parser parse: '..a..{..b..}'.
	self assert: result size = 2. 
	self assert: result first second = 'a'.
	self assert: result second second second = 'b'.
]

{ #category : #testing }
PPIslandTest >> testIslandSequencePlus [
	
	| parser ab c |
	ab := self island: ('a' asParser, 'b' asParser).
	c := self island: 'c' asParser.
	
	parser := (ab, c) plus.
	 
	result := parser parse: '..ab..c..'.
	self assert: result isPetitFailure not.

]

{ #category : #testing }
PPIslandTest >> testIslandSequencePlus2 [
	
	| parser ab c |
	ab := self island: ('a' asParser, 'b' asParser).
	c := self island: 'c' asParser.
	
	parser := (ab, c) plus.
	 
	result := parser parse: '..a..c..'.
	self assert: result isPetitFailure.

]

{ #category : #testing }
PPIslandTest >> testIslandSequencePlus3 [
	
	| parser ab c |
	ab := self island: ('a' asParser, 'b' asParser).
	c := self island: 'c' asParser.
	
	parser := (ab, c) plus.
	 
	self assert: parser parse: '..ab..c..ab..c'.
	self assert: result isPetitFailure not.
	self assert: result size = 2.

]

{ #category : #testing }
PPIslandTest >> testIslandStar [
	|  p  |
	
	
	p := (self island: 'a' asParser) star, 'b' asParser. 
	self assert: p parse: 'b'.
	self assert: result size = 2.
	self assert: result first size = 0.
	
	self assert: p parse: 'ab'.
	self assert: result size = 2.
	self assert: result first size = 1.
	
	self assert: p parse: 'aab'.
	self assert: result size = 2.
	self assert: result first size = 2.
	
	self assert: p parse: '...aab'.
	self assert: result size = 2.
	self assert: result first size = 2.
	
	self assert: p parse: '...aa...b'.
	self assert: result size = 2.
	self assert: result first size = 2.
	
	self assert: p parse: '...a...a...b'.
	self assert: result size = 2.
	self assert: result first size = 2.

	self assert: p parse: '...a...a...aa...b'.
	self assert: result size = 2.
	self assert: result first size = 4.
	
	"Thats the question, if I want this:"
	self assert: p fail: '...b'.

]

{ #category : #testing }
PPIslandTest >> testIslandStar2 [
	|  p  |
	
	
	p := (self island: 'a' asParser) star, 'b' asParser optional. 
	self assert: p parse: 'aa'.
	self assert: result size = 2.
	self assert: result first size = 2.
	
	self assert: p parse: '....aa'.
	self assert: result size = 2.
	self assert: result first size = 2.
	
	self assert: p parse: '...a...a...'.
	self assert: result size = 2.
	self assert: result first size = 2.
	
	self assert: p parse: '...a...a...b'.
	self assert: result size = 2.
	self assert: result first size = 2.
	self assert: result second = 'b'.
]

{ #category : #testing }
PPIslandTest >> testIslandStar3 [
	|  p  |
	
	
	p := (self island: 'a' asParser) star, (self island: nil asParser). 
	
	self assert: p parse: '....'.
	self assert: result size = 2.
	self assert: result first size = 0.
	
	self assert: p parse: 'aa'.
	self assert: result size = 2.
	self assert: result first size = 2.
	
	self assert: p parse: '....aa'.
	self assert: result size = 2.
	self assert: result first size = 2.
	
	self assert: p parse: '...a...a...'.
	self assert: result size = 2.
	self assert: result first size = 2.
	
	self assert: p parse: '...a...a...b'.
	self assert: result size = 2.
	self assert: result first size = 2.
	self assert: result second second = nil.
]

{ #category : #'tests - water objects' }
PPIslandTest >> testMultilineComment [
	|  parser |
	parser := self multilineCommentParser.
	
	self assert: parser parse: '/* hello there */'.
	self assert: parser parse: '/* class Bar endclass */'.

]

{ #category : #testing }
PPIslandTest >> testNestedIsland [
	
	|  nestedIsland before after topIsland |
	nestedIsland := self island: 'X' asParser.
	
	before := 'before' asParser.
	after := 'after' asParser.
	topIsland := self island: (before, nestedIsland, after).
	
	self assert: nestedIsland parse: 'before...X...ater'.
	self assert: topIsland parse: 'beforeXafter'.
	
	self assert: topIsland parse: '....before..X..after....'.
	self assert: result size = 3.
	self assert: result second size = 3.
	self assert: result second second size = 3.
	self assert: result second second second = 'X'.
	
	self assert: topIsland parse: '....X....before...X....after'.
	self assert: topIsland parse: '....before.......after....before..X...after'.

	self assert: topIsland fail: '....before.......after...'.	
	self assert: topIsland fail: '....before.......after...X'.	
	self assert: topIsland fail: '....before.......after...X...after'.		

]

{ #category : #testing }
PPIslandTest >> testNestedIsland2 [
	
	|  nestedIsland before after topIsland |
	nestedIsland := self island: 'after' asParser.
	
	before := 'before' asParser.
	after := 'after' asParser.
	topIsland := self island: (before, nestedIsland, after).
	
	self assert: nestedIsland parse: '..after..'.
	self assert: topIsland parse: 'before..after..after'.
	self assert: topIsland parse: '....before...after....after...'.
	self assert: topIsland fail: '....before...after...'.
	
	topIsland := self island: (before, (nestedIsland / (nil asParser island)), after).
	self assert: topIsland parse: '....before...after....after...'.
	self assert: topIsland parse: '..before...after..'.


]

{ #category : #testing }
PPIslandTest >> testNilIsland [
	
	| nilIsland  p |

	nilIsland := self nilIsland.
	

	p := ${ asParser, nilIsland, $} asParser.

	self assert: p parse: '{}'.
	
	self assert: result isCollection.
	self assert: result size = 3.
	self assert: result first = ${.
	self assert: result third = $}.	
	

	self assert: p parse: '{ }'.
	self assert: result isCollection.
	self assert: result size = 3.
	self assert: result first = ${.
	self assert: result third = $}.
	

	self assert: p parse: '{ ... }'.
	self assert: result isCollection.
	self assert: result size = 3.
	self assert: result first = ${.
	self assert: result third = $}.
]

{ #category : #testing }
PPIslandTest >> testOptionalIsland [
	
	| island parser   |
	
	island := self island: ('a' asParser / 'b' asParser optional).
	parser := island, 'c' asParser.
	
	self assert: parser parse: '....a....b...c'.
	self assert: result first second = 'a'.
	self assert: result second = 'c'.
	
	self assert: parser parse: '....d....b...c'.
	self assert: result first second = 'b'.
	self assert: result second = 'c'.
	
	self assert: parser parse: '....d....d...c'.
	self assert: result first second = nil.
	self assert: result second = 'c'.

	self assert: parser parse: '...c'.
]

{ #category : #testing }
PPIslandTest >> testOptionalIsland2 [
	|  p  |
	
	p := (self island: 'a' asParser) optional, 'a' asParser.
	
	self assert: p parse: 'a'.
	self assert: result size = 2.
	self assert: result first = nil.
	self assert: result second = 'a'.
	
	self assert: p parse: '..a..a'.
	self assert: result size = 2.
	self assert: result first second = 'a'.
	self assert: result second = 'a'.

]

{ #category : #testing }
PPIslandTest >> testOptionalIsland3 [
	|  p  |
	
	p := (self island: 'a' asParser), (self island: 'a' asParser) optional, 'a' asParser.
	
	self assert: p parse: 'aa'.
	self assert: result size = 3.
	self assert: result first second = 'a'.
	self assert: result second = nil.
	self assert: result third = 'a'.
	
	self assert: p parse: '..a..a'.
	self assert: result size = 3.
	self assert: result first second = 'a'.
	self assert: result second = nil.
	self assert: result third = 'a'.
	
	self assert: p parse: '..a..a..a'.
	self assert: result size = 3.
	self assert: result first second = 'a'.
	self assert: result second second = 'a'.
	self assert: result third = 'a'.
]

{ #category : #'tests - water objects' }
PPIslandTest >> testWaterObjects [
	| parser |
	context := PPContext new.
	parser := (self island: ('class' asParser, self identifier trim, 'endclass' asParser ==> #second)) star.

	self assert: parser parse: ' /* hello there */ class Foo endclass'.
	self assert: result size = 1.
	self assert: result first second = 'Foo'.
	
	context := PPContext new.
	self assert: parser parse: ' /* class Bar endclass */ class Foo endclass'.
	self assert: result size = 2.
	self assert: result first second = 'Bar'.
	self assert: result second second = 'Foo'.
	
	context := PPContext new.
	parser := (self island: ('class' asParser, self identifier trim, 'endclass' asParser ==> #second) water: self multilineCommentParser / #any asParser) star.

	self assert: parser parse: ' /* class Bar endclass */ class Foo endclass'.
	self assert: result size = 1.
	self assert: result first second = 'Foo'.
]

{ #category : #'tests - water objects' }
PPIslandTest >> testWaterObjects2 [
	| parser source |
	context := PPContext new.

	parser := (self island: ('class' asParser, self identifier trim, 'endclass' asParser ==> #second)
						 water: self multilineCommentParser / self singleCommentParser / #any asParser) 				star.
	
	source := ' /* class Bar endclass */ 
	class Foo 
	endclass
	/* 
	   class Borg
	   endclass
	*/
	// class Qwark endclass 
	class Zorg 
	endclass
	'.
	
	self assert: parser parse: source.
	self assert: result size = 2.
	self assert: result first second = 'Foo'.	
	self assert: result second second = 'Zorg'.	

]
