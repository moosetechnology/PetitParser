Class {
	#name : #PPXmlDoctype,
	#superclass : #PPXmlData,
	#category : #'PetitXml-Nodes'
}

{ #category : #testing }
PPXmlDoctype >> isComment [
	^ true
]

{ #category : #testing }
PPXmlDoctype >> isDoctype [
	^ true
]

{ #category : #printing }
PPXmlDoctype >> printXmlOn: aStream [
	aStream nextPutAll: '<!DOCTYPE'; nextPutAll: data; nextPut: $>
]
