"
Abstract literal parser that parses some kind of literal type (to be specified by subclasses).
"
Class {
	#name : #PPLiteralParser,
	#superclass : #PPParser,
	#instVars : [
		'literal'
	],
	#category : #'PetitParser-Core'
}

{ #category : #'instance creation' }
PPLiteralParser class >> on: aString [
	^ self new initializeOn: aString
]

{ #category : #initialization }
PPLiteralParser >> initializeOn: aLiteral [
	literal := aLiteral
]
