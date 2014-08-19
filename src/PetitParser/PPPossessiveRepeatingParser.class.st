"
The default repeating parser with standard PEG semantics (i.e. possessive, blind, eager).
"
Class {
	#name : #PPPossessiveRepeatingParser,
	#superclass : #PPRepeatingParser,
	#category : #'PetitParser-Parsers'
}

{ #category : #'pp-context' }
PPPossessiveRepeatingParser >> parseOn: aPPContext [
	| start element elements |
	start := aPPContext remember.
	elements := OrderedCollection new.
	[ elements size < min ] whileTrue: [
		(element := parser parseOn: aPPContext) isPetitFailure ifTrue: [
			aPPContext restore: start.
			^ element ].
		elements addLast: element ].
	[ elements size < max ] whileTrue: [
	 	(element := parser parseOn: aPPContext) isPetitFailure
			ifTrue: [ ^ elements asArray ].
		elements addLast: element ].
	^ elements asArray
]
