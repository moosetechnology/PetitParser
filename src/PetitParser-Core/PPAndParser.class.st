"
The and-predicate, a parser that succeeds whenever its delegate does, but consumes the input stream [Parr 1994, 1995].
"
Class {
	#name : #PPAndParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Core'
}

{ #category : #operations }
PPAndParser >> and [
	^ self
]

{ #category : #parsing }
PPAndParser >> parseOn: aStream [
	| element position |
	position := aStream position.
	element := super parseOn: aStream.
	aStream position: position.
	^ element
]
