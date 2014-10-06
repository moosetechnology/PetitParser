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
PPIslandTest >> testBoundary [
	|  p end body start |
	
	"use non-trivial end-of-class a complex end"
	end := 'end' asParser trimBlanks, 'of' asParser trimBlanks, 'class' asParser trimBlanks ==> [:args | #eoc].
	body := self nilIsland.
	start := 'class' asParser trim, self identifier.
	p := start, body, end.
	
	self assert: p parse: 'class Foo end of class'.
	self assert: result size = 4.
	self assert: result second = 'Foo'.
	
	self assert: p parse: 'class Foo .... end of class'.
	self assert: result size = 4.
	self assert: result second = 'Foo'.
	
	self assert: p parse: 'class Foo .... end ... end of class'.
	self assert: result size = 4.
	self assert: result second = 'Foo'.
	
	self assert: p parse: 'class Foo .... end of ... end of class'.
	self assert: result size = 4.
	self assert: result second = 'Foo'.

]

{ #category : #testing }
PPIslandTest >> testBoundary2 [
	
	|   epilog  id p |
	"use optional boundary"
	epilog := 'end' asParser optional.
	id := self identifier.
	p := ((self island: id), epilog) plus.

	self assert: p parse: '...foo..end...bar...end'.	
	
	self assert: result first first second = 'foo'.
	self assert: result first second = 'end'.

	self assert: result second first second = 'bar'.
	self assert: result second second = 'end'.
]

{ #category : #'tests - complex' }
PPIslandTest >> testClass [
	| text   file class |
	text := '
// some comment
namespace cde {

public class Foo 
endclass

public class 123 // invalid class
public struct {}

class bar endclass
class Zorg endclass
}	
	'.
	
	class := ('public' asParser trim optional, 'class' asParser trim, self identifier,  'endclass' asParser trim) 
		==> [:t | t third] .
	file := ((self island: class) ==> [:t | t second ]) plus.	
	
	result := file parse: text.
	self assert: result size = 3.
	self assert: result first = 'Foo'.
	self assert: result second = 'bar'.
	self assert: result third = 'Zorg'.

]

{ #category : #'tests - complex' }
PPIslandTest >> testFile [
	| text using imports class file |
	text := '
	
using a.b.c;
using c.d.e;
// some comment
namespace cde {

public class Foo 
endclass

public class 123 // invalid class
public struct {}

class bar endclass
}	
	'.
	
	using := 'using' asParser trim, (self identifier, ('.' asParser, self identifier) star) flatten ==> [:t | t second].
	
	imports := (self island: using) star.
	
	class := ('public' asParser trim optional, 'class' asParser trim, self identifier,  'endclass' asParser trim) 
		==> [:t | t third] .
	file := imports, ((self island: class) ==> [:t | t second ]) plus.	
	
	result := file parse: text.
	
	self assert: result isPetitFailure not.

]

{ #category : #'tests - complex' }
PPIslandTest >> testFile2 [
	| text using imports class file |
	text := '
	
using a.b.c;
using c.d.e;
// some comment
namespace cde {

class Foo 
endclass

public class 123 // invalid class
public struct {}

class bar endclass
}	
	'.
	
	using := 'using' asParser trim, (self identifier, ('.' asParser, self identifier) star) flatten ==> [:t | t second].
	
	imports := (self island: using) star.
	
	class := ('public' asParser trim optional, 'class' asParser trim, self identifier,  'endclass' asParser trim) 
		==> [:t | t third] .
	file := imports, ((self island: class) ==> [:t | t second ]) plus.	
	
	result := file parse: text.
	
	self assert: result isPetitFailure not.

]

{ #category : #'tests - complex' }
PPIslandTest >> testImports [
	| text using imports   |
	text := '

/** whatever */	
using a.b.c;
// another comment
using c.d.e;
// some comment
namespace cde {
}	
	'.
	
	using := 'using' asParser trim, (self identifier, ('.' asParser, self identifier) star) flatten ==> [:t | t second].
	imports := ((self island: using) ==> [:t | t second ]) star.
	
	result := imports parse: text.
	
	self assert: result size = 2.
	self assert: result first = 'a.b.c'.
	self assert: result second = 'c.d.e'.

]

{ #category : #testing }
PPIslandTest >> testIslandAfterIslandPlus [
	
	| island2 islandParser2 island1 islandParser1 parser |
	island1 := 'aa' asParser, 'bb' asParser.
	islandParser1 := self islandInstance.
	islandParser1 island: island1.
	
	island2 := 'cc' asParser.
	islandParser2 := self islandInstance.
	islandParser2 island: island2.
	
	parser := (islandParser1, islandParser2) plus.
	 
	result := islandParser1 parse: '__ aabb __ cc __'.
	self assert: result isPetitFailure not.

]

{ #category : #testing }
PPIslandTest >> testIslandAfterIslandPlus2 [
	
	| island2 islandParser2 island1 islandParser1 parser |
	
	island1 := 'aa' asParser, 'bb' asParser.
	islandParser1 := self islandInstance.
	islandParser1 island: island1.
	
	island2 := 'cc' asParser.
	islandParser2 := self islandInstance.
	islandParser2 island: island2.
	
	parser := (islandParser1, islandParser2) plus.
	 
	result := islandParser1 parse: '__ aaxx __ cc __'.
	self assert: result isPetitFailure.

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
	island := self island: 'X' asParser.
	parser := island plus.
	
	self assert: parser parse: '....X....'.
	self assert: result size = 1.

	self assert: parser parse: '...X...X...XX'.
	self assert: result size = 4.

	self assert: parser fail: '.....'.
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
	
	parser := (self island: a), (self island: b), c.
	
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
	
	| parser   body class extends |
	class := self island: 'class' asParser trim, self identifier trim.	
	extends := self island: 'extends' asParser trim, self identifier trim.
	body := self island: self nestedBlock.

	parser := (class, extends optional, body) plus.
	self assert: parser parse: '
	/* lorem ipsum */ 
	class Foo { whatever } 
	
	// something more 
	class Bar extends Zorg { blah blah bla } 
	// this is the end'.
	
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
