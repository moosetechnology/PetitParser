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
	#superclass : #PPGrammarTest,
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
	^ PPSmalltalkAstor
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

{ #category : #testing }
PPSmalltalkClassesTests >> testStream [
	self verifyClass: Stream.
	self verifyClass: ReadStream.
	self verifyClass: WriteStream
]

{ #category : #private }
PPSmalltalkClassesTests >> verifyClass: aClass [ 
	aClass selectors 
		do: [ :selector | self verifyClass: aClass selector: selector ]
		displayingProgress: aClass name.
	aClass isMeta
		ifFalse: [ self verifyClass: aClass class ]
]

{ #category : #private }
PPSmalltalkClassesTests >> verifyClass: aClass selector: aSelector [ 
	"Verifies that the method aSelector in aClass parses the same using the standard refactoring parser and the petit smalltalk parser. Also make sure that the position information of all tokens is equal."

	| source original other |
	source := aClass sourceCodeAt: aSelector.
	source isNil ifTrue: [ ^ self ].
	original := aClass parseTreeFor: aSelector.
	original isNil ifTrue: [ ^ self ].
	original nodesDo: [ :each | each comments: nil ].
	other := self parser parse: source asParserStream.
	source := aClass name , '>>#' , original selector.
	other isFailure 
		ifTrue: [ self assert: false description: source ]
		ifFalse: [ self assert: original formattedCode = other formattedCode description: source ].
	original nodesDo: [ :originalNode |
		(originalNode isSequence or: [ originalNode isPragma or: [ originalNode parent notNil and: [ originalNode parent isCascade or: [ originalNode parent isPragma ] ] ] ]) ifFalse: [
			| otherNode |
			otherNode := other whichNodeIsContainedBy: originalNode sourceInterval.
			self assert: (originalNode = otherNode or: [ originalNode = otherNode parent ]) ] ]
]
