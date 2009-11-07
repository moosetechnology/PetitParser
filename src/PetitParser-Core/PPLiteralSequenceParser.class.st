"
A parser accepts a squence of literal objects, such as a String. This is an optimization to avoid having to compose longer sequences from PPSequenceParser.
"
Class {
	#name : #PPLiteralSequenceParser,
	#superclass : #PPLiteralParser,
	#instVars : [
		'sequence'
	],
	#category : #'PetitParser-Core'
}

{ #category : #parsing }
PPLiteralSequenceParser >> parse: aStream [
	| position result |
	position := aStream position.
	result := aStream next: literal size.
	result = literal ifTrue: [ ^ result ].
	aStream position: position.
	^ PPFailure reason: literal asString , ' expected' at: position
]
