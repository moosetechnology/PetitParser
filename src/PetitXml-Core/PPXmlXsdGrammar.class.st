Class {
	#name : #PPXmlXsdGrammar,
	#superclass : #PPXmlGrammar,
	#category : #'PetitXml-Core'
}

{ #category : #'as yet unclassified' }
PPXmlXsdGrammar >> parserForRootElement [
	^ (self parserForOpenTag: nameToken attributes: attributes) and ==> [ :nodes | self halt ]
]
