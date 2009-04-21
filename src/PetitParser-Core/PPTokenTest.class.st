Class {
	#name : #PPTokenTest,
	#superclass : #PPAbstractParseTest,
	#category : #'PetitParser-Tests'
}

{ #category : #accessing }
PPTokenTest >> identifier [
	^ #word asParser plus token
]

{ #category : #utilities }
PPTokenTest >> parse: aString using: aParser [
	^ aParser parse: aString asParserStream
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
PPTokenTest >> testSize [
	| result |
	result := self 
		parse: 'foo'
		using: self identifier.
	self assert: result size = 3.
	self assert: result length = 3
]

{ #category : #testing }
PPTokenTest >> testStart [
	| result |
	result := self 
		parse: 'foo'
		using: self identifier.
	self assert: result start = 1.
	self assert: result startPosition = 1
]

{ #category : #testing }
PPTokenTest >> testStop [
	| result |
	result := self 
		parse: 'foo'
		using: self identifier.
	self assert: result stop = 3.
	self assert: result stopPosition = 3
]

{ #category : #testing }
PPTokenTest >> testTesting [
	| result |
	result := PPToken on: 'var'.
	self deny: result isRBToken.
	self deny: result isPatternVariable.
	self assert: result printString = 'a PPToken(var)'.
	
	result := PPToken on: '`var'.
	self deny: result isRBToken.
	self assert: result isPatternVariable.
	self assert: result printString = 'a PPToken(`var)'
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
