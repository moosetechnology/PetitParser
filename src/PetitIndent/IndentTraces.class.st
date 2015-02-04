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

{ #category : #copying }
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

{ #category : #initialization }
IndentTraces >> initialize [
	super initialize.
	traces := IdentityDictionary new.
]

{ #category : #defaults }
IndentTraces >> lastIndent [
	^ self top
]

{ #category : #accessing }
IndentTraces >> lastIndentOf: reference [
	^ ((self tracesFor: reference) isEmpty) ifFalse: [ 
		(self tracesFor: reference) top
	] ifTrue: [ -1 ]
	
	
]

{ #category : #accessing }
IndentTraces >> lastLineOf: reference [
	self error: 'not supported for now'.
	^ stream line: (self tracesFor: reference) top.
	
	
]

{ #category : #defaults }
IndentTraces >> pop [
	^ self pop: (PPIndentationLevel instance)
]

{ #category : #accessing }
IndentTraces >> pop: reference [
	^ (self tracesFor: reference) pop.	
]

{ #category : #defaults }
IndentTraces >> push: column [
	self push: (PPIndentationLevel instance) column: column
]

{ #category : #accessing }
IndentTraces >> push: reference column: column [
	self assert: column isInteger.
	(self tracesFor: reference) push: column.
]

{ #category : #accessing }
IndentTraces >> size [
	^ traces size
]

{ #category : #accessing }
IndentTraces >> stream: aPPIndentStream [
	stream := aPPIndentStream
]

{ #category : #defaults }
IndentTraces >> top [
	^ self top: PPIndentationLevel instance
]

{ #category : #accessing }
IndentTraces >> top: reference [
	^ (self tracesFor: reference) top.
	
]

{ #category : #accessing }
IndentTraces >> traces: aDictionary [
	traces := aDictionary
]

{ #category : #accessing }
IndentTraces >> tracesFor: reference [ 	
	^ traces at: reference ifAbsentPut: [ Stack with: 1 ].
]
