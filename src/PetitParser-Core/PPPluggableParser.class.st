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

{ #category : #parsing }
PPPluggableParser >> basicParse: aStream [
	| position result |
	position := aStream position.
	result := block value: aStream.
	result isFailure
		ifTrue: [ aStream position: position ].
	^ result
]

{ #category : #accessing }
PPPluggableParser >> block: aBlock [
	block := aBlock fixTemps
]
