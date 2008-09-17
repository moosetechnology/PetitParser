Class {
	#name : #PPListParser,
	#superclass : #PPParser,
	#instVars : [
		'parsers'
	],
	#category : #'PetitParser-Core'
}

{ #category : #'instance-creation' }
PPListParser class >> withAll: anArray [
	^ self basicNew initializeWithAll: anArray
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
