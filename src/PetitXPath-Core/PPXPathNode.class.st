Class {
	#name : #PPXPathNode,
	#superclass : #Object,
	#instVars : [
		'tag',
		'filter'
	],
	#category : #'PetitXPath-Nodes'
}

{ #category : #'instance creation' }
PPXPathNode class >> new [ 
	self error: 'Use #tag:qualifier:'
]

{ #category : #'instance creation' }
PPXPathNode class >> withTag: aString filter: anObject [
	^self basicNew 
		initializeTag: aString filter: anObject;
		yourself
]

{ #category : #accessing }
PPXPathNode >> filter [ 
	^filter ifNil: [ filter := PPXPathIndexFilter withIndex: 1 ]
]

{ #category : #initialization }
PPXPathNode >> initializeTag: aString filter: anObject [
	tag := aString.
	filter := anObject.
	self initialize.
]

{ #category : #printing }
PPXPathNode >> printOn: aStream [ 
	aStream 
		nextPutAll: self tag;
		nextPutAll: self filter asString.  

]

{ #category : #'as yet unclassified' }
PPXPathNode >> resolveOn: anXmlElement [
	| matchingChildren |
	matchingChildren := anXmlElement childNodes 
		select: [ :each | each isElement and: [ each name localName = self tag ] ].
	^self filter resolveOn: matchingChildren  
  
]

{ #category : #accessing }
PPXPathNode >> tag [
	^tag
]
