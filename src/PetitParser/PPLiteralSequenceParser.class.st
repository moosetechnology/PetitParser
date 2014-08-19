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
	
	literal asUppercase = literal asLowercase ifTrue: [ ^ self ].
	^ PPPredicateSequenceParser on: [ :value | literal sameAs: value ] message: message size: size
]

{ #category : #initialization }
PPLiteralSequenceParser >> initializeOn: anObject message: aString [
	super initializeOn: anObject message: aString.
	size := literal size
]

{ #category : #'pp-context' }
PPLiteralSequenceParser >> parseOn: aPPContext [
	| position result |
	position := aPPContext remember.
	result := aPPContext stream next: size.
	literal = result ifTrue: [ ^ result ].
	aPPContext restore: position.
	^ PPFailure message: message at: aPPContext stream position
]

{ #category : #accessing }
PPLiteralSequenceParser >> size [
	"Answer the sequence size of the receiver."

	^ size
]
