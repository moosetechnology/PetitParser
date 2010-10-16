Class {
	#name : #PPMSEGrammarTest,
	#superclass : #PPCompositeParserTest,
	#category : #PetitMSE
}

{ #category : #accessing }
PPMSEGrammarTest >> parserClass [
	^ PPMSEGrammar
]

{ #category : #testing }
PPMSEGrammarTest >> testStringEscape [
	self parse: '''It''''s here''' rule: #string
]
