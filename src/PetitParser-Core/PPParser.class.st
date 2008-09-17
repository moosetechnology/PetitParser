Class {
	#name : #PPParser,
	#superclass : #Object,
	#category : #'PetitParser-Core'
}

{ #category : #'instance-creation' }
PPParser class >> new [
	^ self basicNew initialize
]

{ #category : #operations }
PPParser >> , aParser [ 
	"Answer a new parser that parses the receiver followed by aParser."

	^ PPSequenceParser withAll: (Array with: self with: aParser)
]

{ #category : #operations }
PPParser >> / aParser [ 
	"Answer a new parser that either parses the receiver or aParser."
	
	^ PPChoiceParser withAll: (Array with: self with: aParser)
]

{ #category : #operations }
PPParser >> ==> aBlock [
	"Assigns aBlock as a success action handler."
	
	^ (PPActionParser on: self) block: aBlock
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

{ #category : #parsing }
PPParser >> basicParse: aStream [
	self subclassResponsibility
]

{ #category : #operations }
PPParser >> def: aParser [
	"Defines the receiver as the argument aParser. This method is useful when defining recursive parsers: instantiate a PPParser and later redefine it with another one."

	self becomeForward: aParser
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
	
	^ self ==> [ :nodes | aBlock valueWithArguments: nodes ]
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
	^ aStream for: self do: [ self basicParse: aStream ]
]

{ #category : #operations }
PPParser >> plus [
	"Answer a new parser that parses the receiver one or more times."

	^ self , self star ==> [ :value | value allButLast , value last ]
]

{ #category : #'operations-conveniance' }
PPParser >> separatedBy: aParser [
	"Answer a parser that parses the receiver one or more times, separated by aParser."
	
	^ (self) , (aParser , self) star ==> [ :node | 
		Array streamContents: [ :stream |
			stream nextPut: node first.
			node second do: [ :each | stream nextPutAll: each ] ] ]
]

{ #category : #operations }
PPParser >> star [
	"Answer a new parser that parses the receiver zero or more times."

	^ PPStarParser on: self
]

{ #category : #operations }
PPParser >> token [
	"Answer a new parser that answers a token."
	
	^ PPTokenParser on: self
]
