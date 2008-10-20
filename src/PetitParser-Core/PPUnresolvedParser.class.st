Class {
	#name : #PPUnresolvedParser,
	#superclass : #PPParser,
	#category : #'PetitParser-Builder'
}

{ #category : #'instance-creation' }
PPUnresolvedParser class >> on: aSymbol [
	^ self new initializeOn: aSymbol
]

{ #category : #parsing }
PPUnresolvedParser >> parse: aStream [
	self error: self printString , ' need to be resolved before execution.'
]
