"
An XML root node.
"
Class {
	#name : #PPXmlDocument,
	#superclass : #PPXmlParent,
	#instVars : [
		'xmlDeclaration',
		'documentType',
		'rootElement'
	],
	#category : #'PetitXml-Nodes'
}

{ #category : #accessing }
PPXmlDocument >> document [
	^ self
]

{ #category : #accessing }
PPXmlDocument >> documentType [
	^ documentType
]

{ #category : #testing }
PPXmlDocument >> isDocument [
	^ true
]

{ #category : #accessing }
PPXmlDocument >> rootElement [
	^ rootElement
]

{ #category : #accessing }
PPXmlDocument >> xmlDeclaration [
	^ xmlDeclaration
]
