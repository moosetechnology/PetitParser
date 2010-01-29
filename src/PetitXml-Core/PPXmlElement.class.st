Class {
	#name : #PPXmlElement,
	#superclass : #PPXmlNode,
	#category : #'PetitXml-Core'
}

{ #category : #'as yet unclassified' }
PPXmlElement class >> named: aString attributes: aDictionary [
	^ self basicNew
		initializeNamed: aString attributes: aDictionary;
		yourself
]

{ #category : #'as yet unclassified' }
PPXmlElement >> attributes [
	^ attributes
]

{ #category : #'as yet unclassified' }
PPXmlElement >> contents [
	^ contents
]

{ #category : #'as yet unclassified' }
PPXmlElement >> initializeNamed: aString attributes: aDictionary [
	name := aString.
	attributes := aDictionary
]

{ #category : #'as yet unclassified' }
PPXmlElement >> name [
	^ name
]

{ #category : #'as yet unclassified' }
PPXmlElement >> printXmlOn: aStream [
	aStream nextPut: $<; nextPutAll: name.
	contents isNil
		ifTrue: [ aStream nextPutAll: '/>' ]
		ifFalse: [
			aStream nextPut: $>.
			contents do: [ :each | each printXmlOn: aStream ].
			aStream nextPutAll: '</'; nextPutAll: name; nextPut: $> ]
]
