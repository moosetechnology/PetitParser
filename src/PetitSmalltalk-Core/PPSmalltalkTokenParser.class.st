"
A parser that knows how to skip comments and whitespace in Smalltalk and how to instantiate tokens.
"
Class {
	#name : #PPSmalltalkTokenParser,
	#superclass : #PPTokenParser,
	#category : #'PetitSmalltalk-Core'
}

{ #category : #hooks }
PPSmalltalkTokenParser >> consumeSpaces: aStream [ 
	[ 	super consumeSpaces: aStream.
	  	aStream peek == $" ] whileTrue: [ 
			aStream next.
			[ aStream atEnd not and: [ aStream next = $" ] ] 
				whileFalse ]
]
