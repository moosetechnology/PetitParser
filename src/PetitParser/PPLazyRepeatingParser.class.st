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

{ #category : #'pp-context' }
PPLazyRepeatingParser >> parseOn: aPPContext [
	| start element elements |
	start := aPPContext remember.
	elements := OrderedCollection new.
	[ elements size < min ] whileTrue: [
		(element := parser parseOn: aPPContext) isPetitFailure ifTrue: [
			aPPContext restore: start.
			^ element ].
		elements addLast: element ].
	[ self matchesLimitOn: aPPContext ] whileFalse: [
		elements size < max ifFalse: [
			aPPContext restore: start.
			^ PPFailure message: 'overflow' context: aPPContext at: start ].
		element := parser parseOn: aPPContext.
		element isPetitFailure ifTrue: [
			aPPContext restore: start.
			^ element ].
		elements addLast: element ].
	^ elements asArray
]
