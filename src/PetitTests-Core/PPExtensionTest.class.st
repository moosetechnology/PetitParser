Class {
	#name : #PPExtensionTest,
	#superclass : #PPAbstractParserTest,
	#category : #'PetitTests-Tests'
}

{ #category : #'testing-parser' }
PPExtensionTest >> testCharacter [
	| parser |
	parser := $a asParser.
	self assert: parser parse: 'a' to: $a.
	self assert: parser fail: 'b'
]

{ #category : #'testing-parser' }
PPExtensionTest >> testChoice [
	| parser |
	parser := #(1 2) asChoiceParser.
	self assert: parser parse: #(1) to: 1.
	self assert: parser parse: #(2) to: 2.
	self assert: parser parse: #(1 2) to: 1 end: 1.
	self assert: parser parse: #(2 1) to: 2 end: 1.
	self assert: parser fail: #().
	self assert: parser fail: #(3)
]

{ #category : #'testing-parser' }
PPExtensionTest >> testClosure [
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
	
	parser := [ :stream | stream upTo: $s. PPFailure message: 'stream' at: stream position ] asParser.
	self assert: parser fail: ''.
	self assert: parser fail: 's'.
	self assert: parser fail: 'as'
	
]

{ #category : #'testing-parser' }
PPExtensionTest >> testEpsilon [
	| parser |
	parser := nil asParser.
	self assert: parser asParser = parser
]

{ #category : #'testing-parser' }
PPExtensionTest >> testParser [
	| parser |
	parser := $a asParser.
	self assert: parser asParser = parser
]

{ #category : #'testing-parser' }
PPExtensionTest >> testRange [
	| parser |
	parser := $a - $c.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'b' to: $b.
	self assert: parser parse: 'c' to: $c.
	self assert: parser fail: 'd'
]

{ #category : #'testing-parser' }
PPExtensionTest >> testSequence [
	| parser |
	parser := #(1 2) asSequenceParser.
	self assert: parser parse: #(1 2) to: #(1 2).
	self assert: parser parse: #(1 2 3) to: #(1 2) end: 2.
	self assert: parser fail: #().
	self assert: parser fail: #(1).
	self assert: parser fail: #(1 1).
	self assert: parser fail: #(1 1 2)
]

{ #category : #'testing-stream' }
PPExtensionTest >> testStream [
	| stream |
	stream := 'abc' readStream asPetitStream.
	self assert: (stream class = PPStream).
	self assert: (stream printString = '·abc').
	self assert: (stream peek) = $a.
	self assert: (stream uncheckedPeek = $a).
	self assert: (stream next) = $a.
	self assert: (stream printString = 'a·bc').
	self assert: (stream asPetitStream = stream)
]

{ #category : #'testing-parser' }
PPExtensionTest >> testString [
	| parser |
	parser := 'ab' asParser.
	self assert: parser parse: 'ab' to: 'ab'.
	self assert: parser parse: 'aba' to: 'ab' end: 2.
	self assert: parser parse: 'abb' to: 'ab' end: 2.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'ac'
]

{ #category : #'testing-parser' }
PPExtensionTest >> testSymbol [
	| parser |
	parser := #any asParser.
	self assert: parser parse: 'a'.
	self assert: parser fail: ''
]

{ #category : #'testing-stream' }
PPExtensionTest >> testText [
	| stream |
	stream := 'abc' asText asPetitStream.
	self assert: stream class = PPStream
]
