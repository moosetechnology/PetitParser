"
A parser that always succeeds.
"
Class {
	#name : #PPEpsilonParser,
	#superclass : #PPParser,
	#category : #'PetitParser-Core'
}

{ #category : #parsing }
PPEpsilonParser >> parse: aStream [
	^ nil
]

{ #category : #printing }
PPEpsilonParser >> printOn: aStream [
	aStream nextPut: $ø
]
