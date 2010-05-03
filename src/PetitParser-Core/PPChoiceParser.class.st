"
A parser that uses the first parser that succeeds.
"
Class {
	#name : #PPChoiceParser,
	#superclass : #PPListParser,
	#category : #'PetitParser-Core'
}

{ #category : #operations }
PPChoiceParser >> / aRule [ 
	^ self copyWith: aRule
]

{ #category : #parsing }
PPChoiceParser >> parseOn: aStream [
	"When encountering failures while parsing a choice report the right most error."

	| failure element |
	failure := nil.
	1 to: parsers size do: [ :index |
		element := (parsers at: index)
			parseOn: aStream.
		element isPetitFailure 
			ifFalse: [ ^ element ].
		(failure isNil or: [ failure position < element position ])
			ifTrue: [ failure := element ] ].
	^ failure
]
