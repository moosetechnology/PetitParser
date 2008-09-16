Class {
	#name : #PPListParser,
	#superclass : #PPParser,
	#instVars : [
		'parsers'
	],
	#category : #'PetitParser-Core'
}

{ #category : #adding }
PPListParser >> add: aRule [
	parsers addLast: aRule
]

{ #category : #initialization }
PPListParser >> initialize [
	super initialize.
	parsers := OrderedCollection new
]

{ #category : #copying }
PPListParser >> postCopy [
	super postCopy.
	parsers := parsers copy
]
