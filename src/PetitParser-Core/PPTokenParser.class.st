"
A parser that produces a token from the range my delegate parses.
"
Class {
	#name : #PPTokenParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Core'
}

{ #category : #parsing }
PPTokenParser >> parse: aStream [
	| position element |
	position := aStream position.
	element := super parse: aStream.
	element isFailure ifTrue: [ ^ element ].
	^ aStream collection sliceFrom: position + 1 to: aStream position
]
