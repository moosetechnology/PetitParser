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
	self assert: parser parse: 'aa' to: $a end: 1.
	self assert: parser fail: ''.
	self assert: parser fail: 'b'.
	self assert: parser fail: 'A'
]

{ #category : #testing }
PPExtensionTest >> testInterval [
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

{ #category : #testing }
PPExtensionTest >> testOrdered [
	| parser |
	parser := #(1 2) asParser.
	self assert: parser parse: #(1 2) to: #(1 2).
	self assert: parser parse: #(1 2 3) to: #(1 2) end: 2.
	self assert: parser fail: #().
	self assert: parser fail: #(1).
	self assert: parser fail: #(1 1).
	self assert: parser fail: #(1 1 2)
]

{ #category : #testing }
PPExtensionTest >> testPluggable [
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
PPExtensionTest >> testString [
	| parser |
	parser := 'ab' asParser.
	self assert: parser parse: 'ab' to: #($a $b).
	self assert: parser parse: 'aba' to: #($a $b) end: 2.
	self assert: parser parse: 'abb' to: #($a $b) end: 2.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'ac'
]

{ #category : #testing }
PPExtensionTest >> testUnordered [
	| parser |
	parser := #(1 2) asSet asParser.
	self assert: parser parse: #(1) to: 1.
	self assert: parser parse: #(2) to: 2.
	self assert: parser parse: #(1 2) to: 1 end: 1.
	self assert: parser parse: #(2 1) to: 2 end: 1.
	self assert: parser fail: #().
	self assert: parser fail: #(3)
]
