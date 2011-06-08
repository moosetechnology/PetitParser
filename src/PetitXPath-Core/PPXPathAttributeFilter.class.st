Class {
	#name : #PPXPathAttributeFilter,
	#superclass : #PPXPathFilter,
	#instVars : [
		'name',
		'value'
	],
	#category : #'PetitXPath-Nodes'
}

{ #category : #'instance creation' }
PPXPathAttributeFilter class >> withName: nameString value: valueString [
	^self basicNew 
		initializeName: nameString value: valueString;
		yourself  
]

{ #category : #initialization }
PPXPathAttributeFilter >> initializeName: nameString value: valueString [
	name := nameString.
	value := valueString.
	self initialize    
]

{ #category : #accessing }
PPXPathAttributeFilter >> name [ 
	^name
]

{ #category : #printing }
PPXPathAttributeFilter >> printOn: aStream [
	aStream 
		nextPut: $[;
		nextPutAll: self name;
		nextPut: $=;
		nextPut: $"; nextPutAll: self value; nextPut: $";   
		nextPut: $]
]

{ #category : #'as yet unclassified' }
PPXPathAttributeFilter >> resolveOn: anArray [
	^anArray 
		detect: [ :each | (each attributeAt: self name) = self value ]
	  
]

{ #category : #accessing }
PPXPathAttributeFilter >> value [
	^value
]
