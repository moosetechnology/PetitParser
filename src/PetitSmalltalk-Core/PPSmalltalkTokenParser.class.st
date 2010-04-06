"
A parser that knows how to skip comments and whitespace in Smalltalk and how to instantiate tokens.
"
Class {
	#name : #PPSmalltalkTokenParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitSmalltalk-Core'
}

{ #category : #parsing }
PPSmalltalkTokenParser >> parseComments: anArray on: aStream [
	| start comments |
	comments := anArray.
	[ [ aStream atEnd not and: [ aStream peek isSeparator ] ]
		whileTrue: [ aStream next ].
	  aStream peek = $" ] whileTrue: [ 
		aStream next.
		start := aStream position.
		[ aStream atEnd not and: [ aStream next = $" ] ] whileFalse.
		comments := comments copyWith: (start to: aStream position) ].
	^ comments
]

{ #category : #parsing }
PPSmalltalkTokenParser >> parseOn: aStream [
	| begin start comments element stop |
	begin := aStream position.
	comments := self 
		parseComments: #() 
		on: aStream.
	start := aStream position.
	element := super parseOn: aStream.
	element isPetitFailure ifTrue: [
		aStream position: begin.
		^ element ].
	stop := aStream position.
	comments := self
		parseComments: comments
		on: aStream.
	^ PPSmalltalkToken
		on: aStream collection
		start: start + 1 stop: stop
		comments: comments
]
