"
A parser that knows how to skip comments and whitespace in Smalltalk and how to instantiate tokens.
"
Class {
	#name : #PPSmalltalkTokenParser,
	#superclass : #PPTokenParser,
	#instVars : [
		'comments'
	],
	#category : #'PetitSmalltalk-Core'
}

{ #category : #hooks }
PPSmalltalkTokenParser >> consumeSpaces: aStream [
	| start |
	[ super consumeSpaces: aStream.
	aStream peek = $" ] whileTrue: [ 
		aStream next.
		start := aStream position.
		[ aStream atEnd not and: [ aStream next = $" ] ] whileFalse.
		comments := comments copyWith: (start to: aStream position) ]
]

{ #category : #hooks }
PPSmalltalkTokenParser >> create: aCollection start: aStartInteger stop: aStopInteger [
	| token |
	token := super create: aCollection start: aStartInteger stop: aStopInteger.
	comments isEmpty ifFalse: [
		token comments: comments.
		comments := #() ].
	^ token
]

{ #category : #initialization }
PPSmalltalkTokenParser >> initialize [
	super initialize.
	comments := #()
]

{ #category : #accessing }
PPSmalltalkTokenParser >> tokenClass [
	^ PPSmalltalkToken
]
