"
The failure object in PetitParser. It is the only class that responds to #isPetitFailure with true. It contains an error message and a position of the occurence of the failure.
"
Class {
	#name : #PPFailure,
	#superclass : #Object,
	#instVars : [
		'message',
		'position'
	],
	#category : #'PetitParser-Core'
}

{ #category : #'instance creation' }
PPFailure class >> message: aString at: anInteger [
	^ self basicNew initializeMessage: aString at: anInteger
]

{ #category : #initialization }
PPFailure >> initializeMessage: aString at: anInteger [
	message := aString.
	position := anInteger
]

{ #category : #testing }
PPFailure >> isPetitFailure [
	"I am the only class that should implement this method to return true."

	^ true
]

{ #category : #accessing }
PPFailure >> message [
	"Answer a human readable error message of this parse failure."
	
	^ message
]

{ #category : #accessing }
PPFailure >> position [
	"Answer the position in the source string that caused this parse failure."

	^ position
]

{ #category : #printing }
PPFailure >> printOn: aStream [
	aStream nextPutAll: self message; nextPutAll: ' at '; print: position
]
