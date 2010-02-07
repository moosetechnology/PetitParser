Class {
	#name : #PPPluggableParser,
	#superclass : #PPParser,
	#instVars : [
		'block'
	],
	#category : #'PetitParser-Core'
}

{ #category : #'instance creation' }
PPPluggableParser class >> on: aBlock [
	^ self new block: aBlock
]

{ #category : #accessing }
PPPluggableParser >> block: aBlock [
	block := aBlock
]

{ #category : #parsing }
PPPluggableParser >> parseOn: aStream [
	| position result |
	position := aStream position.
	result := block value: aStream.
	result isPetitFailure
		ifTrue: [ aStream position: position ].
	^ result
]
