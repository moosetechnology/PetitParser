Class {
	#name : #PPMultipleParser,
	#superclass : #PPParser,
	#instVars : [
		'parsers'
	],
	#category : #'PetitParser-Core'
}

{ #category : #initialization }
PPMultipleParser >> initialize [
	super initialize.
	parsers := OrderedCollection new
]
