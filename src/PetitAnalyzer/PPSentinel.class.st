Class {
	#name : #PPSentinel,
	#superclass : #PPEpsilonParser,
	#classInstVars : [
		'current',
		'instance'
	],
	#category : #'PetitAnalyzer-Core'
}

{ #category : #'instance creation' }
PPSentinel class >> instance [
	^ instance ifNil: [ instance := self new ]
]
