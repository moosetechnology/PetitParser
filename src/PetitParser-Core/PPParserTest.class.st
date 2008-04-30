Class {
	#name : #PPParserTest,
	#superclass : #TestCase,
	#category : #'PetitParser-Tests'
}

{ #category : #utilities }
PPParserTest >> assert: aParser fail: aCollection [
	| stream result |
	stream := PPStream on: aCollection.
	result := aParser parse: stream.
	self assert: result isFailure.
	self assert: stream position = 0
]

{ #category : #utilities }
PPParserTest >> assert: aParser parse: aCollection to: anObject [
	self assert: aParser parse: aCollection to: anObject end: aCollection size 
]

{ #category : #utilities }
PPParserTest >> assert: aParser parse: aCollection to: anObject end: anInteger [
	| stream result |
	stream := PPStream on: aCollection.
	result := aParser parse: stream.
	self assert: result = anObject.
	self assert: stream position = anInteger
]

{ #category : #examples }
PPParserTest >> comment [
	^ ($" asParser , $" asParser not star , $" asParser) token
]

{ #category : #examples }
PPParserTest >> identifier [
	^ (#letter asParser , #word asParser star) token
]

{ #category : #examples }
PPParserTest >> integer [
	^ (#digit asParser plus) token
]

{ #category : #examples }
PPParserTest >> number [
	^ ($- asParser optional , #digit asParser plus , ($. asParser , #digit asParser plus) optional) token
]

{ #category : #testing }
PPParserTest >> testAction [
	| parser |
	parser := #any asParser ==> [ :a | a asUppercase ].
	
	self assert: parser parse: 'a' to: $A.
	
	self assert: parser parse: 'ba' to: $B end: 1.
	self assert: parser parse: 'cba' to: $C end: 1.
	
	self assert: parser fail: ''
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
	self assert: parser parse: 'abac' to: #($a $b $a) end: 3.
	self assert: parser parse: 'abab' to: #($a $b $a $b) end: 4.
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

{ #category : #'testing-sophisticated' }
PPParserTest >> testLeftRecursiveList [
	"S ::= S , number | number"
	
	| int start parser |
	int := self integer ==> [ :node | node copy asInteger ].
	start := PPChoiceParser new.
	start | (start , $, asParser token , int ==> [ :node | node first copyWith: node last ]).
	start | (int ==> [ :node | Array with: node ]).
	parser := start end.

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

{ #category : #'testing-sophisticated' }
PPParserTest >> testLeftRecursiveNumber [
	"S ::= S digit | digit"
	
	| digit start parser |
	digit := #digit asParser ==> #digitValue.
	start := PPChoiceParser new.
	start | (start , digit ==> [ :node | 10 * node first + node last ]).
	start | (digit).
	parser := start end.

	self assert: parser parse: '1' to: 1.
	self assert: parser parse: '12' to: 12.
	self assert: parser parse: '123' to: 123.
	self assert: parser parse: '1234' to: 1234.
	self assert: parser parse: '12345' to: 12345.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'abc'
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

{ #category : #'testing-sophisticated' }
PPParserTest >> testParseAaaBbb [
	"S0 ::= a S1 b
	 S1 ::= S0 | epsilon"
	
	| s0 s1 parser |
	s0 := $a asParser , (s1 := PPChoiceParser new) , $b asParser.
	s1 | s0 | PPEpsilonParser new.
	parser := s0 token.

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

{ #category : #'testing-sophisticated' }
PPParserTest >> testParseAbAbAb [
	"S ::= (A B)+"
	
	| parser |
	parser := ($a asParser , $b asParser) plus token.

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

{ #category : #'testing-sophisticated' }
PPParserTest >> testParseAbabbb [
	"S ::= (A | B)+"

	| parser |
	parser := ($a asParser | $b asParser) plus token.

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
	number := #digit asParser plus token.
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
	self assert: parser not fail: ''.
	self assert: parser not fail: '1'.
	self assert: parser not fail: 'a'
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
	self assert: parser not parse: '1' to: $1.
	self assert: parser not parse: 'a' to: $a.
	self assert: parser not fail: '*'.
	self assert: parser not fail: ''
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
	self assert: parser not parse: '1' to: $1.
	self assert: parser not parse: 'a' to: $a.
	self assert: parser not fail: ''.
	self assert: parser not fail: String cr.
	self assert: parser not fail: String tab
]

{ #category : #'testing-predicate' }
PPParserTest >> testPredicateDigit [
	| parser |
	parser := #digit asParser.
	self assert: parser parse: '0' to: $0.
	self assert: parser parse: '9' to: $9.
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser not parse: ' ' to: $ .
	self assert: parser not parse: 'a' to: $a.
	self assert: parser not fail: ''.
	self assert: parser not fail: '0'
]

{ #category : #'testing-predicate' }
PPParserTest >> testPredicateLetter [
	| parser |
	parser := #letter asParser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'Z' to: $Z.
	self assert: parser fail: ''.
	self assert: parser fail: '0'.
	self assert: parser not parse: '1' to: $1.
	self assert: parser not parse: ' ' to: $ .
	self assert: parser not fail: ''.
	self assert: parser not fail: 'a'
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
	self assert: parser not parse: 'A' to: $A.
	self assert: parser not parse: 'Z' to: $Z.
	self assert: parser not fail: ''.
	self assert: parser not fail: 'a'.
	self assert: parser not fail: '0'
]

{ #category : #'testing-predicate' }
PPParserTest >> testPredicateSpace [
	| parser |
	parser := #space asParser.
	self assert: parser parse: String tab to: Character tab.
	self assert: parser parse: ' ' to: Character space.
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser not parse: 'a' to: $a.
	self assert: parser not parse: '/' to: $/.
	self assert: parser not fail: ''.
	self assert: parser not fail: ' '
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
	self assert: parser not parse: 'a' to: $a.
	self assert: parser not parse: 'z' to: $z.
	self assert: parser not fail: ''.
	self assert: parser not fail: 'A'.
	self assert: parser not fail: '0'
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
	self assert: parser not parse: ' ' to: $ .
	self assert: parser not parse: '-' to: $-.
	self assert: parser not fail: ''.
	self assert: parser not fail: 'a'
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
	self assert: parser fail: 'b'
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
