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

{ #category : #accessing }
PPXmlElement >> attributes [
	^ attributes
]

{ #category : #accessing }
PPXmlElement >> contents [
	^ contents
]

{ #category : #accessing }
PPXmlElement >> contents: anArray [
	anArray do: [ :each | each setParent: self ].
	contents := anArray
]

{ #category : #initialization }
PPXmlElement >> initializeTag: aString attributes: aDictionary [
	tag := aString.
	attributes := aDictionary
]

{ #category : #printing }
PPXmlElement >> printXmlOn: aStream [
	aStream nextPut: $<; nextPutAll: tag.
	contents isNil
		ifTrue: [ aStream nextPutAll: '/>' ]
		ifFalse: [
			aStream nextPut: $>.
			contents do: [ :each | each printXmlOn: aStream ].
			aStream nextPutAll: '</'; nextPutAll: tag; nextPut: $> ]
]

{ #category : #accessing }
PPXmlElement >> tag [
	^ tag
]
