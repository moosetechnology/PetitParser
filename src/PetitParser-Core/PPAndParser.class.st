"
The and-predicate, a parser that suceeds whenever its delegate does, but consumes no input [Parr 1994, 1995].
"
Class {
	#name : #PPAndParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Core'
}

{ #category : #parsing }
PPAndParser >> basicParse: aStream [
	| element position |
	position := aStream position.
	element := super basicParse: aStream.
	aStream position: position.
	^ element
]
