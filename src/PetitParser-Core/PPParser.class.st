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

{ #category : #operations }
PPParser >> and [
	"Answer a parser that succeeds whenever the receiver does, but consumes no input."

	^ PPAndParser on: self
]

{ #category : #'operations-mapping' }
PPParser >> answer: anObject [
	"Answer anObject from any successful parse of the receiver."

	^ self ==> [ :nodes | anObject ]
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

	^ self becomeForward: (aParser name: self name)
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

{ #category : #initialization }
PPParser >> initialize [
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

{ #category : #parsing }
PPParser >> matches: anObject [
	"Answer if anObject can be parsed by the receiver."
	
	^ (self parse: anObject) isPetitFailure not
]

{ #category : #parsing }
PPParser >> matchesIn: anObject [
	"Search anObject repeatedly for the matches of the receiver."

	| result |
	result := OrderedCollection new.
	self 
		matchesIn: anObject
		do: [ :each | result addLast: each ].
	^ result
]

{ #category : #parsing }
PPParser >> matchesIn: anObject do: aBlock [
	"Search anObject repeatedly for the matches of the receiver. Evaluate aBlock for each match passing the matched parse-tree as the argument."

	(self ==> aBlock / #any asParser) star parse: anObject
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
PPParser >> negate [
	"Answer a parser consumes any input token but the receiver."
	
	^ self not , #any asParser ==> #second
]

{ #category : #operations }
PPParser >> not [
	"Answer a parser that succeeds whenever the receiver fails."

	^ PPNotParser on: self
]

{ #category : #operations }
PPParser >> optional [
	"Answer a new parser that parses the receiver, if possible."

	^ self / nil asParser
]

{ #category : #parsing }
PPParser >> parse: anObject [
	"Parse anObject with the receiving parser and answer the parse-result or an instance of PPFailure."
	
	^ self parseOn: anObject asPetitStream
]

{ #category : #parsing }
PPParser >> parse: anObject onError: aBlock [
	"Parse anObject with the receiving parser and answer the parse-result or answer the result of evaluating aBlock. Depending on the number of arguments of the block it is simply evaluated,  evaluated with the faiure object, or eavaluated with the error message and position."
	
	| result |
	result := self parseOn: anObject asPetitStream.
	result isPetitFailure
		ifFalse: [ ^ result ].
	aBlock numArgs = 0
		ifTrue: [ ^ aBlock value ].
	aBlock numArgs = 1
		ifTrue: [ ^ aBlock value: result ].
	^ aBlock value: result reason value: result position
]

{ #category : #parsing }
PPParser >> parseOn: aStream [
	"Parse aStream with the receiving parser and answer the parse-result or an instance of PPFailure. Override this method in subclasses to specify custom parse behavior. Do not call this method from outside, instead use #parse:."
	
	self subclassResponsibility
]

{ #category : #operations }
PPParser >> plus [
	"Answer a new parser that parses the receiver one or more times."

	^ self min: 1
]

{ #category : #operations }
PPParser >> plusGreedy: aRestParser [
	"Answer a new parser that parses the receiver one or more times until it reaches aRestParser. This is a greedy  non-blind implementation of the star operator."
	
	^ self , (self starGreedy: aRestParser) map: [ :first :rest | rest copyWithFirst: first ]
]

{ #category : #operations }
PPParser >> plusLazy: aRestParser [
	"Answer a new parser that parses the receiver one or more times until it reaches aRestParser. This is a lazy non-blind implementation of the star operator."
	
	^ self , (self starLazy: aRestParser) map: [ :first :rest | rest copyWithFirst: first ]
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
	"Answer a new parser that parses the receiver zero or more times. This is a greedy and blind implementation that tries to consume as much input as possible and it does not consider what comes afterwards."

	^ PPRepeatingParser on: self
]

{ #category : #operations }
PPParser >> starGreedy: aRestParser [
	"Answer a new parser that parses the receiver zero or more times until it reaches aRestParser. This is a greedy  non-blind implementation of the star operator."
	
	| parser |
	parser := PPChoiceParser new.
	parser initializeWithAll: (Array
		with: (self , parser map: [ :each :rest | rest addFirst: each; yourself ])
		with: (aRestParser ==> [ :each | OrderedCollection with: each ])).
	^ parser ==> [ :rest | rest asArray ]
]

{ #category : #operations }
PPParser >> starLazy: aRestParser [
	"Answer a new parser that parses the receiver zero or more times until it reaches aRestParser. This is a lazy non-blind implementation of the star operator."
	
	| parser |
	parser := PPChoiceParser new.
	parser initializeWithAll: (Array
		with: (aRestParser ==> [ :each | OrderedCollection with: each ])
		with: (self , parser map: [ :each :rest | rest addFirst: each; yourself ])).
	^ parser ==> [ :rest | rest asArray ]
]

{ #category : #operations }
PPParser >> token [
	"Answer a new parser that transforms the input to a token and consumes white spaces."
	
	^ self currentTokenParser on: self
]

{ #category : #operations }
PPParser >> wrapped [
	"Answer a new parser that is simply wrapped."
	
	^ PPDelegateParser on: self
]
