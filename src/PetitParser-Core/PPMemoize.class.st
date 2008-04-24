Class {
	#name : #PPMemoize,
	#superclass : #Object,
	#instVars : [
		'result',
		'count',
		'position'
	],
	#category : #'PetitParser-Core'
}

{ #category : #'as yet unclassified' }
PPMemoize class >> new [
	^ self basicNew initialize
]

{ #category : #action }
PPMemoize >> increment [
	count := count + 1
]

{ #category : #initialization }
PPMemoize >> initialize [
	
]
