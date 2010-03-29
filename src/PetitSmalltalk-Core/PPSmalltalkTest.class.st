Class {
	#name : #PPSmalltalkTest,
	#superclass : #TestCase,
	#instVars : [
		'result'
	],
	#category : #'PetitSmalltalk-Tests'
}

{ #category : #testing }
PPSmalltalkTest class >> isAbstract [
	^ self name = #PPSmalltalkTest
]

{ #category : #accessing }
PPSmalltalkTest class >> packageNamesUnderTest [
	^ #('PetitSmalltalk')
]

{ #category : #accessing }
PPSmalltalkTest class >> resources [
	^ Array with: PPParserResource
]

{ #category : #parsing }
PPSmalltalkTest >> parse: aString rule: aSymbol [ 
	| production |
	production := self parserInstance
		productionAt: aSymbol.
	result := production end 
		parse: aString.
	self
		deny: result isPetitFailure
		description: 'Unable to parse ' , aString printString
]

{ #category : #accessing }
PPSmalltalkTest >> parserClass [
	self subclassResponsibility
]

{ #category : #accessing }
PPSmalltalkTest >> parserInstance [
	^ PPParserResource current parserAt: self parserClass
]
