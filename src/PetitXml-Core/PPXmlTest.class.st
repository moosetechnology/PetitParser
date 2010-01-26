Class {
	#name : #PPXmlTest,
	#superclass : #TestCase,
	#instVars : [
		'result'
	],
	#category : #'PetitXml-Tests'
}

{ #category : #testing }
PPXmlTest class >> isAbstract [
	^ self name ~= #PPXmlGrammarTest
]

{ #category : #accessing }
PPXmlTest class >> packageNamesUnderTest [
	^ #('PetitXml')
]

{ #category : #accessing }
PPXmlTest class >> resources [
	^ Array with: PPXmlResource
]

{ #category : #parsing }
PPXmlTest >> parse: aString [
	self parse: aString rule: #start
]

{ #category : #parsing }
PPXmlTest >> parse: aString rule: aSymbol [ 
	| production |
	production := self parser.
	aSymbol = #start 
		ifFalse: [ production := production instVarNamed: aSymbol ].
	result := production end
		parse: aString asParserStream.
	self 
		deny: result isFailure
		description: 'Unable to parse ' , aString printString
]

{ #category : #accessing }
PPXmlTest >> parser [
	^ self resource parserAt: self parserClass
]

{ #category : #accessing }
PPXmlTest >> parserClass [
	self subclassResponsibility
]

{ #category : #accessing }
PPXmlTest >> resource [
	^ PPXmlResource current
]
