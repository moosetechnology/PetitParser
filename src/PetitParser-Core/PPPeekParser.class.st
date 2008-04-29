"
I peek at the input but do not consume it.
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
