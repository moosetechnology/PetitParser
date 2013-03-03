"
The default repeating parser with standard PEG semantics (i.e. possessive, blind, eager).
"
Class {
	#name : #PPPossessiveRepeatingParser,
	#superclass : #PPRepeatingParser,
	#category : #'PetitParser-Parsers'
}

{ #category : #parsing }
PPPossessiveRepeatingParser >> parseOn: aStream [
	| start element elements |
	start := aStream position.
	elements := OrderedCollection new.
	[ elements size < min ] whileTrue: [
		(element := parser parseOn: aStream) isPetitFailure ifTrue: [
			aStream position: start.
			^ element ].
		elements addLast: element ].
	[ elements size < max ] whileTrue: [
	 	(element := parser parseOn: aStream) isPetitFailure
			ifTrue: [ ^ elements asArray ].
		elements addLast: element ].
	^ elements asArray
]
