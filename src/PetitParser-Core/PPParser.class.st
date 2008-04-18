Class {
	#name : #PPParser,
	#superclass : #Object,
	#category : #'PetitParser-Core'
}

{ #category : #'instance creation' }
PPParser class >> new [
	^ self basicNew initialize
]

{ #category : #operations }
PPParser >> , aParser [
	"Answer a new parser that parses the receiver followed by aParser."
	
	^ PPSequence new , self , aParser
]

{ #category : #initialization }
PPParser >> initialize [
]

{ #category : #operations }
PPParser >> many [
	"Answer a new parser that parses the receiver zero or more times."

	^ PPMany on: self
]

{ #category : #operations }
PPParser >> many1 [
	"Answer a new parser that parses the receiver one or more times."

	^ self , self many
]

{ #category : #operations }
PPParser >> optional [
	"Answer a new parser that parses the receiver, if possible."

	^ self | PPEpsilon new
]

{ #category : #parsing }
PPParser >> parse: aStream [
	self subclassResponsabily
]

{ #category : #operations }
PPParser >> | aParser [
	"Answer a new parser that either parses the receiver or aParser."

	^ PPAlternative new | self | aParser
]
