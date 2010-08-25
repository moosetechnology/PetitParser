Class {
	#name : #PPCharSetPredicate,
	#superclass : #Object,
	#instVars : [
		'block',
		'lookup'
	],
	#category : #'PetitParser-Tools'
}

{ #category : #'instance creation' }
PPCharSetPredicate class >> on: aBlock [
	^ self basicNew initializeOn: aBlock
]

{ #category : #initialization }
PPCharSetPredicate >> initializeOn: aBlock [
	block := aBlock.
	lookup := Array new: 257.
	1 to: lookup size do: [ :index |
		lookup at: index put: (block
			value: (Character value: index - 1)) ]
]

{ #category : #evaluating }
PPCharSetPredicate >> value: aCharacter [
	| value |
	^ (value := aCharacter asInteger) < 257
		ifTrue: [ lookup at: value + 1 ]
		ifFalse: [ block value: aCharacter ]
]
