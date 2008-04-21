"
A parser that parses zero or more instances of my delegate.
"
Class {
	#name : #PPStarParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Core'
}

{ #category : #parsing }
PPStarParser >> basicParse: aStream [
	| position elements element |
	elements := OrderedCollection new.
	[ position := aStream position.
	element := super basicParse: aStream.
	element isFailure ifTrue: [ 
		aStream position: position.
		^ elements asArray ].
	elements add: element ] repeat
]

{ #category : #printing }
PPStarParser >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $*
]
