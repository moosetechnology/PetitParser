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
PPEndOfInputParser >> parse: aStream [
	| position result |
	position := aStream position.
	result := super parse: aStream.
	(result isFailure or: [ aStream atEnd ])
		ifTrue: [ ^ result ].
	result := PPFailure reason: 'end of input expected' at: aStream position.
	aStream position: position.
	^ result
]
