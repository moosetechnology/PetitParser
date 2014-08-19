"
A parser that optionally parsers its delegate, or answers nil.
"
Class {
	#name : #PPOptionalParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Parsers'
}

{ #category : #'pp-context' }
PPOptionalParser >> parseOn: aPPContext [
	| element |
	element := parser parseOn: aPPContext.
	^ element isPetitFailure ifFalse: [ element ]
]
