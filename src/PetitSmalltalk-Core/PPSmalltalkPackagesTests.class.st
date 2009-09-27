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
	#name : #PPSmalltalkPackagesTests,
	#superclass : #PPGrammarTest,
	#category : #'PetitSmalltalk-Tests'
}

{ #category : #private }
PPSmalltalkPackagesTests >> assert: aBoolean description: aString [ 
	self 
		assert: aBoolean
		description: aString
		resumable: true
]

{ #category : #accessing }
PPSmalltalkPackagesTests >> parserClass [
	^ PPSmalltalkCompiler
]

{ #category : #testing }
PPSmalltalkPackagesTests >> testBoolean [
	self verifyClass: Boolean.
	self verifyClass: True.
	self verifyClass: False
]

{ #category : #testing }
PPSmalltalkPackagesTests >> testCollection [
	self verifyClass: Collection.
	self verifyClass: Array.
	self verifyClass: Set.
	self verifyClass: Dictionary.
	self verifyClass: Bag.
	self verifyClass: OrderedCollection.
	self verifyClass: SortedCollection
]

{ #category : #testing }
PPSmalltalkPackagesTests >> testMagnitude [
	self verifyClass: Magnitude.
	self verifyClass: Point.
	self verifyClass: Integer.
	self verifyClass: SmallInteger.
	self verifyClass: Fraction.
	self verifyClass: Float
]

{ #category : #testing }
PPSmalltalkPackagesTests >> testObject [
	self verifyClass: Object.
	self verifyClass: ProtoObject
]

{ #category : #private }
PPSmalltalkPackagesTests >> verifyClass: aClass [ 
	aClass selectors 
		do: 
			[ :selector | 
			self 
				verifyClass: aClass
				selector: selector ]
		displayingProgress: aClass name
]

{ #category : #private }
PPSmalltalkPackagesTests >> verifyClass: aClass selector: aSelector [ 
	"Verifies that the method aSelector in aClass parses the same using the standard refactoring parser and the language boxes parser. Methods that contain float literals are ignored, since they do not reproduce well. Furthermore methods with pragmas are not actually compared as they might pretty print differently."
	| source original other |
	source := aClass sourceCodeAt: aSelector.
	source isNil ifTrue: [ ^ self ].
	original := aClass parseTreeFor: aSelector.
	original isNil ifTrue: [ ^ self ].
	original nodesDo: [ :each | each comments: nil ].
	other := self parser parse: source asParserStream.
	source := aClass name , '>>#' , source.
	other isFailure 
		ifTrue: 
			[ self 
				assert: false
				description: source ]
		ifFalse: 
			[ (other pragmas isEmpty and: 
				[ ((aClass compiledMethodAt: aSelector) hasLiteralSuchThat: [ :literal | literal isFloat ]) not ]) ifTrue: 
				[ self 
					assert: original formattedCode = other formattedCode
					description: source ] ]
]

{ #category : #private }
PPSmalltalkPackagesTests >> verifyPackage: aString [ 
	| package |
	package := PackageInfo named: aString.
	package classesAndMetaClasses 
		do: [ :each | self verifyClass: each ]
		displayingProgress: aString
]
