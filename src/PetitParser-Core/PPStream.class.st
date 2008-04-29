Class {
	#name : #PPStream,
	#superclass : #ReadStream,
	#instVars : [
		'cache'
	],
	#category : #'PetitParser-Core'
}

{ #category : #accessing }
PPStream >> for: aParser do: aBlock [
	| memento |
	memento := (cache
		at: aParser
		ifAbsentPut: [ IdentityDictionary new ])
			at: position
			ifAbsentPut: [ PPMemento new ].
	memento result isNil 
		ifFalse: [ position := memento position ]
		ifTrue: [
			memento result: (readLimit - position + 1 < memento count
				ifTrue: [ PPFailure reason: 'Overflow' at: position ]
				ifFalse: [ memento increment. aBlock value ]).
			memento position: position ].
	^ memento result
]

{ #category : #initialization }
PPStream >> initialize [
	cache := IdentityDictionary new
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

{ #category : #accessing }
PPStream >> peek [
	"An improved version of peek, that is slightly faster than the built in version."

	^ self atEnd ifFalse: [ collection at: position + 1 ]
]
