Class {
	#name : #IndentTraces,
	#superclass : #Object,
	#instVars : [
		'traces',
		'stream'
	],
	#category : #'PetitIndent-Core'
}

{ #category : #comparing }
IndentTraces >> = anObject [
	(self == anObject) ifTrue: [ ^ true ].
	(anObject class = IndentTraces) ifFalse: [ ^ false ].
	
	(anObject size = self size) ifFalse: [  ^ false ].
	
	traces keysAndValuesDo: [ :key :value |
		(anObject tracesFor: key) = value ifFalse: [ ^ false ]
	].

	^ true.
]

{ #category : #'as yet unclassified' }
IndentTraces >> copy [ 
	| newTraces |
	newTraces := IdentityDictionary new.
	traces keysAndValuesDo: [ :key :value |
		newTraces at: key put: value copy.
	].

	^ IndentTraces new 
		stream: stream;
		traces: newTraces;
		yourself
]

{ #category : #comparing }
IndentTraces >> hash [ 
	^ traces hash bitXor: stream hash
]

{ #category : #'as yet unclassified' }
IndentTraces >> initialize [
	super initialize.
	traces := IdentityDictionary new.
]

{ #category : #'as yet unclassified' }
IndentTraces >> lastIndentOf: aPPParser [
	^ stream column: (self tracesFor: aPPParser) top.
	
	
]

{ #category : #'as yet unclassified' }
IndentTraces >> lastLineOf: aPPParser [
	^ stream line: (self tracesFor: aPPParser) top.
	
	
]

{ #category : #'as yet unclassified' }
IndentTraces >> pop: aPPParser [
	| t |
	t := self tracesFor: aPPParser.
	t size = 1 ifTrue: [ ^ nil ].
	^ t pop.
	
	
]

{ #category : #'as yet unclassified' }
IndentTraces >> push: anObject value: position [
	self tracesFor: anObject add: position.
]

{ #category : #'as yet unclassified' }
IndentTraces >> register: aPPParser [
	traces at: aPPParser ifAbsentPut: [ Stack with: 0 ].
]

{ #category : #'as yet unclassified' }
IndentTraces >> size [
	^ traces size
]

{ #category : #'as yet unclassified' }
IndentTraces >> stream: aPPIndentStream [
	stream := aPPIndentStream
]

{ #category : #'as yet unclassified' }
IndentTraces >> traces: aDictionary [
	traces := aDictionary
]

{ #category : #'as yet unclassified' }
IndentTraces >> tracesFor: aPPParser [ 	
	^ traces at: aPPParser ifAbsentPut: [ Stack with: 0 ].
]

{ #category : #'as yet unclassified' }
IndentTraces >> tracesFor: aPPParser add: position [
	| t |
	t := self tracesFor: aPPParser.
	t ifNotNil: [ t push: position ].
	
]
