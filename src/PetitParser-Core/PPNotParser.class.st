"
The npt-predicate, a parser that succeeds whenever its delegate does not, but consumes no input [Parr 1994, 1995].
"
Class {
	#name : #PPNotParser,
	#superclass : #PPAndParser,
	#category : #'PetitParser-Core'
}

{ #category : #operations }
PPNotParser >> not [
	^ parser
]

{ #category : #parsing }
PPNotParser >> parse: aStream [
	| element |
	element := super parse: aStream.
	^ element isFailure ifFalse: [ PPFailure at: aStream position ]
]
