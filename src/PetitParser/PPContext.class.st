"
A PPContext is provides contextual information to the parsing function.

Instance Variables
	globals:		<Dictionary>
	properties:		<Dictionar>
	root:		<PPParser>
	stream:		<PPStream>

globals
	- properties that are not restored after backtracking

properties
	- properties that are restored after backtracking

root
	- the root parser

stream
	- input stream

"
Class {
	#name : #PPContext,
	#superclass : #Object,
	#instVars : [
		'stream',
		'root',
		'properties',
		'globals'
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
PPContext >> back [
	^ stream back
]

{ #category : #'stream mimicry' }
PPContext >> collection [
	^ stream collection  
]

{ #category : #'stream mimicry' }
PPContext >> contents [ 
	^ stream contents
]

{ #category : #failures }
PPContext >> furthestFailure [
	" the furthest failure encountered while parsing the input stream "
	
	^ self globalAt: #furthestFailure ifAbsent: [ nil ]
]

{ #category : #'accessing-globals' }
PPContext >> globalAt: aKey [
	"Answer the global property value associated with aKey."
	
	^ self globalAt: aKey ifAbsent: [ self error: 'Property not found' ]
]

{ #category : #'accessing-globals' }
PPContext >> globalAt: aKey ifAbsent: aBlock [
	"Answer the global property value associated with aKey or, if aKey isn't found, answer the result of evaluating aBlock."
	
	^ globals isNil
		ifTrue: [ aBlock value ]
		ifFalse: [ globals at: aKey ifAbsent: aBlock ]
]

{ #category : #'accessing-globals' }
PPContext >> globalAt: aKey ifAbsentPut: aBlock [
	"Answer the global property associated with aKey or, if aKey isn't found store the result of evaluating aBlock as new value."
	
	^ self globalAt: aKey ifAbsent: [ self globalAt: aKey put: aBlock value ]
]

{ #category : #'accessing-globals' }
PPContext >> globalAt: aKey put: anObject [
	"Set the global property at aKey to be anObject. If aKey is not found, create a new entry for aKey and set is value to anObject. Answer anObject."

	^ (globals ifNil: [ globals := Dictionary new: 1 ])
		at: aKey put: anObject
]

{ #category : #'accessing-globals' }
PPContext >> hasGlobal: aKey [
	"Test if the global property aKey is present."
	
	^ globals notNil and: [ globals includesKey: aKey ]
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

{ #category : #initialization }
PPContext >> initializeFor: parser [
	parser == root ifTrue: [ ^ self ].
	
	root := parser.
	root allParsersDo: [ :p | 
		p updateContext: self
	]
]

{ #category : #'stream mimicry' }
PPContext >> isStartOfLine [
	^ stream isStartOfLine
]

{ #category : #'stream mimicry' }
PPContext >> next [
	^ stream next
]

{ #category : #'stream mimicry' }
PPContext >> next: anInteger [
	^ stream next: anInteger
]

{ #category : #failures }
PPContext >> noteFailure: aPPFailure [
	"record the furthest failure encountered while parsing the input stream "

	| furthestFailure |
	furthestFailure := self furthestFailure.
	( furthestFailure isNil or: [ aPPFailure position > furthestFailure position ]) 
		ifTrue: [ self globalAt: #furthestFailure put: aPPFailure ].
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

{ #category : #'stream mimicry' }
PPContext >> position: anInteger [
	^ stream position: anInteger
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
	properties ifNil: [ ^ self ].
	
	properties keysAndValuesDo: [ :key :value |
		aPPContextMemento propertyAt: key put: value
	].
]

{ #category : #'accessing-globals' }
PPContext >> removeGlobal: aKey [
	"Remove the property with aKey. Answer the property or raise an error if aKey isn't found."
	
	^ self removeGlobal: aKey ifAbsent: [ self error: 'Property not found' ]
]

{ #category : #'accessing-globals' }
PPContext >> removeGlobal: aKey ifAbsent: aBlock [
	"Remove the global property with aKey. Answer the value or, if aKey isn't found, answer the result of evaluating aBlock."
	
	| answer |
	globals isNil ifTrue: [ ^ aBlock value ].
	answer := globals removeKey: aKey ifAbsent: aBlock.
	globals isEmpty ifTrue: [ globals := nil ].
	^ answer
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
	
	aPPContextMemento keysAndValuesDo: [ :key :value |
		self propertyAt: key put: value
	].
]

{ #category : #acessing }
PPContext >> root [
	^ root 
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