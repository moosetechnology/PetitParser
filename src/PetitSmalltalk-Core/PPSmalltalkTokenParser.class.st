"
A parser that knows how to skip comments and whitespace in Smalltalk and how to instantiate tokens.
"
Class {
	#name : #PPSmalltalkTokenParser,
	#superclass : #PPTokenParser,
	#category : #'PetitSmalltalk-Core'
}

{ #category : #private }
PPSmalltalkTokenParser >> defaultTokenClass [
	^ PPSmalltalkToken
]

{ #category : #parsing }
PPSmalltalkTokenParser >> parseComments: anArray on: aStream [
	| start comments |
	comments := anArray.
	[ [ aStream atEnd not and: [ aStream peek isSeparator ] ]
		whileTrue: [ aStream next ].
	  aStream peek = $" ] whileTrue: [
		aStream next.
		start := aStream position.
		aStream upTo: $".
		comments := comments copyWith: (start to: aStream position) ].
	^ comments
]

{ #category : #parsing }
PPSmalltalkTokenParser >> parseOn: aStream [
	| start comments token |
	start := aStream position.
	comments := self
		parseComments: #()
		on: aStream.
	token := super parseOn: aStream.
	token isPetitFailure ifTrue: [
		aStream position: start.
		^ token ].
	comments := self
		parseComments: comments
		on: aStream.
	^ token comments: comments
]
