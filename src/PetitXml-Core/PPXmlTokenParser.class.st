Class {
	#name : #PPXmlTokenParser,
	#superclass : #PPFlattenParser,
	#category : #'PetitXml-Core'
}

{ #category : #hooks }
PPXmlTokenParser >> create: aCollection start: aStartInteger stop: aStopInteger [
	^ PPToken on: aCollection start: aStartInteger stop: aStopInteger
]
