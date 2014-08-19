Class {
	#name : #PPContext,
	#superclass : #Object,
	#instVars : [
		'stream',
		'root',
		'properties'
	],
	#category : #'PetitParser-Core'
}

{ #category : #'as yet unclassified' }
PPContext class >> on: aPPParser stream: aStream [
	^ self basicNew 
		initialize;
		root: aPPParser;
		stream: aStream asPetitStream;
		yourself
]

{ #category : #'stream mimicry' }
PPContext >> atEnd [
	^ stream atEnd
]

{ #category : #'stream mimicry' }
PPContext >> collection [
	^ stream collection  
]

{ #category : #'accessing-properties' }
PPContext >> hasProperty: aKey [
	"Test if the property aKey is present."
	
	^ properties notNil and: [ properties includesKey: aKey ]
]

{ #category : #initialization }
PPContext >> initialize [
	stream := nil.
]

{ #category : #'stream mimicry' }
PPContext >> next [
	^ stream next
]

{ #category : #'as yet unclassified' }
PPContext >> parsed: aPPParser at: anInteger result: anObject [
	self halt.
	^ anObject
]

{ #category : #'stream mimicry' }
PPContext >> peek [
	^ stream peek
]

{ #category : #'stream mimicry' }
PPContext >> peekTwice [
	^ stream peekTwice
]

{ #category : #'stream mimicry' }
PPContext >> position [
	^ stream position
]

{ #category : #'accessing-properties' }
PPContext >> propertyAt: aKey [
	"Answer the property value associated with aKey."
	
	^ self propertyAt: aKey ifAbsent: [ self error: 'Property not found' ]
]

{ #category : #'accessing-properties' }
PPContext >> propertyAt: aKey ifAbsent: aBlock [
	"Answer the property value associated with aKey or, if aKey isn't found, answer the result of evaluating aBlock."
	
	^ properties isNil
		ifTrue: [ aBlock value ]
		ifFalse: [ properties at: aKey ifAbsent: aBlock ]
]

{ #category : #'accessing-properties' }
PPContext >> propertyAt: aKey ifAbsentPut: aBlock [
	"Answer the property associated with aKey or, if aKey isn't found store the result of evaluating aBlock as new value."
	
	^ self propertyAt: aKey ifAbsent: [ self propertyAt: aKey put: aBlock value ]
]

{ #category : #'accessing-properties' }
PPContext >> propertyAt: aKey put: anObject [
	"Set the property at aKey to be anObject. If aKey is not found, create a new entry for aKey and set is value to anObject. Answer anObject."

	^ (properties ifNil: [ properties := Dictionary new: 1 ])
		at: aKey put: anObject
]

{ #category : #memoization }
PPContext >> remember [
	| memento |
	memento := PPContextMemento new
		stream: stream;
		position: stream position;
		yourself.
		
	self rememberProperties: memento.
	^ memento
]

{ #category : #memoization }
PPContext >> rememberProperties: aPPContextMemento [
	aPPContextMemento class selectorsAndMethodsDo: [ :selector :method |
		(selector beginsWith: 'remember') ifTrue: [ 
			aPPContextMemento withArgs: (Array with: self) executeMethod: method.
		]	
	]

]

{ #category : #'accessing-properties' }
PPContext >> removeProperty: aKey [
	"Remove the property with aKey. Answer the property or raise an error if aKey isn't found."
	
	^ self removeProperty: aKey ifAbsent: [ self error: 'Property not found' ]
]

{ #category : #'accessing-properties' }
PPContext >> removeProperty: aKey ifAbsent: aBlock [
	"Remove the property with aKey. Answer the value or, if aKey isn't found, answer the result of evaluating aBlock."
	
	| answer |
	properties isNil ifTrue: [ ^ aBlock value ].
	answer := properties removeKey: aKey ifAbsent: aBlock.
	properties isEmpty ifTrue: [ properties := nil ].
	^ answer
]

{ #category : #memoization }
PPContext >> restore: aPPContextMemento [
	aPPContextMemento stream == stream ifFalse: [ self error: 'Oops!' ].

	stream position: aPPContextMemento position.
	self restoreProperties: aPPContextMemento.
]

{ #category : #memoization }
PPContext >> restoreProperties: aPPContextMemento [
	aPPContextMemento stream == stream ifFalse: [ self error: 'Oops!' ].

	aPPContextMemento class selectorsAndMethodsDo: [ :selector :method |
		(selector beginsWith: 'restore') ifTrue: [ 
			aPPContextMemento withArgs: (Array with: self) executeMethod: method.
		]	
	]
]

{ #category : #acessing }
PPContext >> root [
	^ root 
]

{ #category : #acessing }
PPContext >> root: aPPParser [
	root := aPPParser 
]

{ #category : #'stream mimicry' }
PPContext >> skip: anInteger [ 
	^ stream skip: anInteger 
]

{ #category : #acessing }
PPContext >> stream [
	^ stream
]

{ #category : #acessing }
PPContext >> stream: aStream [
	stream := aStream.
]

{ #category : #'stream mimicry' }
PPContext >> uncheckedPeek [
	^ stream uncheckedPeek
]

{ #category : #'stream mimicry' }
PPContext >> upTo: anObject [
	^ stream upTo: anObject
]

{ #category : #'stream mimicry' }
PPContext >> upToAll: whatever [
	^ stream upToAll: whatever
]

{ #category : #'stream mimicry' }
PPContext >> upToAnyOf: whatever [
	^ stream upToAnyOf: whatever
]
