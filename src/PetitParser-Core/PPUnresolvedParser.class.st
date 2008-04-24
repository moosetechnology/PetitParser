Class {
	#name : #PPUnresolvedParser,
	#superclass : #PPParser,
	#instVars : [
		'symbol'
	],
	#category : #'PetitParser-Builder'
}

{ #category : #'instance-creation' }
PPUnresolvedParser class >> on: aSymbol [
	^ self new initializeOn: aSymbol
]

{ #category : #initialization }
PPUnresolvedParser >> initializeOn: aSymbol [
	symbol := aSymbol
]

{ #category : #testing }
PPUnresolvedParser >> isUnresolved [
	^ true
]

{ #category : #parsing }
PPUnresolvedParser >> parse: aStream [
	self error: self printString , ' need to be resolved before execution.'
]

{ #category : #accessing }
PPUnresolvedParser >> symbol [
	^ symbol
]
