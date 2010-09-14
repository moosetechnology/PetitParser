Class {
	#name : #PPXmlTest,
	#superclass : #TestCase,
	#category : #'PetitXml-Tests'
}

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
	^ production end parse: aString
]

{ #category : #accessing }
PPXmlTest >> parser [
	^ self resource parserAt: self parserClass
]

{ #category : #accessing }
PPXmlTest >> parserClass [
	^ PPXmlParser
]

{ #category : #accessing }
PPXmlTest >> resource [
	^ PPXmlResource current
]
