"
A parser that succeeds only at the end of the input stream.
"
Class {
	#name : #PPEndOfInputParser,
	#superclass : #PPParser,
	#category : #'PetitParser-Core'
}

{ #category : #parsing }
PPEndOfInputParser >> parse: aStream [
	^ aStream atEnd 
		ifFalse: [ PPFailure reason: 'end of input expected' position: aStream position ]
]
