"
A parser accepts a sequence of literal objects, such as a String. This is an optimization to avoid having to compose longer sequences from PPSequenceParser.
"
Class {
	#name : #PPLiteralSequenceParser,
	#superclass : #PPLiteralParser,
	#instVars : [
		'size'
	],
	#category : #'PetitParser-Parsers'
}

{ #category : #operators }
PPLiteralSequenceParser >> caseInsensitive [
	"Answer a parser that can parse the receiver case-insensitive."
	
	^ [ :stream |
		| result |
		(literal sameAs: (result := stream next: size))
			ifFalse: [ PPFailure message: message at: stream position ]
			ifTrue: [ result ] ] asParser
]

{ #category : #initialization }
PPLiteralSequenceParser >> initializeOn: anObject message: aString [
	super initializeOn: anObject message: aString.
	size := literal size
]

{ #category : #parsing }
PPLiteralSequenceParser >> parseOn: aStream [
	| position result |
	position := aStream position.
	result := aStream next: size.
	result = literal ifTrue: [ ^ result ].
	aStream position: position.
	^ PPFailure message: message at: position
]
