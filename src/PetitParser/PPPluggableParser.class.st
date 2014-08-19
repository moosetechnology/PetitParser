"
A pluggable parser that passes the parser stream into a block. This enables users to perform manual parsing or to embed other parser frameworks into PetitParser.

Instance Variables:
	block	<BlockClosure>	The pluggable one-argument block.

"
Class {
	#name : #PPPluggableParser,
	#superclass : #PPParser,
	#instVars : [
		'block'
	],
	#category : #'PetitParser-Parsers'
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

{ #category : #'pp-context' }
PPPluggableParser >> parseOn: aPPContext [
	| position result |
	position := aPPContext remember.
	result := block value: aPPContext.
	result isPetitFailure
		ifTrue: [ aPPContext restore: position ].
	^ result
]
