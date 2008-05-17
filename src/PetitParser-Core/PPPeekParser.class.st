"
A parser that peeks at the result of the delegate, but does not consume it.
"
Class {
	#name : #PPPeekParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Core'
}

{ #category : #parsing }
PPPeekParser >> basicParse: aStream [
	| element position |
	position := aStream position.
	element := super basicParse: aStream.
	aStream position: position.
	^ element
]
