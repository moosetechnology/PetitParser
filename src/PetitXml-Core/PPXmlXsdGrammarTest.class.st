Class {
	#name : #PPXmlXsdGrammarTest,
	#superclass : #PPXmlTest,
	#category : #'PetitXml-Tests'
}

{ #category : #accessing }
PPXmlXsdGrammarTest >> parserClass [
	^ PPXmlXsdGrammar
]

{ #category : #testing }
PPXmlXsdGrammarTest >> testParseAll [
	self resource allXsdDefinitions
		do: [ :each | self assertParseInvariant: each ]
]
