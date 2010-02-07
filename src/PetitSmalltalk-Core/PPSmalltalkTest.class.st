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
	^ Array with: PPSmalltalkResource
]

{ #category : #parsing }
PPSmalltalkTest >> parse: aString rule: aSymbol [ 
	| production |
	production := self parser.
	aSymbol = #start 
		ifFalse: [ production := production instVarNamed: aSymbol ].
	result := production end
		parse: aString asPetitStream.
	self 
		deny: result isPetitFailure
		description: 'Unable to parse ' , aString printString
]

{ #category : #accessing }
PPSmalltalkTest >> parser [
	^ PPSmalltalkResource current parserAt: self parserClass
]

{ #category : #accessing }
PPSmalltalkTest >> parserClass [
	self subclassResponsibility
]
