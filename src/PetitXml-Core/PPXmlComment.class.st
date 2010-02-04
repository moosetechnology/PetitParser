"
An XML comment node.
"
Class {
	#name : #PPXmlComment,
	#superclass : #PPXmlData,
	#category : #'PetitXml-Core'
}

{ #category : #printing }
PPXmlComment >> printXmlOn: aStream [
	aStream nextPutAll: '<!--'; nextPutAll: data; nextPutAll: '-->'
]
