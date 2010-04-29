"
Abstract literal parser that parses some kind of literal type (to be specified by subclasses).
"
Class {
	#name : #PPLiteralParser,
	#superclass : #PPParser,
	#instVars : [
		'literal',
		'failureMessage'
	],
	#category : #'PetitParser-Core'
}

{ #category : #'instance creation' }
PPLiteralParser class >> on: anObject [
	^ self on: anObject message: anObject printString , ' expected'
]

{ #category : #'instance creation' }
PPLiteralParser class >> on: anObject message: aString [
	^ self new initializeOn: anObject message: aString
]

{ #category : #initialization }
PPLiteralParser >> initializeOn: anObject message: aString [
	literal := anObject.
	failureMessage := aString
]

{ #category : #accessing }
PPLiteralParser >> literal [
	^ literal
]

{ #category : #printing }
PPLiteralParser >> printNameOn: aStream [
	super printNameOn: aStream.
	aStream nextPutAll: ', '; print: literal
]
