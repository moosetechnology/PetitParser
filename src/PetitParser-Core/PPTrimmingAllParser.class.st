Class {
	#name : #PPTrimmingAllParser,
	#superclass : #PPTrimmingParser,
	#category : #'PetitParser-Parsers'
}

{ #category : #private }
PPTrimmingAllParser >> consumeSpaces: aStream [
	[ aStream atEnd not and: [ aStream peek isSeparator ] ]
		whileTrue: [ aStream next ]
]

{ #category : #operations }
PPTrimmingAllParser >> trim [
	"There is no point in trimming more than once."

	^ self
]
