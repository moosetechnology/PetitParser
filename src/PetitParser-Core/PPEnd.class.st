"
A parser that succeeds if we are at the end of the input stream.
"
Class {
	#name : #PPEnd,
	#superclass : #PPParser,
	#category : #'PetitParser-Core'
}

{ #category : #parsing }
PPEnd >> parse: aStream [
	^ aStream atEnd ifFalse: [ PPFail reason: 'End expected' ]
]
