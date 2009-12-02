"
A parser that succeeds only at the end of the input stream.
"
Class {
	#name : #PPEndOfInputParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Core'
}

{ #category : #parsing }
PPEndOfInputParser >> parse: aStream [
	| position result |
	position := aStream position.
	result := super parse: aStream.
	(result isFailure or: [ aStream atEnd ])
		ifFalse: [ result := PPFailure reason: 'end of input expected' at: aStream position ].
	(result isFailure)
		ifTrue: [ aStream position: position ].
	^ result
]
