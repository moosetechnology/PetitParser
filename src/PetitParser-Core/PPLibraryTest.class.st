Class {
	#name : #PPLibraryTest,
	#superclass : #TestCase,
	#category : #'PetitParser-Tests'
}

{ #category : #utilities }
PPLibraryTest >> assert: aParser fail: aCollection [
	| stream result |
	stream := PPStream on: aCollection.
	result := aParser parse: stream.
	self assert: result isFailure.
	self assert: stream position = 0
]

{ #category : #utilities }
PPLibraryTest >> assert: aParser parse: aCollection to: anObject [
	| stream result |
	stream := PPStream on: aCollection.
	result := aParser parse: stream.
	self assert: result = anObject.
	self assert: stream atEnd
]

{ #category : #examples }
PPLibraryTest >> comment [
	^ ($" asParser , $" asParser not star , $" asParser) token
]

{ #category : #examples }
PPLibraryTest >> identifier [
	^ (#letter asParser , #word asParser star) token
]

{ #category : #examples }
PPLibraryTest >> integer [
	^ #digit asParser plus
]

{ #category : #examples }
PPLibraryTest >> number [
	^ ($- asParser optional , #digit asParser plus , ($. asParser , #digit asParser plus) optional) token
]

{ #category : #testing }
PPLibraryTest >> testAction [
	| parser |
	parser := #any asParser ==> [ :a | a ].
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'b' to: $b.
	self assert: parser fail: ''
]

{ #category : #'testing-extension' }
PPLibraryTest >> testCharacter [
	| parser |
	parser := $a asParser.	
	self assert: parser parse: 'a' to: $a.
	self assert: parser fail: ''.
	self assert: parser fail: 'b'.
	self assert: parser fail: 'A'
]

{ #category : #testing }
PPLibraryTest >> testChoice [
	| parser |
	parser := $a asParser | $b asParser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'b' to: $b.
	self assert: parser fail: ''.
	self assert: parser fail: 'c'.
	self assert: parser fail: 'ca'
]

{ #category : #testing }
PPLibraryTest >> testEndOfInput [
	| parser |
	parser := PPEndOfInputParser new.
	self assert: parser parse: '' to: nil.
	self assert: parser fail: 'a'
]

{ #category : #testing }
PPLibraryTest >> testEpsilon [
	| parser |
	parser := PPEpsilonParser new.
	self assert: parser parse: '' to: nil
]

{ #category : #testing }
PPLibraryTest >> testFailing [
	| parser |
	parser := PPFailingParser new.
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'aa'
]

{ #category : #'testing-extension' }
PPLibraryTest >> testInterval [
	| parser |
	parser := (1 to: 3) asParser.

	self assert: parser parse: #(1) to: 1.
	self assert: parser parse: #(2) to: 2.
	self assert: parser parse: #(3) to: 3.

	self assert: parser fail: #(0).
	self assert: parser fail: #(4)
]

{ #category : #'testing-abstract' }
PPLibraryTest >> testLeftRecursion [
	| parser |
	parser := PPChoiceParser new.
	parser | (parser , #digit asParser ==> [ :node | 10 * node first + node second digitValue]).
	parser | (#digit asParser ==> [ :node | node digitValue ]).
	
	
]

{ #category : #testing }
PPLibraryTest >> testOptional [
	| parser |
	parser := $a asParser optional.
	self assert: parser parse: '' to: nil.
	self assert: parser parse: 'a' to: $a
]

{ #category : #'testing-extension' }
PPLibraryTest >> testOrdered [
	| parser |
	parser := #(1 3) asParser.

	self assert: parser parse: #(1 3) to: #(1 3).

	self assert: parser fail: #().
	self assert: parser fail: #(1).
	self assert: parser fail: #(1 2).
	self assert: parser fail: #(1 1 3)
]

{ #category : #'testing-abstract' }
PPLibraryTest >> testParseAaaBbb [
	"S0 ::= S1 | epsilon
	 S1 ::= a S0 b "
	
	| s0 s1 parser |
	s0 := (s1 := PPSequenceParser new) | PPEpsilonParser new.
	s1 , $a asParser , s0 , $b asParser.
	parser := (s0 , PPEndOfInputParser new) token.

	self assert: parser parse: 'ab' to: 'ab'.
	self assert: parser parse: 'aabb' to: 'aabb'.
	self assert: parser parse: 'aaabbb' to: 'aaabbb'.
	self halt.
	self assert: parser parse: 'aaaabbbb' to: 'aaaabbbb'.
	

	self assert: parser fail: 'a'.
	self assert: parser fail: 'b'.
	self assert: parser fail: 'aab'.
	self assert: parser fail: 'abb'.
	self assert: parser fail: 'aaabb'.
	self assert: parser fail: 'aabbb'
]

{ #category : #'testing-abstract' }
PPLibraryTest >> testParseAandB [
	"S ::= (A B)+"
	
	| parser |
	parser := (($a asParser , $b asParser) plus , PPEndOfInputParser new) token.

	self assert: parser parse: 'ab' to: 'ab'.
	self assert: parser parse: 'abab' to: 'abab'.
	self assert: parser parse: 'ababab' to: 'ababab'.
	self assert: parser parse: 'abababab' to: 'abababab'.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'aba'.
	self assert: parser fail: 'ababa'.
	self assert: parser fail: 'ababbbb'
]

{ #category : #'testing-abstract' }
PPLibraryTest >> testParseAorB [
	"S ::= (A | B)+"

	| parser |
	parser := (($a asParser | $b asParser) plus , PPEndOfInputParser new) token.

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
	
	self assert: parser fail: ''.
	self assert: parser fail: 'c'.
	self assert: parser fail: 'abc'
]

{ #category : #'testing-examples' }
PPLibraryTest >> testParseComment [
	self assert: self comment parse: '""' to: '""'.
	self assert: self comment parse: '"a"' to: '"a"'.
	self assert: self comment parse: '"ab"' to: '"ab"'.
	self assert: self comment parse: '"abc"' to: '"abc"'.

	self assert: self comment fail: '"'.
	self assert: self comment fail: '"a'.
	self assert: self comment fail: '"aa'.
	self assert: self comment fail: 'a"'.
	self assert: self comment fail: 'aa"'
]

{ #category : #'testing-examples' }
PPLibraryTest >> testParseIdentifier [
	self assert: self identifier parse: 'a' to: 'a'.
	self assert: self identifier parse: 'a1' to: 'a1'.
	self assert: self identifier parse: 'a12' to: 'a12'.
	self assert: self identifier parse: 'ab' to: 'ab'.
	self assert: self identifier parse: 'a1b' to: 'a1b'.
	
	self assert: self identifier fail: ''.
	self assert: self identifier fail: ' '.
	self assert: self identifier fail: '1'.
	self assert: self identifier fail: '1a'
]

{ #category : #'testing-abstract' }
PPLibraryTest >> testParseListOfNumbersLeftRecursive [
	"S ::= S , number | number"
	
	| number parser |
	number := self number ==> [ :node | Number readFrom: node copy ].
	parser := PPChoiceParser new.
	parser | (parser , $, asParser token , number ==> [ :node | node first copyWith: node last ]).
	parser | (number ==> [ :node | Array with: node ]).
	parser := parser , PPEndOfInputParser new ==> [ :node | node first ].

	self assert: parser parse: '1' to: (1 to: 1) asArray.
	self assert: parser parse: '1, 2' to: (1 to: 2) asArray.
	self assert: parser parse: '1, 2, 3' to: (1 to: 3) asArray.
	self assert: parser parse: '1, 2, 3, 4' to: (1 to: 4) asArray.
	self assert: parser parse: '1, 2, 3, 4, 5' to: (1 to: 5) asArray
]

{ #category : #'testing-examples' }
PPLibraryTest >> testParseNumber [
	self assert: self number parse: '1' to: '1'.
	self assert: self number parse: '12' to: '12'.
	self assert: self number parse: '12.3' to: '12.3'.
	self assert: self number parse: '12.34' to: '12.34'.
	
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
PPLibraryTest >> testParseReturn [
	| number spaces return |
	number := #digit asParser plus token.
	spaces := #space asParser star.
	return := (spaces , $^ asParser , spaces , number , spaces)
		==> [ :nodes | { #return. nodes at: 4 } ].

	self assert: return parse: '^1' to: #(return '1').
	self assert: return parse: ' ^12' to: #(return '12').
	self assert: return parse: '^123 ' to: #(return '123').
	self assert: return parse: '^ 1234' to: #(return '1234')
]

{ #category : #testing }
PPLibraryTest >> testPlus [
	| parser |
	parser := $a asParser plus.
	self assert: parser parse: 'a' to: #($a).
	self assert: parser parse: 'aa' to: #($a $a).
	self assert: parser parse: 'aaa' to: #($a $a $a).
	self assert: parser fail: ''.
	self assert: parser fail: 'b'.
	self assert: parser fail: 'ba'
]

{ #category : #'testing-predicate' }
PPLibraryTest >> testPredicateAny [
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
PPLibraryTest >> testPredicateCharacter [
	| parser |
	parser := $* asParser.
	
	self assert: parser parse: '*' to: $*.
	
	self assert: parser fail: ''.
	self assert: parser fail: '1'.
	self assert: parser fail: 'a'.
	
	self assert: parser not parse: '1' to: $1.
	self assert: parser not parse: 'a' to: $a.
	
	self assert: parser not fail: '*'.
	self assert: parser not fail: ''
	
]

{ #category : #'testing-predicate' }
PPLibraryTest >> testPredicateControl [
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
PPLibraryTest >> testPredicateDigit [
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
PPLibraryTest >> testPredicateLetter [
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
PPLibraryTest >> testPredicateLowercase [
	| parser |
	parser := #lowercase asParser.
	
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'z' to: $z.

	self assert: parser fail: ''.
	self assert: parser fail: 'A'.
	self assert: parser fail: '0'
]

{ #category : #'testing-predicate' }
PPLibraryTest >> testPredicateSpace [
	| parser |
	parser := #space asParser.
	
	self assert: parser parse: String tab to: Character tab.
	self assert: parser parse: ' ' to: Character space.

	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	
	self assert: parser not parse: 'a' to: $a.
	self assert: parser not parse: '/' to: $/.

	self assert: parser not fail: ''.
	self assert: parser not fail: ' '.
]

{ #category : #'testing-predicate' }
PPLibraryTest >> testPredicateUppercase [
	| parser |
	parser := #uppercase asParser.
	
	self assert: parser parse: 'A' to: $A.
	self assert: parser parse: 'Z' to: $Z.

	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: '0'
]

{ #category : #'testing-predicate' }
PPLibraryTest >> testPredicateWord [
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
PPLibraryTest >> testSequence [
	| parser |
	parser := $a asParser , $b asParser.
	self assert: parser parse: 'ab' to: #($a $b).
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'aa'.
	self assert: parser fail: 'ba'.
	self assert: parser fail: 'bab'
]

{ #category : #testing }
PPLibraryTest >> testStar [
	| parser |
	parser := $a asParser star.
	self assert: parser parse: '' to: #().
	self assert: parser parse: 'a' to: #($a).
	self assert: parser parse: 'aa' to: #($a $a).
	self assert: parser parse: 'aaa' to: #($a $a $a)
]

{ #category : #'testing-extension' }
PPLibraryTest >> testString [
	| parser |
	parser := 'ab' asParser.

	self assert: parser parse: 'ab' to: #($a $b).

	self assert: parser fail: 'a'.
	self assert: parser fail: 'ac'
]

{ #category : #testing }
PPLibraryTest >> testToken [
	| parser |
	parser := $a asParser token.

	self assert: parser parse: 'a' to: 'a'.
	self assert: parser parse: 'a ' to: 'a'.
	self assert: parser parse: 'a  ' to: 'a'.

	self assert: parser fail: ''.
	self assert: parser fail: 'b'
]

{ #category : #'testing-extension' }
PPLibraryTest >> testUnordered [
	| parser |
	parser := #(1 3) asSet asParser.

	self assert: parser parse: #(1) to: 1.
	self assert: parser parse: #(3) to: 3.

	self assert: parser fail: #().
	self assert: parser fail: #(2).
	self assert: parser fail: #(2 1).
	self assert: parser fail: #(2 3)
]
