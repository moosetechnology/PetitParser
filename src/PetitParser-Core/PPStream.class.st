Class {
	#name : #PPStream,
	#superclass : #ReadStream,
	#instVars : [
		'cache'
	],
	#category : #'PetitParser-Core'
}

{ #category : #converting }
PPStream >> asParserStream [
	^ self
]

{ #category : #accessing }
PPStream >> for: aParser do: aBlock [
	| buffer memento |
	buffer := cache
		at: aParser
		ifAbsentPut: [ Array new: collection size + 1 ].
	memento := (buffer at: position + 1)
		ifNil: [ buffer at: position + 1 put: PPMemento new ].
	memento result isNil 
		ifTrue: [
			memento result: (readLimit - position + 1 < memento count
				ifTrue: [ PPFailure reason: 'overflow' at: position ]
				ifFalse: [ memento increment. aBlock value ]).
			memento position: position ]
		ifFalse: [ position := memento position ].
	^ memento result
]

{ #category : #private }
PPStream >> on: aCollection [
	self initialize.
	super on: aCollection
]

{ #category : #initialization }
PPStream >> on: aCollection from: firstIndex to: lastIndex [
	cache := IdentityDictionary new.
	collection := aCollection.
	position := firstIndex.
	readLimit := lastIndex
]

{ #category : #accessing }
PPStream >> peek [
	"An improved version of peek, that is slightly faster than the built in version."

	^ self atEnd ifFalse: [ collection at: position + 1 ]
]

{ #category : #printing }
PPStream >> printOn: aStream [
	aStream 
		nextPutAll: (collection copyFrom: 1 to: position);
		nextPut: $·;
		nextPutAll: (collection copyFrom: position + 1 to: readLimit)
]
