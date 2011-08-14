"
A parser that optionally parsers its delegate, or answers nil.
"
Class {
	#name : #PPOptionalParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Parsers'
}

{ #category : #parsing }
PPOptionalParser >> parseOn: aStream [
	| element |
	element := parser parseOn: aStream.
	^ element isPetitFailure ifFalse: [ element ]
]
