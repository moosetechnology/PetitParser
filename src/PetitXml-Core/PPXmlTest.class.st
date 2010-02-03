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
	^ self name = #PPXmlTest
]

{ #category : #accessing }
PPXmlTest class >> packageNamesUnderTest [
	^ #('PetitXml')
]

{ #category : #accessing }
PPXmlTest class >> resources [
	^ Array with: PPXmlResource
]

{ #category : #utilities }
PPXmlTest >> assertInvariant: aString [
	| dom string |
	dom := self parse: aString.
	self
		deny: dom isFailure
		description: dom printString.
	string := String
		streamContents: [ :out | dom printXmlOn: out ].
	self
		assert: (self parse: string) = dom
		description: 'Invariant not satisfied'
]

{ #category : #parsing }
PPXmlTest >> parse: aString [
	^ self parse: aString rule: #start
]

{ #category : #parsing }
PPXmlTest >> parse: aString rule: aSymbol [ 
	| production |
	production := self parser.
	aSymbol = #start 
		ifFalse: [ production := production instVarNamed: aSymbol ].
	^ production end
		parse: aString asParserStream
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
