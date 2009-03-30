Class {
	#name : #PPUnresolvedParser,
	#superclass : #PPParser,
	#category : #'PetitParser-Builder'
}

{ #category : #parsing }
PPUnresolvedParser >> basicParse: aStream [
	self error: self printString , ' need to be resolved before execution.'
]

{ #category : #testing }
PPUnresolvedParser >> isUnresolved [
	^ true
]
