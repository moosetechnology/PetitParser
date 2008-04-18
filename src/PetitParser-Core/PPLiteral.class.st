Class {
	#name : #PPLiteral,
	#superclass : #PPParser,
	#instVars : [
		'value'
	],
	#category : #'PetitParser-Core'
}

{ #category : #'instance creation' }
PPLiteral class >> on: anObject [
	^ self new setValue: anObject
]

{ #category : #printing }
PPLiteral >> printOn: aStream [
	aStream print: value
]

{ #category : #initialization }
PPLiteral >> setValue: anObject [
	value := anObject
]
