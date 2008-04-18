Class {
	#name : #PPStringLiteral,
	#superclass : #PPLiteral,
	#category : #'PetitParser-Core'
}

{ #category : #parsing }
PPStringLiteral >> parse: aStream [
	| position item |
	position := aStream position.
	item := aStream next: value size.
	item = value ifTrue: [ ^ item ].
	aStream position: position.
	^ PPFail reason: value , ' expected'
]
