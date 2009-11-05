"
A parser that accepts a given string.
"
Class {
	#name : #PPStringParser,
	#superclass : #PPParser,
	#instVars : [
		'string'
	],
	#category : #'PetitParser-Core'
}

{ #category : #'instance creation' }
PPStringParser class >> on: aString [
	^ self new initializeOn: aString
]

{ #category : #initialization }
PPStringParser >> initializeOn: aString [
	string := aString
]

{ #category : #testing }
PPStringParser >> isTerminal [
	^ true
]

{ #category : #parsing }
PPStringParser >> parse: aStream [
	| position result |
	position := aStream position.
	result := aStream next: string size.
	result = string ifTrue: [ ^ result ].
	aStream position: position.
	^ PPFailure reason: string , ' expected' at: position
]
