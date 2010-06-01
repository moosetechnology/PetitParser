"
A parser that accepts a single literal object, such as a character. This is the same as the predicate parser 'PPPredicateParser expect: literal' but slightly more efficient.
"
Class {
	#name : #PPLiteralObjectParser,
	#superclass : #PPLiteralParser,
	#category : #'PetitParser-Parsers'
}

{ #category : #operators }
PPLiteralObjectParser >> caseInsensitive [
	"Answer a parser that can parse the receiver case-insensitive."
	
	^ PPPredicateParser on: [ :value | literal sameAs: value ] message: message
]

{ #category : #operators }
PPLiteralObjectParser >> negate [
	"Answer a parser that is the negation of the receiving literal parser."
	
	^ PPPredicateParser 
		on: [ :each | each ~= literal ] message: 'no ' , message
		negated: [ :each | each = literal ] message: message
]

{ #category : #parsing }
PPLiteralObjectParser >> parseOn: aStream [
	^ (aStream atEnd not and: [ aStream peek = literal ])
		ifFalse: [ PPFailure message: message at: aStream position ]
		ifTrue: [ aStream next ]
]
