Class {
	#name : #PPPredicateTest,
	#superclass : #PPAbstractParseTest,
	#category : #'PetitParser-Tests'
}

{ #category : #testing }
PPPredicateTest >> testAny [
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

{ #category : #testing }
PPPredicateTest >> testCharacter [
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

{ #category : #testing }
PPPredicateTest >> testControl [
	| parser |
	parser := #control asParser.
	self assert: parser parse: (String with: Character cr) to: Character cr.
	self assert: parser parse: (String with: Character tab) to: Character tab.
	self assert: parser fail: ''.
	self assert: parser fail: '1'.
	self assert: parser fail: 'a'.
	self assert: parser negate parse: '1' to: $1.
	self assert: parser negate parse: 'a' to: $a.
	self assert: parser negate fail: ''.
	self assert: parser negate fail: String cr.
	self assert: parser negate fail: String tab
]

{ #category : #testing }
PPPredicateTest >> testCr [
	| parser |
	parser := #cr asParser.
	self assert: parser parse: (String with: Character cr) to: Character cr
]

{ #category : #testing }
PPPredicateTest >> testDigit [
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

{ #category : #testing }
PPPredicateTest >> testEol [
	| parser |
	parser := PPPredicateParser eol.
	self assert: parser parse: (String with: Character cr) to: Character cr.
	self assert: parser parse: (String with: Character lf) to: Character lf.
	self assert: parser fail: ' '
]

{ #category : #testing }
PPPredicateTest >> testHex [
	| parser |
	parser := #hex asParser.
	self assert: parser parse: '0' to: $0.
	self assert: parser parse: '5' to: $5.
	self assert: parser parse: '9' to: $9.
	self assert: parser parse: 'A' to: $A.
	self assert: parser parse: 'D' to: $D.
	self assert: parser parse: 'F' to: $F.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'e' to: $e.
	self assert: parser parse: 'f' to: $f.
	self assert: parser fail: ''.
	self assert: parser fail: 'g'
]

{ #category : #testing }
PPPredicateTest >> testLetter [
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

{ #category : #testing }
PPPredicateTest >> testLf [
	| parser |
	parser := #lf asParser.
	self assert: parser parse: (String with: Character lf) to: Character lf
]

{ #category : #testing }
PPPredicateTest >> testLowercase [
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

{ #category : #testing }
PPPredicateTest >> testSpace [
	| parser |
	parser := #space asParser.
	self assert: parser parse: (String with: Character tab) to: Character tab.
	self assert: parser parse: ' ' to: Character space.
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser negate parse: 'a' to: $a.
	self assert: parser negate parse: '/' to: $/.
	self assert: parser negate fail: ''.
	self assert: parser negate fail: ' '
]

{ #category : #testing }
PPPredicateTest >> testTab [
	| parser |
	parser := #tab asParser.
	self assert: parser parse: (String with: Character tab) to: Character tab
]

{ #category : #testing }
PPPredicateTest >> testUppercase [
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

{ #category : #testing }
PPPredicateTest >> testWord [
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
