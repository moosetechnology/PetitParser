Class {
	#name : #PPreStreamTransformation,
	#superclass : #Object,
	#instVars : [
		'relativeStreamStartPosition'
	],
	#category : #'PetitPreprocessor-Core'
}

{ #category : #'as yet unclassified' }
PPreStreamTransformation class >> startingAt: aPosition [
	^ self new relativeStreamStartPosition: aPosition 
]

{ #category : #'as yet unclassified' }
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
