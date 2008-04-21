Class {
	#name : #PPStream,
	#superclass : #ReadStream,
	#instVars : [
		'memotable'
	],
	#category : #'PetitParser-Core'
}

{ #category : #accessing }
PPStream >> for: aParser do: aBlock [
	| positions counter |
	positions := memotable
		at: aParser
		ifAbsentPut: [ IdentityDictionary new ].
	counter := positions
		at: position
		ifAbsentPut: [ 0 -> aBlock value ].
	counter key: counter key + 1.
	^ counter key < readLimit 
		ifTrue: [ counter value ]
		ifFalse: [ PPFailingParser reason: 'Left recursion' position: position ]
]

{ #category : #initialization }
PPStream >> initialize [
	memotable := IdentityDictionary new
]

{ #category : #private }
PPStream >> on: aCollection [
	self initialize.
	super on: aCollection
]

{ #category : #private }
PPStream >> on: aCollection from: firstIndex to: lastIndex [
	self initialize.
	super on: aCollection from: firstIndex to: lastIndex
]
