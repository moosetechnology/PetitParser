"
A parser that succeeds only at the end of the input stream.
"
Class {
	#name : #PPEndOfInputParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Core'
}

{ #category : #operations }
PPEndOfInputParser >> end [
	^ self
]

{ #category : #parsing }
PPEndOfInputParser >> parseOn: aStream [
	| position result |
	position := aStream position.
	result := super parseOn: aStream.
	(result isPetitFailure or: [ aStream atEnd ])
		ifTrue: [ ^ result ].
	result := PPFailure reason: 'end of input expected' at: aStream position.
	aStream position: position.
	^ result
]
