"
A parser that consumes nothing and always fails.
"
Class {
	#name : #PPFailingParser,
	#superclass : #PPParser,
	#instVars : [
		'message'
	],
	#category : #'PetitParser-Core'
}

{ #category : #'instance-creation' }
PPFailingParser class >> message: aString [
	^ self new message: aString
]

{ #category : #parsing }
PPFailingParser >> basicParse: aStream [
	^ PPFailure reason: message at: aStream position
]

{ #category : #accessing }
PPFailingParser >> message: aString [
	message := aString
]