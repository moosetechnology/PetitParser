Class {
	#name : #PPPluggableParser,
	#superclass : #PPParser,
	#instVars : [
		'block'
	],
	#category : 'PetitParser-Parsers'
}

{ #category : #'instance creation' }
PPPluggableParser class >> on: aBlock [
	^ self new initializeOn: aBlock
]

{ #category : #accessing }
PPPluggableParser >> block [
	"Answer the pluggable block."

	^ block
]

{ #category : #initialization }
PPPluggableParser >> initializeOn: aBlock [
	block := aBlock
]

{ #category : #parsing }
PPPluggableParser >> parseOn: aPPContext [
	| memento result |
	memento := aPPContext remember.
	result := block value: aPPContext.
	result isPetitFailure
		ifTrue: [ aPPContext restore: memento ].
	^ result
]
