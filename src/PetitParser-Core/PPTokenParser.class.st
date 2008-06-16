Class {
	#name : #PPTokenParser,
	#superclass : #PPFlattenParser,
	#category : #'PetitParser-Core'
}

{ #category : #hooks }
PPTokenParser >> create: aCollection start: aStartInteger stop: aStopInteger [
	^ PPToken on: aCollection start: aStartInteger stop: aStopInteger
]
