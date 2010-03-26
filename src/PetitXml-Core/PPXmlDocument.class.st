"
An XML root node.
"
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
PPXmlDocument >> childNodes [
	^ Array with: self rootElement
]

{ #category : #accessing }
PPXmlDocument >> documentType [
	^ documentType
]

{ #category : #comparing }
PPXmlDocument >> hash [
	^ self rootElement hash
]

{ #category : #testing }
PPXmlDocument >> isDocument [
	^ true
]

{ #category : #copying }
PPXmlDocument >> postCopy [
	super postCopy.
	self setXmlDeclaration: self xmlDeclaration copy.
	self setRootElement: self rootElement copy
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

{ #category : #initialization }
PPXmlDocument >> setDocumentType: aString [
	documentType := aString
]

{ #category : #initialization }
PPXmlDocument >> setRootElement: anElement [
	rootElement := anElement setParent: self
]

{ #category : #initialization }
PPXmlDocument >> setXmlDeclaration: aProcessing [
	xmlDeclaration := aProcessing
]

{ #category : #accessing }
PPXmlDocument >> xmlDeclaration [
	^ xmlDeclaration
]
