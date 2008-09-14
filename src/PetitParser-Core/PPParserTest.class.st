Class {
	#name : #PPParserTest,
	#superclass : #PPAbstractParseTest,
	#category : #'PetitParser-Tests'
}

{ #category : #examples }
PPParserTest >> comment [
	^ ($" asParser , $" asParser negate star , $" asParser) flatten
]

{ #category : #examples }
PPParserTest >> identifier [
	^ (#letter asParser , #word asParser star) flatten
]

{ #category : #examples }
PPParserTest >> integer [
	^ (#digit asParser plus) flatten
]

{ #category : #examples }
PPParserTest >> number [
	^ ($- asParser optional , #digit asParser plus , ($. asParser , #digit asParser plus) optional) flatten
]

{ #category : #'testing-mapping' }
PPParserTest >> testAction [
	| parser |
	parser := #any asParser ==> [ :a | a asUppercase ].
	
	self assert: parser parse: 'a' to: $A.
	
	self assert: parser parse: 'ba' to: $B end: 1.
	self assert: parser parse: 'cba' to: $C end: 1.
	
	self assert: parser fail: ''
]

{ #category : #testing }
PPParserTest >> testAnd [
	| parser |
	parser := 'foo' asParser flatten , 'bar' asParser flatten and.
	
	self assert: parser parse: 'foobar' to: #('foo' 'bar') end: 3.
	self assert: parser fail: 'foobaz'
]

{ #category : #'testing-extension' }
PPParserTest >> testCharacter [
	| parser |
	parser := $a asParser.	
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'aa' to: $a end: 1.
	self assert: parser fail: ''.
	self assert: parser fail: 'b'.
	self assert: parser fail: 'A'
]

{ #category : #testing }
PPParserTest >> testChoice [
	| parser |
	parser := $a asParser | $b asParser.
	
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
	parser := PPEndOfInputParser new.
	
	self assert: parser parse: '' to: nil.
	self assert: parser fail: 'a'
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
	| parser |
	parser := PPFailingParser new.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'aa'
]

{ #category : #testing }
PPParserTest >> testFlatten [
	| parser |
	parser := $a asParser flatten.
	
	self assert: parser parse: 'a' to: 'a'.
	self assert: parser parse: 'a ' to: 'a'.
	self assert: parser parse: 'a	' to: 'a'.
	self assert: parser parse: 'a  ' to: 'a'.
	
	self assert: parser parse: 'a a' to: 'a' end: 2.
	self assert: parser parse: 'a	a' to: 'a' end: 2.
	self assert: parser parse: 'a  a' to: 'a' end: 3.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'.
	self assert: parser fail: ' a'
]

{ #category : #'testing-mapping' }
PPParserTest >> testFoldLeft2 [
	| parser |
	parser := #any asParser star 
		foldLeft: [ :a :b | Array with: a with: b ].

	self assert: parser parse: #(a) to: #a.
	self assert: parser parse: #(a b) to: #(a b).
	self assert: parser parse: #(a b c) to: #((a b) c).
	self assert: parser parse: #(a b c d) to: #(((a b) c) d).
	self assert: parser parse: #(a b c d e) to: #((((a b) c) d) e)
]

{ #category : #'testing-mapping' }
PPParserTest >> testFoldLeft3 [
	| parser |
	parser := #any asParser star 
		foldLeft: [ :a :b :c | Array with: a with: b with: c ].

	self assert: parser parse: #(a) to: #a.
	self assert: parser parse: #(a b c) to: #(a b c).
	self assert: parser parse: #(a b c d e) to: #((a b c) d e)
]

{ #category : #'testing-mapping' }
PPParserTest >> testFoldRight2 [
	| parser |
	parser := #any asParser star 
		foldRight: [ :a :b | Array with: a with: b ].

	self assert: parser parse: #(a) to: #a.
	self assert: parser parse: #(a b) to: #(a b).
	self assert: parser parse: #(a b c) to: #(a (b c)).
	self assert: parser parse: #(a b c d) to: #(a (b (c d))).
	self assert: parser parse: #(a b c d e) to: #(a (b (c (d e))))
]

{ #category : #'testing-mapping' }
PPParserTest >> testFoldRight3 [
	| parser |
	parser := #any asParser star 
		foldRight: [ :a :b :c | Array with: a with: b with: c ].

	self assert: parser parse: #(a) to: #a.
	self assert: parser parse: #(a b c) to: #(a b c).
	self assert: parser parse: #(a b c d e) to: #(a b (c d e))
]

{ #category : #'testing-composed' }
PPParserTest >> testIfThenElse [
	"S ::= if C then S else S | if C then S | X"
	
	| start if then else cond expr parser |
	start := PPChoiceParser new.
	if := 'if' asParser token.
	then := 'then' asParser token.
	else := 'else' asParser token.
	cond := 'C' asParser token.
	expr := 'X' asParser token.
	start | (if , cond , then , start , else , start).
	start | (if , cond , then , start).
	start | (expr).
	parser := start end.
	
	self assert: parser parse: 'X'.
	self assert: parser parse: 'if C then X'.
	self assert: parser parse: 'if C then X else X'.
	
	self assert: parser parse: 'if C then if C then X'.
	self assert: parser parse: 'if C then if C then X else if C then X'.
	self assert: parser parse: 'if C then if C then X else X else if C then X'.
	self assert: parser parse: 'if C then if C then X else X else if C then X else X'.
	
	self assert: parser fail: 'if C else X'
]

{ #category : #'testing-extension' }
PPParserTest >> testInterval [
	| parser |
	parser := (1 to: 3) asParser.
	self assert: parser parse: #(1) to: 1.
	self assert: parser parse: #(2) to: 2.
	self assert: parser parse: #(3) to: 3.
	self assert: parser parse: #(1 2) to: 1 end: 1.
	self assert: parser parse: #(2 3) to: 2 end: 1.
	self assert: parser parse: #(3 4) to: 3 end: 1.
	self assert: parser fail: #(0).
	self assert: parser fail: #(4)
]

{ #category : #'testing-composed' }
PPParserTest >> testListOfIntegers [
	"S ::= S , number | number"
	
	| number list parser |
	number := self integer ==> #asInteger.
	list := (number separatedBy: $, asParser flatten)
		==> [ :node | node select: [ :each | each isInteger ] ].
	parser := list end.

	self assert: parser parse: '1' to: (1 to: 1) asArray.
	self assert: parser parse: '1,2' to: (1 to: 2) asArray.
	self assert: parser parse: '1,2,3' to: (1 to: 3) asArray.
	self assert: parser parse: '1,2,3,4' to: (1 to: 4) asArray.
	self assert: parser parse: '1,2,3,4,5' to: (1 to: 5) asArray.

	self assert: parser parse: '1' to: (1 to: 1) asArray.
	self assert: parser parse: '1, 2' to: (1 to: 2) asArray.
	self assert: parser parse: '1, 2, 3' to: (1 to: 3) asArray.
	self assert: parser parse: '1, 2, 3, 4' to: (1 to: 4) asArray.
	self assert: parser parse: '1, 2, 3, 4, 5' to: (1 to: 5) asArray.

	self assert: parser parse: '1' to: (1 to: 1) asArray.
	self assert: parser parse: '1 ,2' to: (1 to: 2) asArray.
	self assert: parser parse: '1 ,2 ,3' to: (1 to: 3) asArray.
	self assert: parser parse: '1 ,2 ,3 ,4' to: (1 to: 4) asArray.
	self assert: parser parse: '1 ,2 ,3 ,4 ,5' to: (1 to: 5) asArray.
	
	self assert: parser fail: ''.
	self assert: parser fail: ','.
	self assert: parser fail: '1,'.
	self assert: parser fail: '1,,2'
]

{ #category : #'testing-mapping' }
PPParserTest >> testMap2 [
	| parser |
	parser := (#any asParser , #any asParser) 
		map: [ :a :b | Array with: b with: a ].

	self assert: parser parse: #(a b) to: #(b a)
]

{ #category : #'testing-mapping' }
PPParserTest >> testMap3 [
	| parser |
	parser := (#any asParser , #any asParser , #any asParser)
		map: [ :a :b :c | Array with: c with: b with: a ].

	self assert: parser parse: #(a b c) to: #(c b a)
]

{ #category : #'testing-composed' }
PPParserTest >> testNestedComments [
	"C ::= B I* E"
	"I ::= !E (C | T)"
	"B ::= /*"
	"E ::= */"
	"T ::= ."
	
	| begin end any inside parser |
	begin := '/*' asParser.
	end := '*/' asParser.
	any := #any asParser.
	
	parser := PPSequenceParser new.
	inside := end not , (parser | any).
	parser , begin , inside star , end.
	
	self assert: parser parse: '/*ab*/cd' end: 6.
	self assert: parser parse: '/*a/*b*/c*/'.
	self assert: parser fail: '/*a/*b*/c'
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

{ #category : #'testing-extension' }
PPParserTest >> testOrdered [
	| parser |
	parser := #(1 2) asParser.
	self assert: parser parse: #(1 2) to: #(1 2).
	self assert: parser parse: #(1 2 3) to: #(1 2) end: 2.
	self assert: parser fail: #().
	self assert: parser fail: #(1).
	self assert: parser fail: #(1 1).
	self assert: parser fail: #(1 1 2)
]

{ #category : #'testing-composed' }
PPParserTest >> testPalindrome [
	"S0 ::= a S1 a | b S1 b | ...
	 S1 ::= S0 | epsilon"
	
	| s0 s1 parser |
	s0 := PPChoiceParser new.
	s1 := PPChoiceParser new.
	s0 | ($a asParser , s1 , $a asParser).
	s0 | ($b asParser , s1 , $b asParser).	
	s0 | ($c asParser , s1 , $c asParser).	
	s1 | s0 | PPEpsilonParser new.
	parser := s0 flatten end.

	self assert: parser parse: 'aa' to: 'aa'.
	self assert: parser parse: 'bb' to: 'bb'.
	self assert: parser parse: 'cc' to: 'cc'.
	
	self assert: parser parse: 'abba' to: 'abba'.
	self assert: parser parse: 'baab' to: 'baab'.

	self assert: parser parse: 'abccba' to: 'abccba'.
	self assert: parser parse: 'abaaba' to: 'abaaba'.
	self assert: parser parse: 'cbaabc' to: 'cbaabc'.

	self assert: parser fail: 'a'.
	self assert: parser fail: 'ab'.
	self assert: parser fail: 'aab'.
	self assert: parser fail: 'abccbb'
]

{ #category : #'testing-composed' }
PPParserTest >> testParseAaaBbb [
	"S0 ::= a S1 b
	 S1 ::= S0 | epsilon"
	
	| s0 s1 parser |
	s0 := $a asParser , (s1 := PPChoiceParser new) , $b asParser.
	s1 | s0 | PPEpsilonParser new.
	parser := s0 flatten.

	self assert: parser parse: 'ab' to: 'ab'.
	self assert: parser parse: 'aabb' to: 'aabb'.
	self assert: parser parse: 'aaabbb' to: 'aaabbb'.
	self assert: parser parse: 'aaaabbbb' to: 'aaaabbbb'.

	self assert: parser parse: 'abb' to: 'ab' end: 2.
	self assert: parser parse: 'aabbb' to: 'aabb' end: 4.
	self assert: parser parse: 'aaabbbb' to: 'aaabbb' end: 6.
	self assert: parser parse: 'aaaabbbbb' to: 'aaaabbbb' end: 8.

	self assert: parser fail: 'a'.
	self assert: parser fail: 'b'.
	self assert: parser fail: 'aab'.
	self assert: parser fail: 'aaabb'
]

{ #category : #'testing-composed' }
PPParserTest >> testParseAaaaaa [
	"S ::= a a S | epsilon"
	
	| s0 s1 parser |
	s0 := PPChoiceParser new.
	s1 := $a asParser , $a asParser , s0.
	s0 | s1 | PPEpsilonParser new.
	parser := s0 flatten.

	self assert: parser parse: '' to: ''.
	self assert: parser parse: 'aa' to: 'aa'.
	self assert: parser parse: 'aaaa' to: 'aaaa'.
	self assert: parser parse: 'aaaaaa' to: 'aaaaaa'.

	self assert: parser parse: 'a' to: '' end: 0.
	self assert: parser parse: 'aaa' to: 'aa' end: 2.
	self assert: parser parse: 'aaaaa' to: 'aaaa' end: 4.
	self assert: parser parse: 'aaaaaaa' to: 'aaaaaa' end: 6
]

{ #category : #'testing-composed' }
PPParserTest >> testParseAbAbAb [
	"S ::= (A B)+"
	
	| parser |
	parser := ($a asParser , $b asParser) plus flatten.

	self assert: parser parse: 'ab' to: 'ab'.
	self assert: parser parse: 'abab' to: 'abab'.
	self assert: parser parse: 'ababab' to: 'ababab'.
	self assert: parser parse: 'abababab' to: 'abababab'.

	self assert: parser parse: 'abb' to: 'ab' end: 2.
	self assert: parser parse: 'ababa' to: 'abab' end: 4.
	self assert: parser parse: 'abababb' to: 'ababab' end: 6.
	self assert: parser parse: 'ababababa' to: 'abababab' end: 8.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'bab'
]

{ #category : #'testing-composed' }
PPParserTest >> testParseAbabbb [
	"S ::= (A | B)+"

	| parser |
	parser := ($a asParser | $b asParser) plus flatten.

	self assert: parser parse: 'a' to: 'a'.
	self assert: parser parse: 'b' to: 'b'.
	self assert: parser parse: 'ab' to: 'ab'.
	self assert: parser parse: 'ba' to: 'ba'.
	self assert: parser parse: 'aaa' to: 'aaa'.
	self assert: parser parse: 'aab' to: 'aab'.
	self assert: parser parse: 'aba' to: 'aba'.
	self assert: parser parse: 'baa' to: 'baa'.
	self assert: parser parse: 'abb' to: 'abb'.
	self assert: parser parse: 'bab' to: 'bab'.
	self assert: parser parse: 'bba' to: 'bba'.
	self assert: parser parse: 'bbb' to: 'bbb'.

	self assert: parser parse: 'ac' to: 'a' end: 1.
	self assert: parser parse: 'bc' to: 'b' end: 1.
	self assert: parser parse: 'abc' to: 'ab' end: 2.
	self assert: parser parse: 'bac' to: 'ba' end: 2.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'c'
]

{ #category : #'testing-examples' }
PPParserTest >> testParseComment [
	self assert: self comment parse: '""' to: '""'.
	self assert: self comment parse: '"a"' to: '"a"'.
	self assert: self comment parse: '"ab"' to: '"ab"'.
	self assert: self comment parse: '"abc"' to: '"abc"'.

	self assert: self comment parse: '""a' to: '""' end: 2.
	self assert: self comment parse: '"a"a' to: '"a"' end: 3.
	self assert: self comment parse: '"ab"a' to: '"ab"' end: 4.
	self assert: self comment parse: '"abc"a' to: '"abc"' end: 5.

	self assert: self comment fail: '"'.
	self assert: self comment fail: '"a'.
	self assert: self comment fail: '"aa'.
	self assert: self comment fail: 'a"'.
	self assert: self comment fail: 'aa"'
]

{ #category : #'testing-examples' }
PPParserTest >> testParseIdentifier [
	self assert: self identifier parse: 'a' to: 'a'.
	self assert: self identifier parse: 'a1' to: 'a1'.
	self assert: self identifier parse: 'a12' to: 'a12'.
	self assert: self identifier parse: 'ab' to: 'ab'.
	self assert: self identifier parse: 'a1b' to: 'a1b'.

	self assert: self identifier parse: 'a_' to: 'a' end: 1.
	self assert: self identifier parse: 'a1-' to: 'a1' end: 2.
	self assert: self identifier parse: 'a12+' to: 'a12' end: 3.
	self assert: self identifier parse: 'ab^' to: 'ab' end: 2.
	self assert: self identifier parse: 'a1b*' to: 'a1b' end: 3.

	self assert: self identifier fail: ''.
	self assert: self identifier fail: ' '.
	self assert: self identifier fail: '1'.
	self assert: self identifier fail: '1a'
]

{ #category : #'testing-examples' }
PPParserTest >> testParseNumber [
	self assert: self number parse: '1' to: '1'.
	self assert: self number parse: '12' to: '12'.
	self assert: self number parse: '12.3' to: '12.3'.
	self assert: self number parse: '12.34' to: '12.34'.

	self assert: self number parse: '1..' to: '1' end: 1.
	self assert: self number parse: '12-' to: '12' end: 2.
	self assert: self number parse: '12.3.' to: '12.3' end: 4.
	self assert: self number parse: '12.34.' to: '12.34' end: 5.
	
	self assert: self number parse: '-1' to: '-1'.
	self assert: self number parse: '-12' to: '-12'.
	self assert: self number parse: '-12.3' to: '-12.3'.
	self assert: self number parse: '-12.34' to: '-12.34'.
	
	self assert: self number fail: ''.
	self assert: self number fail: '-'.
	self assert: self number fail: '.'.
	self assert: self number fail: '.1'
]

{ #category : #'testing-examples' }
PPParserTest >> testParseReturn [
	| number spaces return |
	number := #digit asParser plus flatten.
	spaces := #space asParser star.
	return := (spaces , $^ asParser , spaces , number)
		==> [ :nodes | { #return. nodes at: 4 } ].

	self assert: return parse: '^1' to: #(return '1').
	self assert: return parse: ' ^12' to: #(return '12').
	self assert: return parse: '^123 ' to: #(return '123').
	self assert: return parse: '^ 1234' to: #(return '1234').
	
	self assert: return fail: '1'.
	self assert: return fail: '^'
]

{ #category : #'testing-extension' }
PPParserTest >> testPluggable [
	| parser |
	parser := [ :stream | stream upTo: $s ] asParser.
	self assert: parser parse: '' to: ''.
	self assert: parser parse: 'a' to: 'a'.
	self assert: parser parse: 'aa' to: 'aa'.
	self assert: parser parse: 's' to: ''.
	self assert: parser parse: 'as' to: 'a'.
	self assert: parser parse: 'aas' to: 'aa'.
	self assert: parser parse: 'sa' to: '' end: 1.
	self assert: parser parse: 'saa' to: '' end: 1.
	
	parser := [ :stream | stream upTo: $s. PPFailure new ] asParser.
	self assert: parser fail: ''.
	self assert: parser fail: 's'.
	self assert: parser fail: 'as'
	
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

{ #category : #'testing-predicate' }
PPParserTest >> testPredicateAny [
	| parser |
	parser := #any asParser.
	self assert: parser parse: ' ' to: $ .
	self assert: parser parse: '1' to: $1.
	self assert: parser parse: 'a' to: $a.
	self assert: parser fail: ''.
	self assert: parser negate fail: ''.
	self assert: parser negate fail: '1'.
	self assert: parser negate fail: 'a'
]

{ #category : #'testing-predicate' }
PPParserTest >> testPredicateCharacter [
	| parser |
	parser := $* asParser.
	self assert: parser parse: '*' to: $*.
	self assert: parser parse: '**' to: $* end: 1.
	self assert: parser fail: ''.
	self assert: parser fail: '1'.
	self assert: parser fail: 'a'.
	self assert: parser negate parse: '1' to: $1.
	self assert: parser negate parse: 'a' to: $a.
	self assert: parser negate fail: '*'.
	self assert: parser negate fail: ''
]

{ #category : #'testing-predicate' }
PPParserTest >> testPredicateControl [
	| parser |
	parser := #control asParser.
	self assert: parser parse: String cr to: Character cr.
	self assert: parser parse: String tab to: Character tab.
	self assert: parser fail: ''.
	self assert: parser fail: '1'.
	self assert: parser fail: 'a'.
	self assert: parser negate parse: '1' to: $1.
	self assert: parser negate parse: 'a' to: $a.
	self assert: parser negate fail: ''.
	self assert: parser negate fail: String cr.
	self assert: parser negate fail: String tab
]

{ #category : #'testing-predicate' }
PPParserTest >> testPredicateDigit [
	| parser |
	parser := #digit asParser.
	self assert: parser parse: '0' to: $0.
	self assert: parser parse: '9' to: $9.
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser negate parse: ' ' to: $ .
	self assert: parser negate parse: 'a' to: $a.
	self assert: parser negate fail: ''.
	self assert: parser negate fail: '0'
]

{ #category : #'testing-predicate' }
PPParserTest >> testPredicateLetter [
	| parser |
	parser := #letter asParser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'Z' to: $Z.
	self assert: parser fail: ''.
	self assert: parser fail: '0'.
	self assert: parser negate parse: '1' to: $1.
	self assert: parser negate parse: ' ' to: $ .
	self assert: parser negate fail: ''.
	self assert: parser negate fail: 'a'
]

{ #category : #'testing-predicate' }
PPParserTest >> testPredicateLowercase [
	| parser |
	parser := #lowercase asParser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'z' to: $z.
	self assert: parser fail: ''.
	self assert: parser fail: 'A'.
	self assert: parser fail: '0'.
	self assert: parser negate parse: 'A' to: $A.
	self assert: parser negate parse: 'Z' to: $Z.
	self assert: parser negate fail: ''.
	self assert: parser negate fail: 'a'.
	self assert: parser negate fail: '0'
]

{ #category : #'testing-predicate' }
PPParserTest >> testPredicateSpace [
	| parser |
	parser := #space asParser.
	self assert: parser parse: String tab to: Character tab.
	self assert: parser parse: ' ' to: Character space.
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser negate parse: 'a' to: $a.
	self assert: parser negate parse: '/' to: $/.
	self assert: parser negate fail: ''.
	self assert: parser negate fail: ' '
]

{ #category : #'testing-predicate' }
PPParserTest >> testPredicateUppercase [
	| parser |
	parser := #uppercase asParser.
	self assert: parser parse: 'A' to: $A.
	self assert: parser parse: 'Z' to: $Z.
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: '0'.
	self assert: parser negate parse: 'a' to: $a.
	self assert: parser negate parse: 'z' to: $z.
	self assert: parser negate fail: ''.
	self assert: parser negate fail: 'A'.
	self assert: parser negate fail: '0'
]

{ #category : #'testing-predicate' }
PPParserTest >> testPredicateWord [
	| parser |
	parser := #word asParser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'A' to: $A.
	self assert: parser parse: '0' to: $0.
	self assert: parser fail: ''.
	self assert: parser fail: '-'.
	self assert: parser negate parse: ' ' to: $ .
	self assert: parser negate parse: '-' to: $-.
	self assert: parser negate fail: ''.
	self assert: parser negate fail: 'a'
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

{ #category : #'testing-extension' }
PPParserTest >> testString [
	| parser |
	parser := 'ab' asParser.
	self assert: parser parse: 'ab' to: #($a $b).
	self assert: parser parse: 'aba' to: #($a $b) end: 2.
	self assert: parser parse: 'abb' to: #($a $b) end: 2.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'ac'
]

{ #category : #testing }
PPParserTest >> testToken [
	| parser |
	parser := $a asParser token.
	
	self assert: parser parse: 'a' to: 'a'.
	self assert: parser parse: 'a ' to: 'a'.
	self assert: parser parse: 'a	' to: 'a'.
	self assert: parser parse: 'a  ' to: 'a'.
	
	self assert: parser parse: 'a a' to: 'a' end: 2.
	self assert: parser parse: 'a	a' to: 'a' end: 2.
	self assert: parser parse: 'a  a' to: 'a' end: 3.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'b'.
	self assert: parser fail: ' a'
]

{ #category : #'testing-extension' }
PPParserTest >> testUnordered [
	| parser |
	parser := #(1 2) asSet asParser.
	self assert: parser parse: #(1) to: 1.
	self assert: parser parse: #(2) to: 2.
	self assert: parser parse: #(1 2) to: 1 end: 1.
	self assert: parser parse: #(2 1) to: 2 end: 1.
	self assert: parser fail: #().
	self assert: parser fail: #(3)
]
