Class {
	#name : #PPXmlXsdGrammar,
	#superclass : #PPXmlGrammar,
	#category : #'PetitXml-Core'
}

{ #category : #parsers }
PPXmlXsdGrammar >> parserForRootElement [
	^ self parserForContentTag: 'schema' attributes: attributes content: content
]
