Class {
	#name : #PPXmlXsdGrammarTest,
	#superclass : #PPXmlTest,
	#category : #'PetitXml-Tests'
}

{ #category : #'as yet unclassified' }
PPXmlXsdGrammarTest >> parserClass [
	^ PPXmlXsdGrammar
]

{ #category : #'as yet unclassified' }
PPXmlXsdGrammarTest >> testParseAll [
	self resource allXsdDefinitions 
		do: [ :each | self parse: each ]
]
