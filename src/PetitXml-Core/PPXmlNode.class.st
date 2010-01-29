Class {
	#name : #PPXmlNode,
	#superclass : #Object,
	#instVars : [
		'name',
		'attributes',
		'contents'
	],
	#category : #'PetitXml-Core'
}

{ #category : #printing }
PPXmlNode >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' '.
	self printXmlOn: aStream
]

{ #category : #printing }
PPXmlNode >> printXmlOn: aStream [
	self subclassResponsibility
]
