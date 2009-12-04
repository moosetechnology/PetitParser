"
Abstract parser that parses a list of things in some way (to be specified by the subclasses).
"
Class {
	#name : #PPListParser,
	#superclass : #PPParser,
	#instVars : [
		'parsers'
	],
	#category : #'PetitParser-Core'
}

{ #category : #'instance creation' }
PPListParser class >> with: aFirstParser with: aSecondParser [
	^ self withAll: (Array with: aFirstParser with: aSecondParser)
]

{ #category : #'instance creation' }
PPListParser class >> withAll: aCollection [
	^ self basicNew initializeWithAll: aCollection asArray
]

{ #category : #querying }
PPListParser >> children [
	^ parsers
]

{ #category : #copying }
PPListParser >> copyWith: aParser [
	^ self species withAll: (parsers copyWith: aParser)
]

{ #category : #initialization }
PPListParser >> initialize [
	super initialize.
	parsers := #()
]

{ #category : #initialization }
PPListParser >> initializeWithAll: anArray [
	parsers := anArray
]
