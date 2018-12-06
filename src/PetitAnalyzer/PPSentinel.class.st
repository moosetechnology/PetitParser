Class {
	#name : #PPSentinel,
	#superclass : #PPEpsilonParser,
	#classInstVars : [
		'instance'
	],
	#category : #PetitAnalyzer
}

{ #category : #'instance creation' }
PPSentinel class >> instance [
	^ instance ifNil: [ instance := self new ]
]
