"
An abstract XML node.
"
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
	"Answer a collection of child nodes."

	^ #()
]

{ #category : #'accessing-dom' }
PPXmlNode >> firstChild [
	"Answer the first child of the receiver or nil."

	^ self childNodes isEmpty ifFalse: [ self childNodes first ]
]

{ #category : #testing }
PPXmlNode >> isDocument [
	^ false
]

{ #category : #'accessing-dom' }
PPXmlNode >> lastChild [
	"Answer the last child of the receiver or nil."

	^ self childNodes isEmpty ifFalse: [ self childNodes last ]
]

{ #category : #'accessing-dom' }
PPXmlNode >> nextSibling [
	"Answer the next sibling of the receiver or nil."

	| index parent |
	self parentNode isNil ifTrue: [ ^ nil ].
	parent := self parentNode childNodes.
	index := parent identityIndexOf: self ifAbsent: [ ^ nil ].
	^ parent at: index + 1 ifAbsent: [ ^ nil ]
]

{ #category : #enumerating }
PPXmlNode >> nodesDo: aBlock [
	aBlock value: self.
	self childNodes
		do: [ :each | each nodesDo: aBlock ]
]

{ #category : #accessing }
PPXmlNode >> parent [
	"Answer the parent node of the receiver."
	
	^ parent
]

{ #category : #'accessing-dom' }
PPXmlNode >> parentNode [
	"Answer the parent node of the receiver or nil."

	^ parent
]

{ #category : #copying }
PPXmlNode >> postCopy [
	super postCopy.
	self setParent: nil
]

{ #category : #'accessing-dom' }
PPXmlNode >> previousSibling [
	"Answer the previous sibling of the receiver or nil."

	| index parent |
	self parentNode isNil ifTrue: [ ^ nil ].
	parent := self parentNode childNodes.
	index := parent identityIndexOf: self ifAbsent: [ ^ nil ].
	^ parent at: index - 1 ifAbsent: [ ^ nil ]
]

{ #category : #printing }
PPXmlNode >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' ('.
	self printXmlOn: aStream.
	aStream nextPut: $)
]

{ #category : #printing }
PPXmlNode >> printXmlOn: aStream [
	self subclassResponsibility
]

{ #category : #initialization }
PPXmlNode >> setParent: aNode [
	parent := aNode
]
