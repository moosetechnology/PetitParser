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

{ #category : #accessing }
PPXmlData >> data [
	^ data
]

{ #category : #accessing }
PPXmlData >> data: aString [
	data := aString
]
