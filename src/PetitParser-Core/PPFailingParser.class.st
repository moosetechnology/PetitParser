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
	^ PPFailure reason: message position: aStream position
]

{ #category : #accessing }
PPFailingParser >> message: aString [
	message := aString
]
