Class {
	#name : #PPCharacterLiteral,
	#superclass : #PPLiteral,
	#category : #'PetitParser-Core'
}

{ #category : #parsing }
PPCharacterLiteral >> parse: aStream [
	^ aStream peek = value
		ifTrue: [ aStream next ]
		ifFalse: [ PPFail reason: value printString , ' expected' ]
]
