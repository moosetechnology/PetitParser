Class {
	#name : #PPTrimmingSpaceParser,
	#superclass : #PPTrimmingParser,
	#category : #'PetitParser-Parsers'
}

{ #category : #private }
PPTrimmingSpaceParser >> consumeSpaces: aStream [
	[ aStream atEnd not and: [
		| character |
		character := aStream peek.
		(character = Character space) or: [ character = Character tab ] ] ]
		whileTrue: [ aStream next ]
]

{ #category : #operations }
PPTrimmingSpaceParser >> trimSpace [
	"There is no point in trimming more than once."

	^ self
]
