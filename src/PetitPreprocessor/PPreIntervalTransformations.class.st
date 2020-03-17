Class {
	#name : #PPreIntervalTransformations,
	#superclass : #PPreStreamTransformation,
	#instVars : [
		'intervals'
	],
	#category : #'PetitPreprocessor-Core'
}

{ #category : #adding }
PPreIntervalTransformations >> addTransformation: aTransformation [
	self intervals addLast: aTransformation
]

{ #category : #initialization }
PPreIntervalTransformations >> initialize [
	super initialize.
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
	self intervals do: [ :anInterval | aStream print: anInterval ].
	aStream nextPut: $}
]

{ #category : #position }
PPreIntervalTransformations >> relativePosition: aPosition [
	| decalage |
	decalage := 0.
	intervals select: [ :aTransformation | aTransformation concerns: aPosition ] thenDo: [ :aTransformation | decalage := decalage + aTransformation decalage ].
	^ aPosition - decalage + relativeStreamStartPosition
]
