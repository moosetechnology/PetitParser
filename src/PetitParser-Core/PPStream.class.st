"
A positional stream implementation used for parsing. It overrides some methods for optimization reasons.
"
Class {
	#name : #PPStream,
	#superclass : #ReadStream,
	#category : #'PetitParser-Core'
}

{ #category : #converting }
PPStream >> asPetitStream [
	^ self
]

{ #category : #accessing }
PPStream >> peek [
	"An improved version of peek, that is slightly faster than the built in version."

	^ self atEnd ifFalse: [ collection at: position + 1 ]
]

{ #category : #accessing }
PPStream >> position: anInteger [
	"The receiver does not check for invalid arguments passed to this method, as it is solely used with valid indexes for backtracking."

	position := anInteger
]

{ #category : #printing }
PPStream >> printOn: aStream [
	collection isString
		ifFalse: [ ^ super printOn: aStream ].
	aStream
		nextPutAll: (collection copyFrom: 1 to: position);
		nextPutAll: '·';
		nextPutAll: (collection copyFrom: position + 1 to: readLimit)
]

{ #category : #accessing }
PPStream >> uncheckedPeek [
	"An unchecked version of peek that throws an error if we try to peek over the end of the stream, even faster than #peek."

	^ collection at: position + 1
]
