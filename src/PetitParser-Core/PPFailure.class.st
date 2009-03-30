Class {
	#name : #PPFailure,
	#superclass : #Object,
	#instVars : [
		'reason',
		'position'
	],
	#category : #'PetitParser-Core'
}

{ #category : #'instance creation' }
PPFailure class >> at: anInteger [
	^ self basicNew position: anInteger
]

{ #category : #'instance creation' }
PPFailure class >> reason: aString [
	^ self basicNew reason: aString
]

{ #category : #'instance creation' }
PPFailure class >> reason: aString at: anInteger [
	^ self basicNew
		reason: aString;
		position: anInteger;
		yourself
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
	reason isNil
		ifTrue: [ super printOn: aStream ]
		ifFalse: [ aStream nextPutAll: reason ].
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
