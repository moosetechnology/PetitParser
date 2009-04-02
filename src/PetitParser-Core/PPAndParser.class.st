"
The and-predicate, a parser that suceeds whenever its delegate does, but consumes no input [Parr 1994, 1995].
"
Class {
	#name : #PPAndParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Core'
}

{ #category : #parsing }
PPAndParser >> parse: aStream [
	| element position |
	position := aStream position.
	element := super parse: aStream.
	aStream position: position.
	^ element
]
