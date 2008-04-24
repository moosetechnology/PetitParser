Class {
	#name : #PPListParser,
	#superclass : #PPParser,
	#instVars : [
		'parsers'
	],
	#category : #'PetitParser-Core'
}

{ #category : #initialization }
PPListParser >> initialize [
	super initialize.
	parsers := OrderedCollection new
]
