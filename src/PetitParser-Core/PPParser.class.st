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

	^ PPSequenceParser new , self , aParser
]

{ #category : #operations }
PPParser >> ==> aBlock [
	"Assigns aBlock as a success action handler."
	
	^ (PPActionParser on: self) block: aBlock
]

{ #category : #converting }
PPParser >> asParser [
	^ self
]

{ #category : #parsing }
PPParser >> basicParse: aStream [
	self subclassResponsibility
]

{ #category : #'operations-conveniance' }
PPParser >> delimitedBy: aParser [
	"Answer a parser that parses the receiver one or more times, separated and possibly ended by aParser."
	
	^ PPSequenceParser new , (self separatedBy: aParser) , aParser optional ==> [ :node | 
		node second	isNil
			ifTrue: [ node first ]
			ifFalse: [ node first copyWith: node second ] ]
]

{ #category : #operations }
PPParser >> end [
	"Ensure the end of the input and return the result of the receiver."

	^ PPSequenceParser new , self , PPEndOfInputParser new ==> #first
]

{ #category : #operations }
PPParser >> flatten [
	"Answer a new parser that flattens the underlying collection."
	
	^ PPFlattenParser on: self
]

{ #category : #initialization }
PPParser >> initialize [
]

{ #category : #testing }
PPParser >> isUnresolved [
	^ false
]

{ #category : #operations }
PPParser >> optional [
	"Answer a new parser that parses the receiver, if possible."

	^ PPChoiceParser new | self | PPEpsilonParser new
]

{ #category : #parsing }
PPParser >> parse: aStream [
	^ aStream for: self do: [ self basicParse: aStream ]
]

{ #category : #operations }
PPParser >> peek [
	"Answer a parser that peeks at the result of the receiver, but does not consume it."

	^ PPPeekParser on: self
]

{ #category : #operations }
PPParser >> plus [
	"Answer a new parser that parses the receiver one or more times."

	^ PPSequenceParser new , self , self star ==> [ :value | (Array with: value first) , value second ]
]

{ #category : #'operations-conveniance' }
PPParser >> separatedBy: aParser [
	"Answer a parser that parses the receiver one or more times, separated by aParser."
	
	^ PPSequenceParser new , self , (aParser , self) star ==> [ :node | 
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

{ #category : #operations }
PPParser >> | aParser [ 
	"Answer a new parser that either parses the receiver or aParser."
	
	^ PPChoiceParser new | self | aParser
]
