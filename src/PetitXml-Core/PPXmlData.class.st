"
An abstract XML data node.
"
Class {
	#name : #PPXmlData,
	#superclass : #PPXmlNode,
	#instVars : [
		'data'
	],
	#category : #'PetitXml-Core'
}

{ #category : #'instance creation' }
PPXmlData class >> data: aString [
	^ self new data: aString
]

{ #category : #comparing }
PPXmlData >> = anXmlNode [
	self == anXmlNode
		ifTrue: [ ^ true ].
	self class = anXmlNode class
		ifFalse: [ ^ false ].
	^ self data = anXmlNode data
]

{ #category : #accessing }
PPXmlData >> data [
	^ data
]

{ #category : #accessing }
PPXmlData >> data: aString [
	data := aString
]
