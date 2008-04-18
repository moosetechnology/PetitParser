Class {
	#name : #PPParserTest,
	#superclass : #TestCase,
	#instVars : [
		'parser'
	],
	#category : #'PetitParser-Tests'
}

{ #category : #utilities }
PPParserTest >> assert: aString gives: anObject [
	| result |
	result := parser parse: aString readStream.
	self assert: result = anObject
]

{ #category : #utilities }
PPParserTest >> assertFail: aString [
	| result |
	result := parser parse: aString readStream.
	self assert: result class == PPFail
]

{ #category : #testing }
PPParserTest >> testAlternative [
	parser := $a asLiteral | $b asLiteral.
	self assert: 'a' gives: $a.
	self assert: 'b' gives: $b.
	self assertFail: ''.
	self assertFail: 'c'.
	self assertFail: 'ca'
]

{ #category : #testing }
PPParserTest >> testCharacter [
	parser := $a asLiteral.
	self assert: 'a' gives: $a.
	self assertFail: ''.
	self assertFail: 'b'.
	self assertFail: 'ba'
]

{ #category : #testing }
PPParserTest >> testMany [
	parser := $a asLiteral many.
	self assert: '' gives: #().
	self assert: 'a' gives: #($a).
	self assert: 'aa' gives: #($a $a).
	self assert: 'aaa' gives: #($a $a $a).
	self assert: 'aaab' gives: #($a $a $a)
]

{ #category : #testing }
PPParserTest >> testMany1 [
	parser := $a asLiteral many1.
	self assert: 'a' gives: #($a).
	self assert: 'aa' gives: #($a $a).
	self assert: 'aaa' gives: #($a $a $a).
	self assert: 'aaab' gives: #($a $a $a).
	self assertFail: ''.
	self assertFail: 'b'
]

{ #category : #testing }
PPParserTest >> testOptional [
	parser := $a asLiteral optional.
	self assert: '' gives: nil.
	self assert: 'a' gives: $a.
	self assert: 'aa' gives: $a
]

{ #category : #testing }
PPParserTest >> testSequence [
	parser := $a asLiteral , $b asLiteral.
	self assert: 'ab' gives: #( $a $b ).
	self assertFail: ''.
	self assertFail: 'a'.
	self assertFail: 'aa'.
	self assertFail: 'aab'
]

{ #category : #testing }
PPParserTest >> testString [
	parser := 'abc' asLiteral.
	self assert: 'abc' gives: 'abc'.
	self assert: 'abc ' gives: 'abc'.
	self assertFail: 'ab'.
	self assertFail: 'ab'.
	self assertFail: 'abd'

]
