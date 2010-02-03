Class {
	#name : #PPXmlDocument,
	#superclass : #PPXmlNode,
	#instVars : [
		'xmlDeclaration',
		'documentType',
		'rootElement'
	],
	#category : #'PetitXml-Core'
}

{ #category : #comparing }
PPXmlDocument >> = anXmlNode [
	self == anXmlNode
		ifTrue: [ ^ true ].
	self class = anXmlNode class
		ifFalse: [ ^ false ].
	^ self xmlDeclaration = anXmlNode xmlDeclaration 
		and: [ self documentType = anXmlNode documentType
		and: [ self rootElement = anXmlNode rootElement ] ]
]

{ #category : #accessing }
PPXmlDocument >> documentType [
	^ documentType
]

{ #category : #accessing }
PPXmlDocument >> documentType: aString [
	documentType := aString
]

{ #category : #printing }
PPXmlDocument >> printXmlOn: aStream [
	xmlDeclaration printXmlOn: aStream.
	documentType isNil
		ifFalse: [ aStream cr; nextPutAll: documentType ].
	aStream cr.
	rootElement  printXmlOn: aStream
]

{ #category : #accessing }
PPXmlDocument >> rootElement [
	^ rootElement
]

{ #category : #accessing }
PPXmlDocument >> rootElement: anElement [
	rootElement := anElement
]

{ #category : #accessing }
PPXmlDocument >> xmlDeclaration [
	^ xmlDeclaration
]

{ #category : #accessing }
PPXmlDocument >> xmlDeclaration: aProcessing [
	xmlDeclaration := aProcessing
]
