Class {
	#name : #PPGrammarTest,
	#superclass : #TestCase,
	#instVars : [
		'result'
	],
	#category : #'PetitSmalltalk-Tests'
}

{ #category : #testing }
PPGrammarTest class >> isAbstract [
	^ self name = #PPGrammarTest
]

{ #category : #accessing }
PPGrammarTest class >> packageNamesUnderTest [
	^ #('PetitSmalltalk')
]

{ #category : #accessing }
PPGrammarTest class >> resources [
	^ Array with: PPGrammarResource
]

{ #category : #parsing }
PPGrammarTest >> parse: aString rule: aSymbol [ 
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
PPGrammarTest >> parser [
	^ PPGrammarResource current parserAt: self parserClass
]

{ #category : #accessing }
PPGrammarTest >> parserClass [
	self subclassResponsibility
]
