Class {
	#name : #PPXmlNodesTest,
	#superclass : #PPXmlTest,
	#category : #'PetitXml-Tests'
}

{ #category : #testing }
PPXmlNodesTest >> testAccessAttribute [
	self
		assert: ((self parse: '<description key="value">content</description>') rootElement attributeAt: 'key') value
		equals: 'value'
]

{ #category : #testing }
PPXmlNodesTest >> testHasSubElements [
	self deny: (self parse: '<description key="value">content</description>') rootElement hasSubElements.
	self assert: (self parse: '<foo><bar>val</bar></foo>') rootElement hasSubElements
]
