Class {
	#name : #PPreStreamTransformation,
	#superclass : #Object,
	#instVars : [
		'relativeStreamStartPosition'
	],
	#category : #'PetitPreprocessor-Core'
}

{ #category : #'instance creation' }
PPreStreamTransformation class >> startingAt: aPosition [
	^ self new relativeStreamStartPosition: aPosition 
]

{ #category : #position }
PPreStreamTransformation >> relativePosition: aPosition [
	self subclassResponsibility 
]

{ #category : #accessing }
PPreStreamTransformation >> relativeStreamStartPosition [
	^ relativeStreamStartPosition
]

{ #category : #accessing }
PPreStreamTransformation >> relativeStreamStartPosition: anObject [
	relativeStreamStartPosition := anObject
]
