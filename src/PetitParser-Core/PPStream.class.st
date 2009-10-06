Class {
	#name : #PPStream,
	#superclass : #ReadStream,
	#category : #'PetitParser-Core'
}

{ #category : #converting }
PPStream >> asParserStream [
	^ self
]

{ #category : #accessing }
PPStream >> next: anInteger [ 
	"Answer up to anInteger elements of my collection.  overriden for efficiency"

	| ans endPosition |
	endPosition := position + anInteger  min:  readLimit.
	ans := collection copyFrom: position+1 to: endPosition.
	position := endPosition.
	^ans

]

{ #category : #accessing }
PPStream >> peek [
	"An improved version of peek, that is slightly faster than the built in version."

	^ self atEnd ifFalse: [ collection at: position + 1 ]
]

{ #category : #printing }
PPStream >> printOn: aStream [
	aStream 
		nextPutAll: (collection copyFrom: 1 to: position);
		nextPutAll: '·';
		nextPutAll: (collection copyFrom: position + 1 to: readLimit)
]
