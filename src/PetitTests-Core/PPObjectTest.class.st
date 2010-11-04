Class {
	#name : #PPObjectTest,
	#superclass : #PPAbstractParseTest,
	#category : #'PetitTests-Tests'
}

{ #category : #parsers }
PPObjectTest >> number [
	^ PPPredicateObjectParser
		on: [ :each | each isNumber ]
		message: 'number expected'
]

{ #category : #parsers }
PPObjectTest >> string [
	^ PPPredicateObjectParser
		on: [ :each | each isString ]
		message: 'string expected'
]

{ #category : #'testing-operators' }
PPObjectTest >> testChoice [
	| parser |
	parser := self number / self string.
	self assert: parser parse: #(123) to: 123.
	self assert: parser parse: #('abc') to: 'abc'
]

{ #category : #'testing-fancy' }
PPObjectTest >> testFibonacci [
	"This parser accepts fibonacci sequences with arbitrary start pairs."
	
	| parser |
	parser := ((self number , self number) end ==> [ :pair | pair first + pair last ])
		/ (self number , (self number , self number) and >=> [ :stream :continuation |
			| result |
			result := continuation value.
			(result isPetitFailure or: [ result first + result last first ~= result last last ])
				ifFalse: [ parser parseOn: stream ]
				ifTrue: [ PPFailure message: 'invalid fibonacci sequence' at: stream position ] ]).
	self assert: parser parse: #(1 1) to: 2.
	self assert: parser parse: #(1 1 2) to: 3.
	self assert: parser parse: #(1 1 2 3) to: 5.
	self assert: parser parse: #(1 1 2 3 5) to: 8.
	self assert: parser parse: #(1 1 2 3 5 8) to: 13.
	self assert: parser parse: #(1 1 2 3 5 8 13) to: 21.
	self assert: parser fail: #().
	self assert: parser fail: #(1).
	self assert: parser fail: #(1 2 3 4) end: 2
	
]

{ #category : #testing }
PPObjectTest >> testNumber [
	self assert: self number parse: #(123) to: 123.
	self assert: self number fail: #('abc')
]

{ #category : #'testing-operators' }
PPObjectTest >> testSequence [
	| parser |
	parser := self number , self string.
	self assert: parser parse: #(123 'abc') to: #(123 'abc').
	self assert: parser fail: #(123 456).
	self assert: parser fail: #('abc' 'def').
	self assert: parser fail: #('abc' 123)
	
]

{ #category : #testing }
PPObjectTest >> testString [
	self assert: self string parse: #('abc') to: 'abc'.
	self assert: self string fail: #(123)
]
