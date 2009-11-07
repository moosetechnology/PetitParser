"
A parser that accepts a single literal object, such as a character. This is the same as the predicate parser PPPredicateParser expect: literal, but slightly faster.
"
Class {
	#name : #PPLiteralObjectParser,
	#superclass : #PPLiteralParser,
	#category : #'PetitParser-Core'
}

{ #category : #operator }
PPLiteralObjectParser >> negate [
	^ (PPPredicateParser expect: literal) negate
]

{ #category : #parsing }
PPLiteralObjectParser >> parse: aStream [
	^ (aStream atEnd not and: [ aStream peek = literal ])
		ifFalse: [ PPFailure reason: literal asString , ' expected' at: aStream position ]
		ifTrue: [ aStream next ]
]