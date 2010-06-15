Class {
	#name : #PPTokenTest,
	#superclass : #PPAbstractParseTest,
	#category : #'PetitTests-Tests'
}

{ #category : #accessing }
PPTokenTest >> identifier [
	^ #word asParser plus token
]

{ #category : #utilities }
PPTokenTest >> parse: aString using: aParser [
	^ aParser parse: aString
]

{ #category : #testing }
PPTokenTest >> testCollection [
	| input result |
	input := 'foo    '.
	result := self 
		parse: input
		using: self identifier.
	self assert: (result collection = input).
	self assert: (result collection == input)
]

{ #category : #testing }
PPTokenTest >> testColumn [
	| input parser result |
	input := '1' , (String with: Character cr) , '12' , (String with: Character cr) , '123'.
	parser := #any asParser token star.
	result := parser parse: input.
	result 
		with: #(1 2 1 2 3 1 2 3) 
		do: [ :token :line | self assert: token column = line ]
]

{ #category : #testing }
PPTokenTest >> testCopyFromTo [
	| result other |
	result := PPToken on: 'abc'.
	other := result copyFrom: 2 to: 2.
	
	self assert: other size = 1.
	self assert: other start = 2.
	self assert: other stop = 2.
	self assert: other collection = result collection
]

{ #category : #testing }
PPTokenTest >> testEquality [
	| token1 token2 |
	token1 := self  parse: 'foo' using: self identifier.
	token2 := self  parse: 'foo' using: self identifier.
	self deny: token1 == token2.
	self assert: token1 = token2.
	self assert: token1 hash = token2 hash.
]

{ #category : #testing }
PPTokenTest >> testLine [
	| input parser result |
	input := '1' , (String with: Character cr) , '12' , (String with: Character cr) , '123'.
	parser := #any asParser token star.
	result := parser parse: input.
	result 
		with: #(1 1 2 2 2 3 3 3) 
		do: [ :token :line | self assert: token line = line ]
]

{ #category : #testing }
PPTokenTest >> testNew [
	self should: [ PPToken new ] raise: Error.
	
]

{ #category : #testing }
PPTokenTest >> testPrinting [
	| result |
	result := PPToken on: 'var'.
	self assert: result printString = 'a PPToken(var)'
]

{ #category : #testing }
PPTokenTest >> testSize [
	| result |
	result := self 
		parse: 'foo'
		using: self identifier.
	self assert: result size = 3
]

{ #category : #testing }
PPTokenTest >> testStart [
	| result |
	result := self 
		parse: 'foo'
		using: self identifier.
	self assert: result start = 1
]

{ #category : #testing }
PPTokenTest >> testStop [
	| result |
	result := self 
		parse: 'foo'
		using: self identifier.
	self assert: result stop = 3
]

{ #category : #testing }
PPTokenTest >> testValue [
	| input result |
	input := 'foo'.
	result := self 
		parse: input
		using: self identifier.
	self assert: result value = input.
	self deny: result value == input
]
