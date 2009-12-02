"
A PPCompositeParser is composed parser built from various primitive parsers. 

Every production in the receiver is specified as a method that returns its parser. Note that every production requires an inst-var of the same name, otherwise the production is not cached and cannot be used in recursive grammars. Productions should refer to each other by reading the respective inst-var. Note: these inst-vars are typically not written, as the assignment happens in the initialize method using reflection.

The start production is defined in the method start. It is aliased to the inst-var parser defined in the superclass of PPCompositeParser.
"
Class {
	#name : #PPCompositeParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Builder'
}

{ #category : #accessing }
PPCompositeParser class >> allIgnoredInstVarNames [
	"Answer a collection of instance-variables that should not be automatically initialized with productions, but that are used internally to the composite parser."

	^ #(parser)
]

{ #category : #parsing }
PPCompositeParser class >> parse: aString [
	^ self new parse: aString asParserStream
]

{ #category : #parsing }
PPCompositeParser class >> parse: aString ifError: aBlock [
	| result |
	^ (result := self parse: aString asParserStream) isFailure
		ifTrue: [ aBlock value: result ]
		ifFalse: [ result ]
]

{ #category : #initialization }
PPCompositeParser >> initialize [
	| allVariableNames ignoredVariableNames productionIndexesAndNames |
	super initialize.
	allVariableNames := self class allInstVarNames.
	ignoredVariableNames := self class allIgnoredInstVarNames.
	productionIndexesAndNames := ((1 to: self class instSize)
		collect: [ :index | index -> (allVariableNames at: index) asSymbol ])
		reject: [ :assoc | ignoredVariableNames includes: assoc value ].
	productionIndexesAndNames do: [ :assoc |
		self instVarAt: assoc key put: (PPUnresolvedParser named: assoc value) ].
	parser := self start.
	productionIndexesAndNames do: [ :assoc |
		(self respondsTo: assoc value)
			ifFalse: [ self error: 'Unable to initialize ' , assoc value printString ]
			ifTrue: [ (self instVarAt: assoc key) def: (self perform: assoc value) ] ]
]

{ #category : #querying }
PPCompositeParser >> productionAt: aSymbol [
	"Answer the prodution named aSymbol."
	
	^ self productionAt: aSymbol ifAbsent: [ nil ]
]

{ #category : #querying }
PPCompositeParser >> productionAt: aSymbol ifAbsent: aBlock [
	"Answer the prodution named aSymbol, if there is no such production answer the result of evaluating aBlock."
	
	| index |
	(self class allIgnoredInstVarNames includes: aSymbol)
		ifTrue: [ ^ aBlock value ].
	(aSymbol = #start)
		ifTrue: [ ^ parser ].
	index := self class allInstVarNames
		indexOf: aSymbol
		ifAbsent: [ ^ aBlock value ].
	^ self instVarAt: index
]

{ #category : #accessing }
PPCompositeParser >> start [
	"Answer the production to start this parser with."
	
	self subclassResponsibility
]
