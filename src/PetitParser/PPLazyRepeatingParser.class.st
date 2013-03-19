"
A lazy repeating parser, commonly seen in regular expression implementations. It limits its consumption to meet the 'limit' condition as early as possible.

This class essentially implements the iterative version of the following recursive parser composition:

	| parser |
	parser := PPChoiceParser new.
	parser setParsers: (Array
		with: (limit and ==> [ :each | OrderedCollection new ])
		with: (self , parser map: [ :each :rest | rest addFirst: each; yourself ])).
	^ parser ==> [ :rest | rest asArray ]
"
Class {
	#name : #PPLazyRepeatingParser,
	#superclass : #PPLimitedRepeatingParser,
	#category : #'PetitParser-Parsers'
}

{ #category : #parsing }
PPLazyRepeatingParser >> parseOn: aStream [
	| start element elements |
	start := aStream position.
	elements := OrderedCollection new.
	[ elements size < min ] whileTrue: [
		(element := parser parseOn: aStream) isPetitFailure ifTrue: [
			aStream position: start.
			^ element ].
		elements addLast: element ].
	[ self matchesLimitOn: aStream ] whileFalse: [
		elements size < max ifFalse: [
			aStream position: start.
			^ PPFailure message: 'overflow' at: start ].
		element := parser parseOn: aStream.
		element isPetitFailure ifTrue: [
			aStream position: start.
			^ element ].
		elements addLast: element ].
	^ elements asArray
]
