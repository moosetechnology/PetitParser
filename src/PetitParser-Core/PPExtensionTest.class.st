Class {
	#name : #PPExtensionTest,
	#superclass : #PPAbstractParseTest,
	#category : #'PetitParser-Tests'
}

{ #category : #testing }
PPExtensionTest >> testCharacter [
	| parser |
	parser := $a asParser.	
	self assert: parser parse: 'a' to: $a.
	self assert: parser fail: 'b' at: 0
]

{ #category : #testing }
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
	
	parser := [ :stream | stream upTo: $s. PPFailure new ] asParser.
	self assert: parser fail: '' at: 0.
	self assert: parser fail: 's' at: 0.
	self assert: parser fail: 'as' at: 0
	
]

{ #category : #testing }
PPExtensionTest >> testEpsilon [
	| parser |
	parser := nil asParser.
	self assert: parser asParser = parser
]

{ #category : #testing }
PPExtensionTest >> testFlatten [
	self assert: #() flatten = #().
	self assert: #(1 2) flatten = #(1 2).
	self assert: #('abc') flatten = #('abc').
	self assert: #(1 (2 3) 4) flatten = #(1 2 3 4).
	self assert: #(1 (2 () (3 (((4)))))) flatten = #(1 2 3 4)
]

{ #category : #testing }
PPExtensionTest >> testOrdered [
	| parser |
	parser := #(1 2) asParser.
	self assert: parser parse: #(1 2) to: #(1 2).
	self assert: parser parse: #(1 2 3) to: #(1 2) end: 2.
	self assert: parser fail: #() at: 0.
	self assert: parser fail: #(1) at:  1.
	self assert: parser fail: #(1 1) at: 1.
	self assert: parser fail: #(1 1 2) at: 1 
]

{ #category : #testing }
PPExtensionTest >> testParser [
	| parser |
	parser := $a asParser.
	self assert: parser asParser = parser
]

{ #category : #testing }
PPExtensionTest >> testRange [
	| parser |
	parser := $a - $c.
	self assert: parser parse: 'a' to: $a.
	self assert: parser parse: 'b' to: $b.
	self assert: parser parse: 'c' to: $c.
	self assert: parser fail: 'd' at: 0
]

{ #category : #testing }
PPExtensionTest >> testStream [
	| stream |
	stream := 'abc' readStream asParserStream.
	self assert: (stream class = PPStream).
	self assert: (stream printString = '·abc').
	self assert: (stream peek) = $a.
	self assert: (stream next) = $a.
	self assert: (stream printString = 'a·bc')
	
]

{ #category : #testing }
PPExtensionTest >> testString [
	| parser |
	parser := 'ab' asParser.
	self assert: parser parse: 'ab' to: 'ab'.
	self assert: parser parse: 'aba' to: 'ab' end: 2.
	self assert: parser parse: 'abb' to: 'ab' end: 2.
	self assert: parser fail: 'b' at: 0.
	self assert: parser fail: 'a' at: 0.
	self assert: parser fail: 'ac' at: 0
]

{ #category : #testing }
PPExtensionTest >> testSymbol [
	| parser |
	parser := #any asParser.
	self assert: parser parse: 'a'.
	self assert: parser fail: '' at: 0
]

{ #category : #testing }
PPExtensionTest >> testText [
	| stream |
	stream := 'abc' asText asParserStream.
	self assert: stream class = PPStream
]

{ #category : #testing }
PPExtensionTest >> testUnordered [
	| parser |
	parser := #(1 2) asSet asParser.
	self assert: parser parse: #(1) to: 1.
	self assert: parser parse: #(2) to: 2.
	self assert: parser parse: #(1 2) to: 1 end: 1.
	self assert: parser parse: #(2 1) to: 2 end: 1.
	self assert: parser fail: #() at: 0.
	self assert: parser fail: #(3) at: 0
]
