Class {
	#name : #PPFailure,
	#superclass : #Object,
	#instVars : [
		'reason',
		'position'
	],
	#category : #'PetitParser-Core'
}

{ #category : #'instance-creation' }
PPFailure class >> reason: aString [
	^ self basicNew reason: aString
]

{ #category : #'instance-creation' }
PPFailure class >> reason: aString at: anInteger [
	^ self basicNew reason: aString; position: anInteger
]

{ #category : #testing }
PPFailure >> isFailure [
	^ true
]

{ #category : #accessing }
PPFailure >> position [
	^ position
]

{ #category : #accessing }
PPFailure >> position: anInteger [
	position := anInteger
]

{ #category : #printing }
PPFailure >> printOn: aStream [
	aStream nextPutAll: reason.
	position isNil 
		ifFalse: [ aStream nextPutAll: ' at '; print: position ]
]

{ #category : #accessing }
PPFailure >> reason [
	^ reason
]

{ #category : #accessing }
PPFailure >> reason: aString [
	reason := aString
]
