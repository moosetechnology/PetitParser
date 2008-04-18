Class {
	#name : #PPMany,
	#superclass : #PPParser,
	#instVars : [
		'parser'
	],
	#category : #'PetitParser-Core'
}

{ #category : #'instance creation' }
PPMany class >> on: aParser [
	^ self new setParser: aParser
]

{ #category : #parsing }
PPMany >> parse: aStream [
	| position items item |
	items := OrderedCollection new.
	[	position := aStream position.
		item := parser parse: aStream.
		item class = PPFail ifTrue: [
			aStream position: position.
			^ items asArray ].
		items add: item ]
			repeat
]

{ #category : #initialization }
PPMany >> setParser: aParser [
	parser := aParser
]
