Class {
	#name : #PPreIntervalTransformations,
	#superclass : #PPreStreamTransformation,
	#instVars : [
		'intervals'
	],
	#category : #PetitPreprocessor
}

{ #category : #'as yet unclassified' }
PPreIntervalTransformations >> addTransformation: aTransformation [
	self intervals addLast: aTransformation
]

{ #category : #'as yet unclassified' }
PPreIntervalTransformations >> initialize [ 
	intervals := OrderedCollection new
]

{ #category : #accessing }
PPreIntervalTransformations >> intervals [
	^ intervals
]

{ #category : #accessing }
PPreIntervalTransformations >> intervals: anObject [
	intervals := anObject
]

{ #category : #accessing }
PPreIntervalTransformations >> printOn: aStream [
	aStream nextPut: ${.
	 self intervals do: [:anInterval | aStream print: anInterval ].
	aStream nextPut: $}
]

{ #category : #'as yet unclassified' }
PPreIntervalTransformations >> relativePosition: aPosition [
	| decalage |
	decalage:= 0.
	intervals do: [:aTransformation | (aTransformation concerns: aPosition) ifTrue: [decalage := decalage + aTransformation decalage ]].
	^ (aPosition - decalage) + relativeStreamStartPosition
]
