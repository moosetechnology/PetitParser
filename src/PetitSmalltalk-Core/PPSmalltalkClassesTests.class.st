"
Evalaute the following code to verify the complete image.

PackageOrganizer default packages
	inject: LAPackagesTests new
	into: [ :test :package | 
		[ test verifyPackage: package packageName ]
			on: TestResult resumableFailure
			do: [ :err | err resume ] ]
"
Class {
	#name : #PPSmalltalkClassesTests,
	#superclass : #PPSmalltalkTest,
	#category : #'PetitSmalltalk-Tests'
}

{ #category : #private }
PPSmalltalkClassesTests >> assert: aBoolean description: aString [ 
	self 
		assert: aBoolean
		description: aString
		resumable: true
]

{ #category : #accessing }
PPSmalltalkClassesTests >> parserClass [
	^ PPSmalltalkCompiler
]

{ #category : #testing }
PPSmalltalkClassesTests >> testCollection [
	self verifyClass: Collection.
	self verifyClass: Array.
	self verifyClass: Set.
	self verifyClass: Dictionary.
	self verifyClass: Bag.
	self verifyClass: OrderedCollection.
	self verifyClass: SortedCollection
]

{ #category : #testing }
PPSmalltalkClassesTests >> testDateAndTime [
	self verifyClass: DateAndTime.
	self verifyClass: Duration
]

{ #category : #testing }
PPSmalltalkClassesTests >> testException [
	self verifyClass: Exception.
	self verifyClass: Notification.
	self verifyClass: Warning.
	self verifyClass: Error
]

{ #category : #testing }
PPSmalltalkClassesTests >> testFundamental [
	self verifyClass: Object.
	self verifyClass: Boolean.
	self verifyClass: True.
	self verifyClass: False.
	self verifyClass: Character



]

{ #category : #testing }
PPSmalltalkClassesTests >> testMagnitude [
	self verifyClass: Magnitude.
	self verifyClass: Number.
	self verifyClass: Integer.
	self verifyClass: Float.
	self verifyClass: Fraction
]

{ #category : #'testing-protocol' }
PPSmalltalkClassesTests >> testParseExpression [
	result := self parserClass parseExpression: '1 + 2'.
	self assert: result isMessage.
	self assert: result source = '1 + 2'.
	
	result := self parserClass parseExpression: '| a | 1 + a'.
	self assert: result isSequence.
	self assert: result source =  '| a | 1 + a'.
	
	result := self parserClass parseExpression: '1 + 2. ^ 3'.
	self assert: result isSequence.
	self assert: result source = '1 + 2. ^ 3'.
	
	result := self parserClass parseExpression: '1 + ' onError: [ :err | true ].
	self assert: result.
	
	self 
		should: [ self parserClass parseExpression: '1 + ' ] 
		raise: Error
]

{ #category : #'testing-protocol' }
PPSmalltalkClassesTests >> testParseMethod [
	result := self parserClass parseMethod: 'do 1 + 2'.
	self assert: result isMethod.
	self assert: result source = 'do 1 + 2'.
	
	result := self parserClass parseMethod: 'do 1 +' onError: [ :err | true ].
	self assert: result.
	
	self 
		should: [ self parserClass parseMethod: 'do 1 +' ]
		raise: Error
]

{ #category : #testing }
PPSmalltalkClassesTests >> testStream [
	self verifyClass: Stream.
	self verifyClass: ReadStream.
	self verifyClass: WriteStream
]

{ #category : #private }
PPSmalltalkClassesTests >> verifyClass: aClass [ 
	aClass selectors 
		do: [ :selector | self verifyClass: aClass selector: selector ].
	aClass isMeta
		ifFalse: [ self verifyClass: aClass class ]
]

{ #category : #private }
PPSmalltalkClassesTests >> verifyClass: aClass selector: aSelector [ 
	"Verifies that the method aSelector in aClass parses the same using the standard refactoring parser and the petit smalltalk parser. Also make sure that the position information of all tokens and comments is equal."

	| source original other checker |
	source := aClass sourceCodeAt: aSelector.
	source isNil ifTrue: [ ^ self ].
	original := aClass parseTreeFor: aSelector.
	original isNil ifTrue: [ ^ self ].
	other := self parserInstance parseMethod: source.
	source := aClass name , '>>#' , original selector.
	other isPetitFailure 
		ifTrue: [ self assert: false description: source ].
	self 
		assert: original = other
		description: 'Code in ' , source.
	checker := [ :node1 :node2 |
		self 
			assert: node1 sourceInterval = node2 sourceInterval 
			description: 'Source intervals in ' , source.
		(node2 isArray or: [ node2 isSequence ]) ifTrue: [
			self
				assert: node1 periods = node2 periods
				description: 'Periods in ' , source ].
		node1 children with: node2 children do: checker ].
	checker value: original value: other
]
