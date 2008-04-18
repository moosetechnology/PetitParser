Class {
	#name : #PPList,
	#superclass : #PPParser,
	#instVars : [
		'parsers'
	],
	#category : #'PetitParser-Core'
}

{ #category : #initialization }
PPList >> initialize [
	super initialize.
	parsers := OrderedCollection new
]
