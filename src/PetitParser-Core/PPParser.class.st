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
PPParser >> plus [
	"Answer a new parser that parses the receiver one or more times."

	^ (PPSequenceParser new , self , self star) ==> [ :value | (Array with: value first) , value second ]
]

{ #category : #operations }
PPParser >> star [
	"Answer a new parser that parses the receiver zero or more times."

	^ PPStarParser on: self
]

{ #category : #operations }
PPParser >> token [
	"Answer a new parser that parses a token."
	
	^ PPTokenParser on: self
]

{ #category : #operations }
PPParser >> | aParser [ 
	"Answer a new parser that either parses the receiver or aParser."
	
	^ PPChoiceParser new | self | aParser
]
