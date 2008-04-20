Class {
	#name : #PPParserTest,
	#superclass : #TestCase,
	#category : #'PetitParser-Tests'
}

{ #category : #utilities }
PPParserTest >> assert: aParser fail: aCollection [
	| stream result |
	stream := aCollection readStream.
	result := aParser parse: stream.
	self assert: result isFailure.
	self assert: stream position = 0
]

{ #category : #utilities }
PPParserTest >> assert: aParser parse: aCollection to: anObject [
	| stream result |
	stream := aCollection readStream.
	result := aParser parse: stream.
	self assert: result = anObject.
	self assert: stream atEnd
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
PPParserTest >> number [
	^ ($- asParser optional , #digit asParser plus , ($. asParser , #digit asParser plus) optional) token
]

{ #category : #testing }
PPParserTest >> testAction [
	| parser |
	parser := #any asParser ==> [ :a | a ].
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'b' to: $b.
	self assert: parser fail: ''
]

{ #category : #'testing-extension' }
PPParserTest >> testCharacter [
	| parser |
	parser := $a asParser.	
	self assert: parser parse: 'a' to: $a.
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
	self assert: parser fail: ''.
	self assert: parser fail: 'c'.
	self assert: parser fail: 'ca'
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
	self assert: parser parse: '' to: nil
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

	self assert: parser fail: #(0).
	self assert: parser fail: #(4)
]

{ #category : #testing }
PPParserTest >> testOptional [
	| parser |
	parser := $a asParser optional.
	self assert: parser parse: '' to: nil.
	self assert: parser parse: 'a' to: $a
]

{ #category : #'testing-extension' }
PPParserTest >> testOrdered [
	| parser |
	parser := #(1 3) asParser.

	self assert: parser parse: #(1 3) to: #(1 3).

	self assert: parser fail: #().
	self assert: parser fail: #(1).
	self assert: parser fail: #(1 2).
	self assert: parser fail: #(1 1 3)
]

{ #category : #'testing-examples' }
PPParserTest >> testParseComment [
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
PPParserTest >> testParseIdentifier [
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

{ #category : #'testing-examples' }
PPParserTest >> testParseNumber [
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
PPParserTest >> testParseReturn [
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
PPParserTest >> testPlus [
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
	self assert: parser fail: '0'
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
	self assert: parser not fail: ' '.
]

{ #category : #'testing-predicate' }
PPParserTest >> testPredicateUppercase [
	| parser |
	parser := #uppercase asParser.
	
	self assert: parser parse: 'A' to: $A.
	self assert: parser parse: 'Z' to: $Z.

	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: '0'
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
PPParserTest >> testSequence [
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
PPParserTest >> testStar [
	| parser |
	parser := $a asParser star.
	self assert: parser parse: '' to: #().
	self assert: parser parse: 'a' to: #($a).
	self assert: parser parse: 'aa' to: #($a $a).
	self assert: parser parse: 'aaa' to: #($a $a $a)
]

{ #category : #'testing-extension' }
PPParserTest >> testString [
	| parser |
	parser := 'ab' asParser.

	self assert: parser parse: 'ab' to: #($a $b).

	self assert: parser fail: 'a'.
	self assert: parser fail: 'ac'
]

{ #category : #testing }
PPParserTest >> testToken [
	| parser |
	parser := $a asParser token.
	self assert: parser parse: 'a' to: 'a'.
	self assert: parser fail: ''.
	self assert: parser fail: 'b'
]

{ #category : #'testing-extension' }
PPParserTest >> testUnordered [
	| parser |
	parser := #(1 3) asSet asParser.

	self assert: parser parse: #(1) to: 1.
	self assert: parser parse: #(3) to: 3.

	self assert: parser fail: #().
	self assert: parser fail: #(2).
	self assert: parser fail: #(2 1).
	self assert: parser fail: #(2 3)
]
