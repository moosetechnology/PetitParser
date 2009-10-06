Class {
	#name : #PPParserTest,
	#superclass : #PPAbstractParseTest,
	#category : #'PetitParser-Tests'
}

{ #category : #testing }
PPParserTest >> testAction [
	| parser |
	parser := #any asParser ==> #asUppercase.

	self assert: parser parse: 'a' to: $A.
	self assert: parser parse: 'b' to: $B
]

{ #category : #'testing-utilities' }
PPParserTest >> testAllFollowing [
	| p1 p2 p3 |
	p1 := #lowercase asParser.
	p2 := p1 ==> #asUppercase.
	p3 := PPUnresolvedParser new.
	p3 def: p2 / p3.
	
	self assert: p1 allFollowing isEmpty.
	self assert: p2 allFollowing size = 1.
	self assert: p3 allFollowing size = 3
]

{ #category : #testing }
PPParserTest >> testAnd [
	| parser |
	parser := 'foo' asParser flatten , 'bar' asParser flatten and.
	
	self assert: parser parse: 'foobar' to: #('foo' 'bar') end: 3.
	self assert: parser fail: 'foobaz'
]

{ #category : #testing }
PPParserTest >> testBlock [
	| parser |
	parser := [ :s | s next ] asParser.
	
	self assert: parser parse: 'ab' to: $a end: 1.
	self assert: parser parse: 'b' to: $b.
	self assert: parser parse: '' to: nil
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
	parser := PPEpsilonParser new.
	
	self assert: parser parse: '' to: nil.
	
	self assert: parser parse: 'a' to: nil end: 0.
	self assert: parser parse: 'ab' to: nil end: 0
]

{ #category : #testing }
PPParserTest >> testFailing [
	| parser result |
	parser := PPFailingParser message: 'Plonk'.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'aa'.
	
	result := parser parse: 'a' asParserStream.
	self assert: result reason = 'Plonk'.
	self assert: result printString = 'Plonk at 0'
]

{ #category : #'testing-utilities' }
PPParserTest >> testFailure [
	| f1 f2 f3 |
	f1 := PPFailure at: 1.
	f2 := PPFailure reason: 'Fatal'.
	f3 := PPFailure reason: 'Error' at: 3.
	
	self assert: f1 position = 1.
	self assert: f1 reason isNil.
	self assert: f1 isFailure.
	
	self assert: f2 position = 0.
	self assert: f2 reason = 'Fatal'.
	self assert: f2 isFailure.

	self assert: f3 position = 3.
	self assert: f3 reason = 'Error'.
	self assert: f3 isFailure.

	self deny: 4 isFailure.
	self deny: 'foo' isFailure
]

{ #category : #testing }
PPParserTest >> testFlatten [
	| parser |
	parser := $a asParser flatten.
	
	self assert: parser parse: 'a' to: 'a'.
	self assert: parser parse: 'a ' to: 'a'.
	self assert: parser parse: 'a	' to: 'a'.
	self assert: parser parse: 'a  ' to: 'a'.
	
	self assert: parser parse: 'a' to: 'a'.
	self assert: parser parse: ' a' to: 'a'.
	self assert: parser parse: '	a' to: 'a'.
	self assert: parser parse: '    a' to: 'a'.
	
	self assert: parser parse: 'a a' to: 'a' end: 2.
	self assert: parser parse: 'a	a' to: 'a' end: 2.
	self assert: parser parse: 'a  a' to: 'a' end: 3.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'
]

{ #category : #'testing-utilities' }
PPParserTest >> testFollowing [
	| p1 p2 p3 |
	p1 := #lowercase asParser.
	p2 := p1 ==> #asUppercase.
	p3 := PPUnresolvedParser new.
	p3 def: p2 / p3.
	
	self assert: p1 following isEmpty.
	self assert: p2 following size = 1.
	self assert: p3 following size = 2
]

{ #category : #testing }
PPParserTest >> testMax [
	| parser |
	parser := $a asParser max: 2.

	self assert: parser parse: '' to: #().
	self assert: parser parse: 'a' to: #($a).
	self assert: parser parse: 'aa' to: #($a $a).
	self assert: parser parse: 'aaa' to: #($a $a) end: 2.
	self assert: parser parse: 'aaaa' to: #($a $a) end: 2.
	
	self assert: parser printString = 'a PPRepeatingParser [0, 2]'
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
	
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser parse: 'aa' to: #($a $a).
	self assert: parser parse: 'aaa' to: #($a $a $a).
	self assert: parser parse: 'aaaa' to: #($a $a $a $a).
	
	self assert: parser printString = 'a PPRepeatingParser [2, *]'
]

{ #category : #testing }
PPParserTest >> testMinMax [
	| parser |
	parser := $a asParser min: 2 max: 4.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser parse: 'aa' to: #($a $a).
	self assert: parser parse: 'aaa' to: #($a $a $a).
	self assert: parser parse: 'aaaa' to: #($a $a $a $a).
	self assert: parser parse: 'aaaaa' to: #($a $a $a $a) end: 4.
	self assert: parser parse: 'aaaaaa' to: #($a $a $a $a) end: 4.
	
	self assert: parser printString = 'a PPRepeatingParser [2, 4]'
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
PPParserTest >> testNot [
	| parser |
	parser := 'foo' asParser flatten , 'bar' asParser flatten not.
	
	self assert: parser parse: 'foobaz' to: #('foo' nil) end: 3.
	self assert: parser fail: 'foobar'.
	
	parser := 'foo' asParser flatten , 'bar' asParser flatten not not.
	self assert: parser fail: 'foobaz'.
	self assert: parser parse: 'foobar'
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

{ #category : #testing }
PPParserTest >> testPlus [
	| parser |
	parser := $a asParser plus.
	
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

{ #category : #'testing-accessing' }
PPParserTest >> testPrint [
	| parser |
	parser := PPSequenceParser new.
	self assert: parser printString = 'a PPSequenceParser'.
	
	parser := PPChoiceParser named: 'choice'.
	self assert: parser printString = 'a PPChoiceParser(choice)'
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

{ #category : #testing }
PPParserTest >> testStar [
	| parser |
	parser := $a asParser star.
	
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
PPParserTest >> testToken [
	| parser |
	parser := $a asParser token.
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
	
	parser := PPEpsilonParser new.
	self deny: parser isUnresolved
]

{ #category : #testing }
PPParserTest >> testWrapped [
	| parser |
	parser := $a asParser wrapped.
	
	self assert: parser parse: 'a' to: $a.
	self assert: parser fail: 'b'
]
