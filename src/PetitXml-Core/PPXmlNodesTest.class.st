Class {
	#name : #PPXmlNodesTest,
	#superclass : #PPXmlTest,
	#category : #'PetitXml-Tests'
}

{ #category : #'as yet unclassified' }
PPXmlNodesTest >> testAccessAttribute [
	self
		assert: ((self parse: '<description key="value">content</description>') rootElement attributeAt: 'key') value
		equals: 'value'
]
