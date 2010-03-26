"
Attributes of an XML node.
"
Class {
	#name : #PPXmlAttributes,
	#superclass : #PPXmlNode,
	#instVars : [
		'size',
		'keys',
		'values'
	],
	#category : #'PetitXml-Core'
}

{ #category : #'instance creation' }
PPXmlAttributes class >> new [
	^ self new: 3
]

{ #category : #'instance creation' }
PPXmlAttributes class >> new: anInteger [
	^ self basicNew initialize: anInteger; yourself
]

{ #category : #comparing }
PPXmlAttributes >> = anXmlNode [
	self == anXmlNode
		ifTrue: [ ^ true ].
	self class = anXmlNode class
		ifFalse: [ ^ false ].
	self size = anXmlNode size
		ifFalse: [ ^ false ].
	self keys with: anXmlNode keys do: [ :first :second |
		first = second
			ifFalse: [ ^ false ] ].
	self values with: anXmlNode values do: [ :first :second |
		first = second
			ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #accessing }
PPXmlAttributes >> add: anAssociation [
	self at: anAssociation key put: anAssociation value.
	^anAssociation
]

{ #category : #accessing }
PPXmlAttributes >> associations [
	"Answer a Collection containing the receiver's associations."

	| result |
	result := WriteStream on: (Array new: self size).
	self associationsDo: [ :assoc | result nextPut: assoc ].
	^ result contents
]

{ #category : #accessing }
PPXmlAttributes >> at: aKey [
	"Answer the value associated with aKey. Raise an exception, if no such key is defined."

	^ self at: aKey ifAbsent: [ self errorKeyNotFound ]
]

{ #category : #accessing }
PPXmlAttributes >> at: aKey ifAbsent: aBlock [
	"Answer the value associated with aKey. Evaluate aBlock, if no such key is defined."

	| index |
	index := self findIndexFor: aKey.
	^ index = 0
		ifFalse: [ values at: index ]
		ifTrue: [ aBlock value ]
]

{ #category : #accessing }
PPXmlAttributes >> at: aKey ifAbsentPut: aBlock [
	"Answer the value associated with aKey. Evaluate aBlock, if no such key is defined and store the return value."

	| index |
	index := self findIndexFor: aKey.
	^ index = 0
		ifFalse: [ values at: index ]
		ifTrue: [ self privateAt: aKey put: aBlock value ]
]

{ #category : #accessing }
PPXmlAttributes >> at: aKey ifPresent: aBlock [
	"Lookup aKey in the receiver. If it is present, answer the value of evaluating the given block with the value associated with the key. Otherwise, answer nil."

	| index |
	index := self findIndexFor: aKey.
	^ index = 0 ifFalse: [ aBlock value: (values at: index) ]
]

{ #category : #accessing }
PPXmlAttributes >> at: aKey put: aValue [
	"Set the value of aKey to be aValue."

	| index |
	index := self findIndexFor: aKey.
	^ index = 0
		ifFalse: [ values at: index put: aValue ]
		ifTrue: [ self privateAt: aKey put: aValue ]
]

{ #category : #enumerating }
PPXmlAttributes >> do: aBlock [
	1 to: size do: [ :index | aBlock value: (values at: index) ]
]

{ #category : #private }
PPXmlAttributes >> errorKeyNotFound [
	self error: 'Key not found'
]

{ #category : #private }
PPXmlAttributes >> findIndexFor: aKey [
	1 to: size do: [ :index |
		(keys at: index) = aKey
			ifTrue: [ ^ index ] ].
	^ 0
]

{ #category : #private }
PPXmlAttributes >> grow [
	| newKeys newValues |
	newKeys := Array new: 2 * size.
	newValues := Array new: 2 * size.
	1 to: size do: [ :index |
		newKeys at: index put: (keys at: index).
		newValues at: index put: (values at: index) ].
	keys := newKeys.
	values := newValues
]

{ #category : #comparing }
PPXmlAttributes >> hash [
	^ self keys hash bitXor: self values hash
]

{ #category : #testing }
PPXmlAttributes >> includesKey: aKey [
	"Answer whether the receiver has a key equal to aKey."

	^ (self findIndexFor: aKey) ~= 0
]

{ #category : #initialization }
PPXmlAttributes >> initialize: anInteger [
	self initialize.
	size := 0.
	keys := Array new: anInteger.
	values := Array new: anInteger
]

{ #category : #testing }
PPXmlAttributes >> isEmpty [
	^ size = 0
]

{ #category : #enumerating }
PPXmlAttributes >> keys [
	^ keys copyFrom: 1 to: size
]

{ #category : #enumerating }
PPXmlAttributes >> keysAndValuesDo: aBlock [
	1 to: size do: [ :index | aBlock value: (keys at: index) value: (values at: index) ]
]

{ #category : #enumerating }
PPXmlAttributes >> keysDo: aBlock [
	1 to: size do: [ :each | aBlock value: (keys at: each) ]
]

{ #category : #copying }
PPXmlAttributes >> postCopy [
	super postCopy.
	keys := keys copy.
	values := values copy
]

{ #category : #printing }
PPXmlAttributes >> printXmlOn: aStream [
	self keysAndValuesDo: [ :key :value |
		aStream
			nextPut: $ ; nextPutAll: key; nextPut: $=;
			nextPut: $"; nextPutAll: value; nextPut: $" ]
]

{ #category : #private }
PPXmlAttributes >> privateAt: aKey put: aValue [
	size = keys size ifTrue: [ self grow ].
	keys at: (size := size + 1) put: aKey.
	^ values at: size put: aValue
]

{ #category : #accessing }
PPXmlAttributes >> removeKey: aKey [
	"Remove aKey from the receiver, raise an exception if the element is missing."

	^ self removeKey: aKey ifAbsent: [ self errorKeyNotFound ]
]

{ #category : #accessing }
PPXmlAttributes >> removeKey: aKey ifAbsent: aBlock [
	"Remove aKey from the receiver, evaluate aBlock if the element is missing."

	| index value |
	index := self findIndexFor: aKey.
	index = 0 ifTrue: [ ^ aBlock value ].
	value := values at: index.
	index to: size - 1 do: [ :i |
		keys at: i put: (keys at: i + 1).
		values at: i put: (values at: i + 1) ].
	keys at: size put: nil.
	values at: size put: nil.
	size := size - 1.
	^ value
]

{ #category : #accessing }
PPXmlAttributes >> size [
	^ size
]

{ #category : #enumerating }
PPXmlAttributes >> values [
	^ values copyFrom: 1 to: size
]
