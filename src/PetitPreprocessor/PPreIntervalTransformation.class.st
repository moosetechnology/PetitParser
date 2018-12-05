Class {
	#name : #PPreIntervalTransformation,
	#superclass : #Object,
	#instVars : [
		'sourceInterval',
		'destinationInterval'
	],
	#category : #PetitPreprocessor
}

{ #category : #'as yet unclassified' }
PPreIntervalTransformation class >> from: anInterval to: anotherInterval [
	^ self new sourceInterval: anInterval; destinationInterval: anotherInterval 
]

{ #category : #'as yet unclassified' }
PPreIntervalTransformation >> concerns: aPosition [
	^ (self destinationInterval last <= aPosition)
]

{ #category : #'as yet unclassified' }
PPreIntervalTransformation >> decalage [
	^ destinationInterval size - sourceInterval size 
]

{ #category : #accessing }
PPreIntervalTransformation >> destinationInterval [
	^ destinationInterval
]

{ #category : #accessing }
PPreIntervalTransformation >> destinationInterval: anObject [
	destinationInterval := anObject
]

{ #category : #accessing }
PPreIntervalTransformation >> printOn: aStream [
	aStream nextPut: $[;
		print: sourceInterval;
		nextPutAll: '=>';
		print: destinationInterval;
		nextPut: $]
]

{ #category : #accessing }
PPreIntervalTransformation >> sourceInterval [
	^ sourceInterval
]

{ #category : #accessing }
PPreIntervalTransformation >> sourceInterval: anObject [
	sourceInterval := anObject
]
