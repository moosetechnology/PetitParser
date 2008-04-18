"
A parser that does nothing and always succeeds.
"
Class {
	#name : #PPEpsilon,
	#superclass : #PPParser,
	#category : #'PetitParser-Core'
}

{ #category : #parsing }
PPEpsilon >> parse: aStream [
	^ nil
]
