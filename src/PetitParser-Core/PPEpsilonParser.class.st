"
A parser that consumes nothing and always succeeds.
"
Class {
	#name : #PPEpsilonParser,
	#superclass : #PPParser,
	#category : #'PetitParser-Core'
}

{ #category : #testing }
PPEpsilonParser >> isNullable [
	^ true
]

{ #category : #testing }
PPEpsilonParser >> isTerminal [
	^ true
]

{ #category : #parsing }
PPEpsilonParser >> parse: aStream [
	^ nil
]
