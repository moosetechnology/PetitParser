Class {
	#name : #PPXmlNode,
	#superclass : #Object,
	#instVars : [
		'parent'
	],
	#category : #'PetitXml-Core'
}

{ #category : #'accessing-dom' }
PPXmlNode >> childNodes [
	^ #()
]

{ #category : #'accessing-dom' }
PPXmlNode >> firstChild [
	^ self childNodes isEmpty ifFalse: [ self childNodes first ]
]

{ #category : #'accessing-dom' }
PPXmlNode >> lastChild [
	^ self childNodes isEmpty ifFalse: [ self childNodes last ]
]

{ #category : #'accessing-dom' }
PPXmlNode >> nextSibling [
	| index |
	self parentNode isNil ifTrue: [ ^ nil ].
	index := self parentNode indexOf: self ifAbsent: [ ^ nil ].
	^ self parentNode childNodes at: index + 1 ifAbsent: [ ^ nil ]
]

{ #category : #accessing }
PPXmlNode >> parent [
	"Answer the parent node of the receiver."
	
	^ parent
]

{ #category : #'accessing-dom' }
PPXmlNode >> parentNode [
	^ parent
]

{ #category : #'accessing-dom' }
PPXmlNode >> previousSibling [
	| index |
	self parentNode isNil ifTrue: [ ^ nil ].
	index := self parentNode indexOf: self ifAbsent: [ ^ nil ].
	^ self parentNode childNodes at: index - 1 ifAbsent: [ ^ nil ]
]

{ #category : #printing }
PPXmlNode >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' '.
	self printXmlOn: aStream
]

{ #category : #printing }
PPXmlNode >> printXmlOn: aStream [
	self subclassResponsibility
]

{ #category : #initialization }
PPXmlNode >> setParent: aNode [
	parent := aNode
]
