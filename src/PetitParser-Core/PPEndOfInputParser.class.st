"
A parser that succeeds only at the end of the input stream.
"
Class {
	#name : #PPEndOfInputParser,
	#superclass : #PPParser,
	#category : #'PetitParser-Core'
}

{ #category : #parsing }
PPEndOfInputParser >> basicParse: aStream [
	^ aStream atEnd 
		ifFalse: [ PPFailure reason: 'end of input expected' at: aStream position ]
]
