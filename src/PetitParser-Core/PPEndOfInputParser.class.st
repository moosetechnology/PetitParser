"
A parser that succeeds only at the end of the input stream.
"
Class {
	#name : #PPEndOfInputParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Core'
}

{ #category : #parsing }
PPEndOfInputParser >> basicParse: aStream [
	| position result |
	position := aStream position.
	result := super basicParse: aStream.
	(result isFailure or: [ aStream atEnd ])
		ifTrue: [ ^ result ].
	aStream position: position.
	^ PPFailure reason: 'end of input expected' at: aStream position
]
