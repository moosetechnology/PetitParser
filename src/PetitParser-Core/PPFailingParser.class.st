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

{ #category : #accessing }
PPFailingParser >> message: aString [
	message := aString
]

{ #category : #parsing }
PPFailingParser >> parse: aStream [
	^ PPFailure reason: message position: aStream position
]
