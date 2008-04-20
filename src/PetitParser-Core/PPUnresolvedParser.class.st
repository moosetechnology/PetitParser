Class {
	#name : #PPUnresolvedParser,
	#superclass : #PPParser,
	#category : #'PetitParser-Builder'
}

{ #category : #testing }
PPUnresolvedParser >> isUnresolved [
	^ true
]

{ #category : #parsing }
PPUnresolvedParser >> parse: aStream [
	self error: 'Need to be resolved before execution.'
]
