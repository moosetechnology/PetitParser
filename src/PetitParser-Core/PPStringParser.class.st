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

{ #category : #'instance-creation' }
PPStringParser class >> on: aString [
	^ self new string: aString
]

{ #category : #parsing }
PPStringParser >> basicParse: aStream [
	| position result |
	position := aStream position.
	result := aStream next: string size.
	result = string ifTrue: [ ^ result ].
	aStream position: position.
	^ PPFailure reason: string , ' expected' at: position
]

{ #category : #accessing }
PPStringParser >> string: aString [
	string := aString
]
