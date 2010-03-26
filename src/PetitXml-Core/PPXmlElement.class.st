"
An XML element node.
"
Class {
	#name : #PPXmlElement,
	#superclass : #PPXmlNode,
	#instVars : [
		'tag',
		'attributes',
		'contents'
	],
	#category : #'PetitXml-Core'
}

{ #category : #'instance creation' }
PPXmlElement class >> tag: aString attributes: aDictionary [
	^ self basicNew
		initializeTag: aString attributes: aDictionary;
		yourself
]

{ #category : #comparing }
PPXmlElement >> = anXmlNode [
	self == anXmlNode
		ifTrue: [ ^ true ].
	self class = anXmlNode class
		ifFalse: [ ^ false ].
	(self tag = anXmlNode tag 
		and: [ self attributes = anXmlNode attributes ])
			ifFalse: [ ^ false ].
	(self contents isNil and: [ anXmlNode contents isNil ])
		ifTrue: [ ^ true ].
	(self contents isNil or: [ anXmlNode contents isNil ])
		ifTrue: [ ^ false ].
	(self contents size = anXmlNode contents size)
		ifFalse: [ ^ false ].
	self contents with: anXmlNode contents do: [ :first :second |
		first = second 
			ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #accessing }
PPXmlElement >> attributes [
	^ attributes
]

{ #category : #accessing }
PPXmlElement >> childNodes [
	^ contents ifNil: [ #() ]
]

{ #category : #accessing }
PPXmlElement >> contents [
	^ contents
]

{ #category : #comparing }
PPXmlElement >> hash [
	^ self tag hash
]

{ #category : #initialization }
PPXmlElement >> initializeTag: aString attributes: aXmlAttributes [
	self setTag: aString; setAttributes: aXmlAttributes
]

{ #category : #copying }
PPXmlElement >> postCopy [
	super postCopy.
	self setAttributes: self attributes copy.
	self contents notNil
		ifTrue: [ self setContents: self contents copy ]
]

{ #category : #printing }
PPXmlElement >> printXmlOn: aStream [
	aStream nextPut: $<; nextPutAll: tag.
	attributes printXmlOn: aStream.
	contents isNil
		ifTrue: [ aStream nextPutAll: '/>' ]
		ifFalse: [
			aStream nextPut: $>.
			contents do: [ :each | each printXmlOn: aStream ].
			aStream nextPutAll: '</'; nextPutAll: tag; nextPut: $> ]
]

{ #category : #initialization }
PPXmlElement >> setAttributes: anXmlAttributes [
	attributes := anXmlAttributes setParent: self
]

{ #category : #initialization }
PPXmlElement >> setContents: anArray [
	anArray do: [ :each | each setParent: self ].
	contents := anArray
]

{ #category : #initialization }
PPXmlElement >> setTag: aString [
	tag := aString
]

{ #category : #accessing }
PPXmlElement >> tag [
	^ tag
]
