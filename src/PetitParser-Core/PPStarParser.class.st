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
	| elements element |
	elements := OrderedCollection new.
	[	element := super basicParse: aStream.
	 	element isFailure
			ifTrue: [ ^ elements asArray ].
		elements addLast: element ] repeat
]
