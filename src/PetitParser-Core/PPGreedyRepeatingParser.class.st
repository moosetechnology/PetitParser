"
A greedy repeating parser, commonly seen in regular expression implementations. It aggressively consumes as much input as possible and then backtracks to meet the 'limit' condition.

This class essentially implements the iterative version of the following recursive parser composition:

	| parser |
	parser := PPChoiceParser new.
	parser setParsers: (Array
		with: (self , parser map: [ :each :rest | rest addFirst: each; yourself ])
		with: (limit and ==> [ :each | OrderedCollection new ])).
	^ parser ==> [ :rest | rest asArray ]
"
Class {
	#name : #PPGreedyRepeatingParser,
	#superclass : #PPLimitedRepeatingParser,
	#category : #'PetitParser-Parsers'
}

{ #category : #parsing }
PPGreedyRepeatingParser >> parseOn: aStream [
	| start element elements positions |
	start := aStream position.
	elements := OrderedCollection new.
	[ elements size < min ] whileTrue: [ 
		(element := parser parseOn: aStream) isPetitFailure ifTrue: [ 
			aStream position: start.
			^ element ].
		elements addLast: element ].
	positions := OrderedCollection with: aStream position.
	[ elements size < max and: [ (element := parser parseOn: aStream) isPetitFailure not ] ] whileTrue: [
		elements addLast: element.
		positions addLast: aStream position ].
	[ positions isEmpty ] whileFalse: [
		aStream position: positions last.
		element := limit parseOn: aStream.
		element isPetitFailure ifFalse: [
			aStream position: positions last.
			^ elements asArray ].
		elements isEmpty ifTrue: [
			aStream position: start.
			^ element ].
		elements removeLast.
		positions removeLast ].
	aStream position: start.
	^ PPFailure message: 'overflow' at: start
]
