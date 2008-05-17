Class {
	#name : #PPTokenParser,
	#superclass : #PPFlattenParser,
	#category : #'PetitParser-Core'
}

{ #category : #hooks }
PPTokenParser >> create: aCollection from: aStartInteger to: aStopInteger [
	^ aCollection sliceFrom: aStartInteger to: aStopInteger
]
