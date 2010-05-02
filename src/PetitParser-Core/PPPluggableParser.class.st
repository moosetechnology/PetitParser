"
A pluggable parser that passes the parser stream into a block. This enables users to perform manual parsing or to embed other parser frameworks into PetitParser.
"
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
PPPluggableParser >> block [
	"Answer the pluggable block."

	^ block
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
