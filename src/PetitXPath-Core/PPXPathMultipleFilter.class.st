Class {
	#name : #PPXPathMultipleFilter,
	#superclass : #PPXPathFilter,
	#category : #'PetitXPath-Nodes'
}

{ #category : #printing }
PPXPathMultipleFilter >> printOn: aStream [
	aStream nextPut: $*    
]

{ #category : #'as yet unclassified' }
PPXPathMultipleFilter >> resolveOn: anArray [
	^anArray
	  
]
