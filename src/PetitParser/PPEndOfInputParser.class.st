"
A parser that succeeds only at the end of the input stream.
"
Class {
	#name : #PPEndOfInputParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Parsers'
}

{ #category : #operators }
PPEndOfInputParser >> end [
	^ self
]

{ #category : #'pp-context' }
PPEndOfInputParser >> parseOn: aPPContext [
	| position result |
	position := aPPContext remember.
	result := parser parseOn: aPPContext.
	(result isPetitFailure or: [ aPPContext stream atEnd ])
		ifTrue: [ ^ result ].
	result := PPFailure
		message: 'end of input expected'
		at: aPPContext stream position.
	aPPContext restore: position.
	^ result
]
