Class {
	#name : #PPParser,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'PetitParser-Core'
}

{ #category : #'instance creation' }
PPParser class >> named: aString [
	^ self new name: aString
]

{ #category : #'instance creation' }
PPParser class >> new [
	^ self basicNew initialize
]

{ #category : #operations }
PPParser >> , aParser [ 
	"Answer a new parser that parses the receiver followed by aParser."

	^ PPSequenceParser with: self with: aParser
]

{ #category : #operations }
PPParser >> / aParser [ 
	"Answer a new parser that either parses the receiver or aParser."
	
	^ PPChoiceParser with: self with: aParser
]

{ #category : #operations }
PPParser >> ==> aBlock [
	"Assigns aBlock as a success action handler."
	
	^ PPActionParser on: self block: aBlock
]

{ #category : #enumerating }
PPParser >> allNodes [
	"Answer all the parse nodes of the receiver."

	| result |
	result := OrderedCollection new.
	self allNodesDo: [ :parser | result add: parser ].
	^ result
]

{ #category : #enumerating }
PPParser >> allNodesDo: aBlock [
	"Iterate over all the parse nodes of the receiver."

	self allNodesDo: aBlock seen: IdentitySet new
]

{ #category : #enumerating }
PPParser >> allNodesDo: aBlock seen: aSet [
	"Iterate over all the parse nodes of the receiver, do not visit and follow the ones contained in aSet."

	(aSet includes: self)
		ifTrue: [ ^ self ].
	aSet add: self.
	aBlock value: self.
	self children
		do: [ :each | each allNodesDo: aBlock seen: aSet ]
]

{ #category : #operations }
PPParser >> and [
	"Answer a parser that succeeds whenever the receiver does, but consumes no input."

	^ PPAndParser on: self
]

{ #category : #converting }
PPParser >> asParser [
	^ self
]

{ #category : #accessing }
PPParser >> children [
	"Answer a set of child parsers that could follow the receiver."

	^ #()
]

{ #category : #private }
PPParser >> currentTokenParser [
	| context |
	context := thisContext sender.
	[ context notNil ] whileTrue: [
		(context receiver respondsTo: #tokenParser)
			ifTrue: [ ^ context receiver tokenParser ].
		context := context sender ].
	^ PPTokenParser
]

{ #category : #operations }
PPParser >> def: aParser [
	"Defines the receiver as the argument aParser. This method is useful when defining recursive parsers: instantiate a PPParser and later redefine it with another one."

	^ self becomeForward: aParser
]

{ #category : #'operations-conveniance' }
PPParser >> delimitedBy: aParser [
	"Answer a parser that parses the receiver one or more times, separated and possibly ended by aParser."
	
	^ (self separatedBy: aParser) , (aParser optional) ==> [ :node |
		node second	isNil
			ifTrue: [ node first ]
			ifFalse: [ node first copyWith: node second ] ]
]

{ #category : #operations }
PPParser >> end [
	"Ensure the end of the input and return the result of the receiver."

	^ PPEndOfInputParser on: self
]

{ #category : #querying }
PPParser >> firstSet [
	"Answer the first-set of the receiver. Note, this implementation is inefficient when called on different receivers of the same grammar, instead use #firstSets to calculate the first-sets at once."
	
	^ self firstSets at: self
]

{ #category : #querying }
PPParser >> firstSets [
	"Answer a dictionary with all the parsers reachable from the receiver as key and their first-set as value. The first-set of a parser is the list of terminal parsers that begin the parser derivable from that parser."
	
	| firstSets |
	firstSets := IdentityDictionary new.
	self allNodesDo: [ :each | 
		firstSets at: each put: (each isTerminal
			ifTrue: [ IdentitySet with: each ]
			ifFalse: [ IdentitySet new ]) ].
	[	| changed tally |
		changed := false.
		firstSets keysAndValuesDo: [ :parser :first |
			tally := first size.
			parser firstSets: firstSets into: first.
			changed := changed or: [ tally ~= first size ] ].
		changed ] whileTrue.
	^ firstSets
]

{ #category : #querying }
PPParser >> firstSets: aFirstDictionary into: aSet [
	"PROTECTED: Try to add additional elements to the first-set aSet of the receiver, use the incomplete aFirstDictionary."

	self children do: [ :parser | aSet addAll: (aFirstDictionary at: parser) ]
]

{ #category : #operations }
PPParser >> flatten [
	"Answer a new parser that flattens the underlying collection."
	
	^ PPFlattenParser on: self
]

{ #category : #'operations-mapping' }
PPParser >> foldLeft: aBlock [
	"Fold the result of the receiver from left-to-right into aBlock. The argument aBlock must take two or more arguments."
	
	| size args |
	size := aBlock numArgs.
	args := Array new: size.
	^ self ==> [ :nodes |
		args at: 1 put: (nodes at: 1).
		2 to: nodes size by: size - 1 do: [ :index |
			args
				replaceFrom: 2 to: size with: nodes startingAt: index;
				at: 1 put: (aBlock valueWithArguments: args) ].
		args at: 1 ]
]

{ #category : #'operations-mapping' }
PPParser >> foldRight: aBlock [
	"Fold the result of the receiver from right-to-left into aBlock. The argument aBlock must take two or more arguments."

	| size args |
	size := aBlock numArgs.
	args := Array new: size.
	^ self ==> [ :nodes |
		args at: size put: (nodes at: nodes size).
		nodes size - size + 1 to: 1 by: 1 - size do: [ :index |
			args
				replaceFrom: 1 to: size - 1 with: nodes startingAt: index;
				at: size put: (aBlock valueWithArguments: args) ].
		args at: size ]
]

{ #category : #querying }
PPParser >> followSet [
	"Answer the follow-set of the receiver starting at the receiver. Note, this implementation is inefficient when called on different receivers of the same grammar, instead use #followSets to calculate the follow-sets at once."
	
	^ self followSetIn: self
]

{ #category : #querying }
PPParser >> followSetIn: aParser [
	"Answer the follow-set of the receiver starting at aParser. Note, this implementation is inefficient when called on different receivers of the same grammar, instead use #followSets to calculate the follow-sets at once."
	
	^ aParser followSets at: self
]

{ #category : #querying }
PPParser >> followSets [
	"Answer a dictionary with all the parsers reachable from the receiver as key and their follow-set as value. The follow-set of a parser is the list of terminal parsers that can appear immediately to the right of that parser."
	
	| current previous continue firstSets followSets |
	current := previous := 0.
	firstSets := self firstSets.
	followSets := IdentityDictionary new.
	self allNodesDo: [ :each | followSets at: each put: IdentitySet new ].
	(followSets at: self) add: PPEpsilonParser new.
	[	followSets keysAndValuesDo: [ :parser :follow |
			parser 
				followSets: followSets
				firstSets: firstSets
				into: follow ].
		current := followSets
			inject: 0
			into: [ :result :each | result + each size ].
		continue := previous < current.
		previous := current.
		continue ] whileTrue.
	^ followSets
]

{ #category : #querying }
PPParser >> followSets: aFollowDictionary firstSets: aFirstDictionary into: aSet [
	"PROTECTED: Try to add additional elements to the follow-set aSet of the receiver, use the incomplete aFollowDictionary and the complete aFirstDictionary."
	
	self children do: [ :parser | (aFollowDictionary at: parser) addAll: aSet ]
]

{ #category : #initialization }
PPParser >> initialize [
]

{ #category : #testing }
PPParser >> isNullable [
	"Answer true if the receiver is a nullable parser, it can successfully parse nothing."
	
	^ false
]

{ #category : #testing }
PPParser >> isTerminal [
	"Answer true if the receiver is a terminal parser, that means it does not delegate to any other parser."
	
	^ false
]

{ #category : #testing }
PPParser >> isUnresolved [
	^ false
]

{ #category : #'operations-mapping' }
PPParser >> map: aBlock [
	"Map the result of the receiver to the arguments of aBlock."
	
	^ self ==> aBlock
]

{ #category : #operations }
PPParser >> max: anInteger [
	"Answer a new parser that parses the receiver at most anInteger times."
	
	^ PPRepeatingParser on: self max: anInteger
]

{ #category : #operations }
PPParser >> memoized [
	"Answer a memoized parser, for refraining redundant computations. This ensures polynomial time O(n^4) for left-recursive grammars and O(n^3) for non left-recursive grammars in the worst case."
	
	^ PPMemoizedParser on: self
]

{ #category : #operations }
PPParser >> min: anInteger [
	"Answer a new parser that parses the receiver at least anInteger times."
	
	^ PPRepeatingParser on: self min: anInteger
]

{ #category : #operations }
PPParser >> min: aMinInteger max: aMaxInteger [
	"Answer a new parser that parses the receiver at least aMinInteger and at most aMaxInteger times."
	
	^ PPRepeatingParser on: self min: aMinInteger max: aMaxInteger
]

{ #category : #accessing }
PPParser >> name [
	^ name
]

{ #category : #accessing }
PPParser >> name: aString [
	name := aString
]

{ #category : #operations }
PPParser >> not [
	"Answer a parser that succeeds whenever the receiver fails."

	^ PPNotParser on: self
]

{ #category : #operations }
PPParser >> optional [
	"Answer a new parser that parses the receiver, if possible."

	^ self / PPEpsilonParser new
]

{ #category : #parsing }
PPParser >> parse: aStream [
	self subclassResponsibility
]

{ #category : #operations }
PPParser >> plus [
	"Answer a new parser that parses the receiver one or more times."

	^ self min: 1
]

{ #category : #printing }
PPParser >> printOn: aStream [
	super printOn: aStream.
	self name isNil
		ifTrue: [ aStream nextPut: $(; print: self hash; nextPut: $) ]
		ifFalse: [ aStream nextPut: $(; nextPutAll: self name; nextPut: $) ]
]

{ #category : #'operations-conveniance' }
PPParser >> separatedBy: aParser [
	"Answer a parser that parses the receiver one or more times, separated by aParser."
	
	^ (PPSequenceParser with: self with: (PPSequenceParser with: aParser with: self) star) ==> [ :node |
		Array streamContents: [ :stream |
			stream nextPut: node first.
			node second do: [ :each | stream nextPutAll: each ] ] ]
]

{ #category : #operations }
PPParser >> star [
	"Answer a new parser that parses the receiver zero or more times."

	^ PPRepeatingParser on: self
]

{ #category : #operations }
PPParser >> token [
	"Answer a new parser that transforms the input to a token and consumes whitespaces."
	
	^ self currentTokenParser on: self
]

{ #category : #operations }
PPParser >> wrapped [
	"Answer a new parser that is simply wrapped."
	
	^ PPDelegateParser on: self
]
