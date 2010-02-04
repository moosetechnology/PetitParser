"
An XML text node.
"
Class {
	#name : #PPXmlText,
	#superclass : #PPXmlData,
	#category : #'PetitXml-Core'
}

{ #category : #printing }
PPXmlText >> printXmlOn: aStream [
	aStream nextPutAll: data
]
