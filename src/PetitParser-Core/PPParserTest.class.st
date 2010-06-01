Class {
	#name : #PPParserTest,
	#superclass : #PPAbstractParseTest,
	#category : #'PetitParser-Tests'
}

{ #category : #testing }
PPParserTest >> testAction [
	| block parser |
	block := [ :char | char asUppercase ].
	parser := #any asParser ==> block.
	self assert: parser block = block.

	self assert: parser parse: 'a' to: $A.
	self assert: parser parse: 'b' to: $B
]

{ #category : #testing }
PPParserTest >> testAnd [
	| parser |
	parser := 'foo' asParser flatten , 'bar' asParser flatten and.
	
	self assert: parser parse: 'foobar' to: #('foo' 'bar') end: 3.
	self assert: parser fail: 'foobaz'.
	
	parser := 'foo' asParser and.
	self assert: parser and = parser
]

{ #category : #testing }
PPParserTest >> testAnswer [
	| parser |
	parser := $a asParser answer: $b.
	
	self assert: parser parse: 'a' to: $b.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'
]

{ #category : #testing }
PPParserTest >> testBlock [
	| parser |
	parser := [ :s | s next ] asParser.
	
	self assert: parser parse: 'ab' to: $a end: 1.
	self assert: parser parse: 'b' to: $b.
	self assert: parser parse: '' to: nil
]

{ #category : #'testing-utilities' }
PPParserTest >> testChildren [
	| p1 p2 p3 |
	p1 := #lowercase asParser.
	p2 := p1 ==> #asUppercase.
	p3 := PPUnresolvedParser new.
	p3 def: p2 / p3.
	self assert: p1 children isEmpty.
	self assert: p2 children size = 1.
	self assert: p3 children size = 2
]

{ #category : #testing }
PPParserTest >> testChoice [
	| parser |
	parser := $a asParser / $b asParser.
	
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'b' to: $b.

	self assert: parser parse: 'ab' to: $a end: 1.
	self assert: parser parse: 'ba' to: $b end: 1.

	self assert: parser fail: ''.
	self assert: parser fail: 'c'.
	self assert: parser fail: 'ca'
]

{ #category : #testing }
PPParserTest >> testDelimitedBy [
	| parser |
	parser := $a asParser delimitedBy: $b asParser.
	
	self assert: parser parse: 'a' to: #($a).
	self assert: parser parse: 'aba' to: #($a $b $a).
	self assert: parser parse: 'ababa' to: #($a $b $a $b $a).

	self assert: parser parse: 'ab' to: #($a $b).
	self assert: parser parse: 'abab' to: #($a $b $a $b).
	self assert: parser parse: 'ababab' to: #($a $b $a $b $a $b).
	
	self assert: parser parse: 'ac' to: #($a) end: 1.
	self assert: parser parse: 'abc' to: #($a $b) end: 2.
	self assert: parser parse: 'abac' to: #($a $b $a) end: 3.
	self assert: parser parse: 'ababc' to: #($a $b $a $b) end: 4.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'.
	self assert: parser fail: 'c'
]

{ #category : #testing }
PPParserTest >> testEndOfInput [
	| parser |
	parser := PPEndOfInputParser on: $a asParser.
	self assert: parser end = parser.
	
	self assert: parser parse: 'a' to: $a.
	self assert: parser fail: ''.
	self assert: parser fail: 'aa'
]

{ #category : #testing }
PPParserTest >> testEndOfInputAfterMatch [
	| parser |
	parser := 'stuff' asParser end.
	self assert: parser parse: 'stuff' to: 'stuff'.
	self assert: parser fail: 'stufff'.
	self assert: parser fail: 'fluff'
]

{ #category : #testing }
PPParserTest >> testEpsilon [
	| parser |
	parser := nil asParser.
	
	self assert: parser parse: '' to: nil.
	
	self assert: parser parse: 'a' to: nil end: 0.
	self assert: parser parse: 'ab' to: nil end: 0
]

{ #category : #testing }
PPParserTest >> testFailing [
	| parser result |
	parser := PPFailingParser message: 'Plonk'.
	self assert: parser message = 'Plonk'.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'aa'.
	
	result := parser parse: 'a'.
	self assert: result message = 'Plonk'.
	self assert: result printString = 'Plonk at 0'
]

{ #category : #'testing-utilities' }
PPParserTest >> testFailure [
	| failure |
	failure := PPFailure message: 'Error' at: 3.
	
	self assert: failure message = 'Error'.
	self assert: failure position = 3.
	self assert: failure isPetitFailure.

	self deny: 4 isPetitFailure.
	self deny: 'foo' isPetitFailure
]

{ #category : #testing }
PPParserTest >> testFlatten [
	| parser |
	parser := $a asParser flatten.
	
	self assert: parser parse: 'a' to: 'a'.
	self assert: parser parse: #($a) to: #($a).
	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'
]

{ #category : #'testing-properties' }
PPParserTest >> testHasProperty [
	| parser |
	parser := PPParser new.
	self deny: (parser hasProperty: #foo).
	parser propertyAt: #foo put: 123.
	self assert: (parser hasProperty: #foo)
]

{ #category : #'testing-utilities' }
PPParserTest >> testListConstructor [
	| p1 p2 p3 |
	p1 := PPChoiceParser with: $a asParser.
	p2 := PPChoiceParser with: $a asParser with: $b asParser.
	p3 := PPChoiceParser withAll: (Array with: $a asParser with: $b asParser with: $c asParser).
	
	self assert: p1 children size = 1.
	self assert: p2 children size = 2.
	self assert: p3 children size = 3
]

{ #category : #testing }
PPParserTest >> testLiteralObject [
	| parser |
	parser := PPLiteralObjectParser 
		on: $a
		message: 'letter "a" expected'.
	self assert: parser literal = $a.
	self assert: parser message = 'letter "a" expected'.
	
	self assert: parser parse: 'a' to: $a.
	self assert: parser fail: 'b'
	
]

{ #category : #testing }
PPParserTest >> testLiteralObjectCaseInsensitive [
	| parser |
	parser := $a asParser caseInsensitive.
	
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'A' to: $A.

	self assert: parser fail: ''.
	self assert: parser fail: 'b'.
	self assert: parser fail: 'B'
	
]

{ #category : #testing }
PPParserTest >> testLiteralSequence [
	| parser |
	parser := PPLiteralSequenceParser 
		on: 'abc'
		message: 'sequence "abc" expected'.
	self assert: parser literal = 'abc'.
	self assert: parser message = 'sequence "abc" expected'.
	
	self assert: parser parse: 'abc' to: 'abc'.
	self assert: parser fail: 'ab'.
	self assert: parser fail: 'abd'
]

{ #category : #testing }
PPParserTest >> testLiteralSequenceCaseInsensitive [
	| parser |
	parser := 'abc' asParser caseInsensitive.
	
	self assert: parser parse: 'abc' to: 'abc'.
	self assert: parser parse: 'ABC' to: 'ABC'.
	self assert: parser parse: 'abC' to: 'abC'.
	self assert: parser parse: 'AbC' to: 'AbC'.
	
	self assert: parser fail: 'ab'.
	self assert: parser fail: 'abd'
]

{ #category : #'testing-utilities' }
PPParserTest >> testMatches [
	| parser |
	parser := $a asParser.
	
	self assert: (parser matches: 'a').
	self deny: (parser matches: 'b').
	
	self assert: (parser matches: 'a' readStream).
	self deny: (parser matches: 'b' readStream)
]

{ #category : #'testing-utilities' }
PPParserTest >> testMatchesIn [
	| parser result |
	parser := $a asParser.
	
	result := parser matchesIn: 'abba'.
	self assert: result size = 2.
	self assert: result first = $a.
	self assert: result last = $a.
	
	result := parser matchesIn: 'baaah'.
	self assert: result size = 3.
	self assert: result first = $a.
	self assert: result last = $a
]

{ #category : #'testing-utilities' }
PPParserTest >> testMatchesInEmpty [
	"Empty matches should properly advance and match at each position and at the end."

	| parser result |
	parser := [ :stream | stream position ] asParser.
	
	result := parser matchesIn: '123'.
	self assert: result asArray = #(0 1 2 3)
]

{ #category : #'testing-utilities' }
PPParserTest >> testMatchesInOverlapping [
	"Matches that overlap should be properly reported."

	| parser result |
	parser := #digit asParser , #digit asParser.
	
	result := parser matchesIn: 'a123b'.
	self assert: result size = 2.
	self assert: result first = #($1 $2).
	self assert: result last = #($2 $3)
]

{ #category : #'testing-utilities' }
PPParserTest >> testMatchingRangesIn [
	| input parser result |
	input := 'a12b1'.
	parser := #digit asParser plus.
	result := parser matchingRangesIn: input.
	self assert: result size = 3.
	result do: [ :each | self assert: (parser matches: (input copyFrom: each first to: each last)) ]
]

{ #category : #testing }
PPParserTest >> testMax [
	| parser |
	parser := $a asParser max: 2.
	self assert: parser min = 0.
	self assert: parser max = 2.

	self assert: parser parse: '' to: #().
	self assert: parser parse: 'a' to: #($a).
	self assert: parser parse: 'aa' to: #($a $a).
	self assert: parser parse: 'aaa' to: #($a $a) end: 2.
	self assert: parser parse: 'aaaa' to: #($a $a) end: 2.
	
	self assert: (parser printString endsWith: '[0, 2]')
]

{ #category : #testing }
PPParserTest >> testMemoized [
	| count parser twice |
	count := 0.
	parser := [ :s | count := count + 1. s next ] asParser memoized.
	twice := parser and , parser.
	
	count := 0.
	self assert: parser parse: 'a' to: $a.
	self assert: count = 1.

	count := 0.
	self assert: twice parse: 'a' to: #($a $a).
	self assert: count = 1.
	
	self assert: parser memoized = parser
]

{ #category : #testing }
PPParserTest >> testMin [
	| parser |
	parser := $a asParser min: 2.
	self assert: parser min = 2.
	self assert: parser max > parser min.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser parse: 'aa' to: #($a $a).
	self assert: parser parse: 'aaa' to: #($a $a $a).
	self assert: parser parse: 'aaaa' to: #($a $a $a $a).
	
	self assert: (parser printString endsWith: '[2, *]')
]

{ #category : #testing }
PPParserTest >> testMinMax [
	| parser |
	parser := $a asParser min: 2 max: 4.
	self assert: parser min = 2.
	self assert: parser max = 4.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser parse: 'aa' to: #($a $a).
	self assert: parser parse: 'aaa' to: #($a $a $a).
	self assert: parser parse: 'aaaa' to: #($a $a $a $a).
	self assert: parser parse: 'aaaaa' to: #($a $a $a $a) end: 4.
	self assert: parser parse: 'aaaaaa' to: #($a $a $a $a) end: 4.
	
	self assert: (parser printString endsWith: '[2, 4]')
]

{ #category : #'testing-accessing' }
PPParserTest >> testNamed [
	| parser |
	parser := PPSequenceParser new.
	self assert: parser name isNil.
	
	parser := PPChoiceParser named: 'choice'.
	self assert: parser name = 'choice'.
	
	parser := $* asParser name: 'star'.
	self assert: parser name = 'star'
]

{ #category : #testing }
PPParserTest >> testNegate [
	| parser |
	parser := 'foo' asParser negate.
	
	self assert: parser parse: 'f' to: $f end: 1.
	self assert: parser parse: 'fo' to: $f end: 1.
	self assert: parser parse: 'fob' to: $f end: 1.
	self assert: parser parse: 'ffoo' to: $f end: 1.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'foo'
]

{ #category : #testing }
PPParserTest >> testNot [
	| parser |
	parser := 'foo' asParser flatten , 'bar' asParser flatten not.
	
	self assert: parser parse: 'foobaz' to: #('foo' nil) end: 3.
	self assert: parser fail: 'foobar'.
	
	parser := 'foo' asParser.
	self assert: parser not not = parser
]

{ #category : #testing }
PPParserTest >> testOptional [
	| parser |
	parser := $a asParser optional.
	
	self assert: parser parse: '' to: nil.
	self assert: parser parse: 'a' to: $a.
	
	self assert: parser parse: 'aa' to: $a end: 1.
	self assert: parser parse: 'ab' to: $a end: 1.
	self assert: parser parse: 'b' to: nil end: 0.
	self assert: parser parse: 'bb' to: nil end: 0.
	self assert: parser parse: 'ba' to: nil end: 0
]

{ #category : #'testing-utilities' }
PPParserTest >> testParse [
	| parser result |
	parser := $a asParser.
	
	self assert: (parser parse: 'a') = $a.
	self assert: (result := parser parse: 'b') isPetitFailure.
	self assert: (result position = 0).
	self assert: (result message =  '$a expected').
	
	self assert: (parser parse: 'a' readStream) = $a.
	self assert: (result := parser parse: 'b' readStream) isPetitFailure.
	self assert: (result position = 0).
	self assert: (result message =  '$a expected')
]

{ #category : #'testing-utilities' }
PPParserTest >> testParseOnError0 [
	| parser result seen |
	parser := $a asParser.

	result := parser parse: 'a' onError: [ self signalFailure: 'Not supposed to report an error' ].
	self assert: result = $a.

	result := parser parse: 'b' onError: [ seen := true ].
	self assert: result.
	self assert: seen
]

{ #category : #'testing-utilities' }
PPParserTest >> testParseOnError1 [
	| parser result seen |
	parser := $a asParser.
	
	result := parser parse: 'a' onError: [ self signalFailure: 'Not supposed to report an error' ].
	self assert: result = $a.
	
	result := parser parse: 'b' onError: [ :failure | 
		self assert: failure position = 0.
		self assert: failure message = '$a expected'.
		seen := true ].
	self assert: result.
	self assert: seen
]

{ #category : #'testing-utilities' }
PPParserTest >> testParseOnError2 [
	| parser result seen |
	parser := $a asParser.
	
	result := parser parse: 'a' onError: [ self signalFailure: 'Not supposed to report an error' ].
	self assert: result = $a.

	result := parser parse: 'b' onError: [ :msg :pos | 
		self assert: msg = '$a expected'.
		self assert: pos = 0.
		seen := true ].
	self assert: result.
	self assert: seen
]

{ #category : #testing }
PPParserTest >> testPermutation [
	| parser |
	parser := #any asParser , #any asParser , #any asParser.

	self assert: (parser permutation: #()) parse: '123' to: #().
	self assert: (parser permutation: #(1)) parse: '123' to: #($1).
	self assert: (parser permutation: #(1 3)) parse: '123' to: #($1 $3).
	self assert: (parser permutation: #(3 1)) parse: '123' to: #($3 $1).
	self assert: (parser permutation: #(2 2)) parse: '123' to: #($2 $2).
	self assert: (parser permutation: #(3 2 1)) parse: '123' to: #($3 $2 $1).
	
	self should: [ parser permutation: #(0) ] raise: Error.
	self should: [ parser permutation: #(4) ] raise: Error.
	self should: [ parser permutation: #($2) ] raise: Error
]

{ #category : #testing }
PPParserTest >> testPluggable [
	| block parser |
	block := [ :stream | stream position ].
	parser := block asParser.
	self assert: parser block = block
]

{ #category : #testing }
PPParserTest >> testPlus [
	| parser |
	parser := $a asParser plus.
	self assert: parser min = 1.
	self assert: parser max > parser min.
	
	self assert: parser parse: 'a' to: #($a).
	self assert: parser parse: 'aa' to: #($a $a).
	self assert: parser parse: 'aaa' to: #($a $a $a).
	
	self assert: parser parse: 'ab' to: #($a) end: 1.
	self assert: parser parse: 'aab' to: #($a $a) end: 2.
	self assert: parser parse: 'aaab' to: #($a $a $a) end: 3.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'.
	self assert: parser fail: 'ba'
]

{ #category : #testing }
PPParserTest >> testPlusGreedy [
	| parser |
	parser := #word asParser plusGreedy: #digit asParser.

	self assert: parser fail: ''.
	self assert: parser fail: '1'.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'ab'.

	self assert: parser parse: 'a1' to: #($a) end: 1.
	self assert: parser parse: 'ab1' to: #($a $b) end: 2.
	self assert: parser parse: 'abc1' to: #($a $b $c) end: 3.
	self assert: parser parse: 'a12' to: #($a $1) end: 2.
	self assert: parser parse: 'ab12' to: #($a $b $1) end: 3.
	self assert: parser parse: 'abc12' to: #($a $b $c $1) end: 4.
	self assert: parser parse: 'a123' to: #($a $1 $2) end: 3.
	self assert: parser parse: 'ab123' to: #($a $b $1 $2) end: 4.
	self assert: parser parse: 'abc123' to: #($a $b $c $1 $2) end: 5.
]

{ #category : #testing }
PPParserTest >> testPlusLazy [
	| parser |
	parser := #word asParser plusLazy: #digit asParser.

	self assert: parser fail: ''.
	self assert: parser fail: '1'.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'ab'.

	self assert: parser parse: 'a1' to: #($a) end: 1.
	self assert: parser parse: 'ab1' to: #($a $b) end: 2.
	self assert: parser parse: 'abc1' to: #($a $b $c) end: 3.
	self assert: parser parse: 'a12' to: #($a) end: 1.
	self assert: parser parse: 'ab12' to: #($a $b) end: 2.
	self assert: parser parse: 'abc12' to: #($a $b $c) end: 3.
	self assert: parser parse: 'a123' to: #($a) end: 1.
	self assert: parser parse: 'ab123' to: #($a $b) end: 2.
	self assert: parser parse: 'abc123' to: #($a $b $c) end: 3
]

{ #category : #'testing-properties' }
PPParserTest >> testPostCopy [
	| parser copy |
	parser := PPParser new.
	parser propertyAt: #foo put: true.
	copy := parser copy.
	copy propertyAt: #foo put: false.
	self assert: (parser propertyAt: #foo).
	self deny: (copy propertyAt: #foo)
]

{ #category : #'testing-accessing' }
PPParserTest >> testPrint [
	| parser |
	parser := PPParser new.
	self assert: (parser printString beginsWith: 'a PPParser').
	
	parser := PPParser named: 'choice'.
	self assert: (parser printString beginsWith: 'a PPParser(choice').
	
	parser := PPLiteralObjectParser on: $a.
	self assert: (parser printString includesSubString: '$a').
	
	parser := PPFailingParser message: 'error'.
	self assert: (parser printString includesSubString: 'error').
	
	parser := PPPredicateParser on: [ :c | true ] message: 'error'.
	self assert: (parser printString includesSubString: 'error')
]

{ #category : #'testing-properties' }
PPParserTest >> testPropertyAt [
	| parser |
	parser := PPParser new.
	self should: [ parser propertyAt: #foo ] raise: Error.
	parser propertyAt: #foo put: true.
	self assert: (parser propertyAt: #foo)
]

{ #category : #'testing-properties' }
PPParserTest >> testPropertyAtIfAbsent [
	| parser |
	parser := PPParser new.
	self assert: (parser propertyAt: #foo ifAbsent: [ true ]).
	parser propertyAt: #foo put: true.
	self assert: (parser propertyAt: #foo ifAbsent: [ false ])
]

{ #category : #'testing-properties' }
PPParserTest >> testPropertyAtIfAbsentPut [
	| parser |
	parser := PPParser new.
	self assert: (parser propertyAt: #foo ifAbsentPut: [ true ]).
	self assert: (parser propertyAt: #foo ifAbsentPut: [ false ])
]

{ #category : #'testing-properties' }
PPParserTest >> testRemoveProperty [
	| parser |
	parser := PPParser new.
	self should: [ parser removeProperty: #foo ] raise: Error.
	parser propertyAt: #foo put: true.
	self assert: (parser removeProperty: #foo)
]

{ #category : #'testing-properties' }
PPParserTest >> testRemovePropertyIfAbsent [
	| parser |
	parser := PPParser new.
	self assert: (parser removeProperty: #foo ifAbsent: [ true ]).
	parser propertyAt: #foo put: true.
	self assert: (parser removeProperty: #foo ifAbsent: [ false ])
]

{ #category : #testing }
PPParserTest >> testSeparatedBy [
	| parser |
	parser := $a asParser separatedBy: $b asParser.
	
	self assert: parser parse: 'a' to: #($a).
	self assert: parser parse: 'aba' to: #($a $b $a).
	self assert: parser parse: 'ababa' to: #($a $b $a $b $a).
	
	self assert: parser parse: 'ab' to: #($a) end: 1.
	self assert: parser parse: 'abab' to: #($a $b $a) end: 3.
	self assert: parser parse: 'ac' to: #($a) end: 1.
	self assert: parser parse: 'abac' to: #($a $b $a) end: 3.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'c'
]

{ #category : #testing }
PPParserTest >> testSequence [
	| parser |
	parser := $a asParser , $b asParser.
	
	self assert: parser parse: 'ab' to: #($a $b).
	
	self assert: parser parse: 'aba' to: #($a $b) end: 2.
	self assert: parser parse: 'abb' to: #($a $b) end: 2.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'aa'.
	self assert: parser fail: 'ba'.
	self assert: parser fail: 'bab'
]

{ #category : #'testing-fixtures' }
PPParserTest >> testSideEffectChoice [
	"Adding another element to a choice should create a copy, otherwise we get unwanted side-effects."

	| p1 p2 p3 |
	p1 := $a asParser.
	p2 := p1 / $b asParser.
	p3 := p1 / $c asParser.
	
	self assert: p1 parse: 'a'.
	self assert: p1 fail: 'b'.
	self assert: p1 fail: 'c'.
	
	self assert: p2 parse: 'a'.
	self assert: p2 parse: 'b'.
	self assert: p2 fail: 'c'.
	
	self assert: p3 parse: 'a'.
	self assert: p3 fail: 'b'.
	self assert: p3 parse: 'c'
]

{ #category : #'testing-fixtures' }
PPParserTest >> testSideEffectListCopy [
	| old new |
	old := $a asParser , $b asParser.
	new := old copy.
	
	self deny: old == new.
	self deny: old children == new children.
	self assert: old children first == new children first.
	self assert: old children last == new children last
]

{ #category : #'testing-fixtures' }
PPParserTest >> testSideEffectSequence [
	"Adding another element to a sequence should create a copy, otherwise we get unwanted side-effects."

	| p1 p2 p3 |
	p1 := $a asParser.
	p2 := p1 , $b asParser.
	p3 := p1 , $c asParser.
	
	self assert: p1 parse: 'a'.	
	self assert: p1 parse: 'ab' end: 1.
	self assert: p1 parse: 'ac' end: 1.
	
	self assert: p2 fail: 'a'.	
	self assert: p2 parse: 'ab'.
	self assert: p2 fail: 'ac'.

	self assert: p3 fail: 'a'.	
	self assert: p3 fail: 'ab'.
	self assert: p3 parse: 'ac'
]

{ #category : #testing }
PPParserTest >> testStar [
	| parser |
	parser := $a asParser star.
	self assert: parser min = 0.
	self assert: parser max > parser min.
	
	self assert: parser parse: '' to: #().
	self assert: parser parse: 'a' to: #($a).
	self assert: parser parse: 'aa' to: #($a $a).
	self assert: parser parse: 'aaa' to: #($a $a $a).
	
	self assert: parser parse: 'b' to: #() end: 0.
	self assert: parser parse: 'ab' to: #($a) end: 1.
	self assert: parser parse: 'aab' to: #($a $a) end: 2.
	self assert: parser parse: 'aaab' to: #($a $a $a) end: 3
]

{ #category : #testing }
PPParserTest >> testStarGreedy [
	| parser |
	parser := #word asParser starGreedy: #digit asParser.

	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'ab'.

	self assert: parser parse: '1' to: #() end: 0.
	self assert: parser parse: 'a1' to: #($a) end: 1.
	self assert: parser parse: 'ab1' to: #($a $b) end: 2.
	self assert: parser parse: 'abc1' to: #($a $b $c) end: 3.
	self assert: parser parse: '12' to: #($1) end: 1.
	self assert: parser parse: 'a12' to: #($a $1) end: 2.
	self assert: parser parse: 'ab12' to: #($a $b $1) end: 3.
	self assert: parser parse: 'abc12' to: #($a $b $c $1) end: 4.
	self assert: parser parse: '123' to: #($1 $2) end: 2.
	self assert: parser parse: 'a123' to: #($a $1 $2) end: 3.
	self assert: parser parse: 'ab123' to: #($a $b $1 $2) end: 4.
	self assert: parser parse: 'abc123' to: #($a $b $c $1 $2) end: 5
]

{ #category : #testing }
PPParserTest >> testStarLazy [
	| parser |
	parser := #word asParser starLazy: #digit asParser.

	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'ab'.

	self assert: parser parse: '1' to: #() end: 0.
	self assert: parser parse: 'a1' to: #($a) end: 1.
	self assert: parser parse: 'ab1' to: #($a $b) end: 2.
	self assert: parser parse: 'abc1' to: #($a $b $c) end: 3.
	self assert: parser parse: '12' to: #() end: 0.
	self assert: parser parse: 'a12' to: #($a) end: 1.
	self assert: parser parse: 'ab12' to: #($a $b) end: 2.
	self assert: parser parse: 'abc12' to: #($a $b $c) end: 3.
	self assert: parser parse: '123' to: #() end: 0.
	self assert: parser parse: 'a123' to: #($a) end: 1.
	self assert: parser parse: 'ab123' to: #($a $b) end: 2.
	self assert: parser parse: 'abc123' to: #($a $b $c) end: 3
]

{ #category : #testing }
PPParserTest >> testToken [
	| parser |
	parser := $a asParser token.
	self assert: parser tokenClass = PPToken.
	self assert: parser parse: 'a' toToken: 1 stop: 1.	
	self assert: parser fail: 'b'.
	self assert: parser fail: ''.
	
	parser := $a asParser token: PPToken.
	self assert: parser tokenClass = PPToken.
	self assert: parser parse: 'a' toToken: 1 stop: 1.	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'
]

{ #category : #testing }
PPParserTest >> testTrim [
	| parser |
	parser := $a asParser token trim.
	self assert: parser trim = parser.
	
	self assert: parser parse: 'a' toToken: 1 stop: 1.
	self assert: parser parse: 'a ' toToken: 1 stop: 1.
	self assert: parser parse: 'a	' toToken: 1 stop: 1.
	self assert: parser parse: 'a  ' toToken: 1 stop: 1.
	
	self assert: parser parse: 'a' toToken: 1 stop: 1.
	self assert: parser parse: ' a' toToken: 2 stop: 2.
	self assert: parser parse: '	a' toToken: 2 stop: 2.
	self assert: parser parse: '    a' toToken: 5 stop: 5.
	
	self assert: parser parse: 'aa' toToken: 1 stop: 1 end: 1.
	self assert: parser parse: 'a	a' toToken: 1 stop: 1 end: 2.
	self assert: parser parse: 'a  a' toToken: 1 stop: 1 end: 3.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'
]

{ #category : #testing }
PPParserTest >> testUnresolved [
	| parser |
	parser := PPUnresolvedParser new.
	
	self assert: parser isUnresolved.
	self should: [ parser parse: '' ] raise: Error.
	self should: [ parser parse: 'a' ] raise: Error.
	self should: [ parser parse: 'ab' ] raise: Error.
	
	parser := nil asParser.
	self deny: parser isUnresolved
]

{ #category : #testing }
PPParserTest >> testWrapped [
	| parser |
	parser := $a asParser wrapped.
	
	self assert: parser parse: 'a' to: $a.
	self assert: parser fail: 'b'
]

{ #category : #testing }
PPParserTest >> testWrapping [
	| parser result |
	parser := #digit asParser plus >=> [ :stream :cc | 
		Array 
			with: stream position 
			with: cc value 
			with: stream position ].

	self assert: parser parse: '1' to: #(0 ($1) 1).
	self assert: parser parse: '12' to: #(0 ($1 $2) 2).
	self assert: parser parse: '123' to: #(0 ($1 $2 $3) 3).
	
	result := parser parse: 'a'.
	self assert: result first = 0.
	self assert: result second isPetitFailure.
	self assert: result last = 0
]

{ #category : #testing }
PPParserTest >> testXor [
	| parser |
	parser := ($a asParser / $b asParser)
			|  ($b asParser / $c asParser).
	
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'c' to: $c.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'.
	self assert: parser fail: 'd'.
	
	" truly symmetric "
	parser := ($b asParser / $c asParser)
			|  ($a asParser / $b asParser).
	
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'c' to: $c.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'.
	self assert: parser fail: 'd'
]
