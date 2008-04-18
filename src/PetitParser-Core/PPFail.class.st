Class {
	#name : #PPFail,
	#superclass : #Object,
	#instVars : [
		'message',
		'reason'
	],
	#category : #'PetitParser-Core'
}

{ #category : #'instance-creation' }
PPFail class >> reason: aString [
	^ self basicNew setReason: aString
]

{ #category : #printing }
PPFail >> printOn: aStream [
	aStream nextPutAll: reason
]

{ #category : #'initialize-release' }
PPFail >> setReason: aString [
	reason := aString
]
