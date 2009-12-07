"
A PPCompositeParser is composed parser built from various primitive parsers. 

Every production in the receiver is specified as a method that returns its parser. Note that every production requires an instance variable of the same name, otherwise the production is not cached and cannot be used in recursive grammars. Productions should refer to each other by reading the respective inst-var. Note: these inst-vars are typically not written, as the assignment happens in the initialize method using reflection.

The start production is defined in the method start. It is aliased to the inst-var parser defined in the superclass of PPCompositeParser.
"
Class {
	#name : #PPCompositeParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Tools'
}

{ #category : #accessing }
PPCompositeParser class >> ignoredNames [
	"Answer a collection of instance-variables that should not be automatically initialized with productions, but that are used internally to the composite parser."

	^ #(parser)
]

{ #category : #'instance creation' }
PPCompositeParser class >> new [
	"Answer a new parser starting at the default start symbol."

	^ self newStartingAt: self startSymbol
]

{ #category : #'instance creation' }
PPCompositeParser class >> newStartingAt: aSymbol [
	"Answer a new parser starting at aSymbol."

	^ self basicNew initializeStartingAt: aSymbol
]

{ #category : #parsing }
PPCompositeParser class >> parse: aString [
	^ self parse: aString startingAt: self startSymbol
]

{ #category : #parsing }
PPCompositeParser class >> parse: aString onError: aBlock [
	^ self result: (self parse: aString) onError: aBlock
]

{ #category : #parsing }
PPCompositeParser class >> parse: aString startingAt: aSymbol [
	^ (self newStartingAt: aSymbol) parse: aString asParserStream
]

{ #category : #parsing }
PPCompositeParser class >> parse: aString startingAt: aSymbol onError: aBlock [
	^ self result: (self parse: aString startingAt: aSymbol) onError: aBlock
]

{ #category : #private }
PPCompositeParser class >> result: anObject onError: aBlock [
	anObject isFailure
		ifFalse: [ ^ anObject ].
	aBlock numArgs = 0
		ifTrue: [ ^ aBlock value ].
	aBlock numArgs = 1
		ifTrue: [ ^ aBlock value: anObject ].
	^ aBlock value: anObject reason value: anObject position
]

{ #category : #accessing }
PPCompositeParser class >> startSymbol [
	"Answer the method that represents the default start symbol."

	^ #start
]

{ #category : #initialization }
PPCompositeParser >> initializeStartingAt: aSymbol [
	| allVariableNames ignoredVariableNames productionIndexesAndNames |
	self initialize.
	
	"find all the produtions that need to be initialized"
	allVariableNames := self class allInstVarNames.
	ignoredVariableNames := self class ignoredNames.
	productionIndexesAndNames := ((1 to: self class instSize)
		collect: [ :index | index -> (allVariableNames at: index) asSymbol ])
		reject: [ :assoc | ignoredVariableNames includes: assoc value ].
		
	"initialize productions with an undefined parser to be replaced later"
	parser := PPUnresolvedParser named: aSymbol.
	productionIndexesAndNames do: [ :assoc |
		self instVarAt: assoc key put: (PPUnresolvedParser named: assoc value) ].
	parser := self perform: aSymbol.
	
	"resolve unresolved parsers with their actual implementation"
	productionIndexesAndNames do: [ :assoc |
		(self respondsTo: assoc value)
			ifFalse: [ self error: 'Unable to initialize ' , assoc value printString ]
			ifTrue: [ (self instVarAt: assoc key) def: (self perform: assoc value) ] ]
]

{ #category : #querying }
PPCompositeParser >> productionAt: aSymbol [
	"Answer the production named aSymbol."
	
	^ self productionAt: aSymbol ifAbsent: [ nil ]
]

{ #category : #querying }
PPCompositeParser >> productionAt: aSymbol ifAbsent: aBlock [
	"Answer the production named aSymbol, if there is no such production answer the result of evaluating aBlock."
	
	| index |
	(self class ignoredNames includes: aSymbol)
		ifTrue: [ ^ aBlock value ].
	(self class startSymbol = aSymbol)
		ifTrue: [ ^ parser ].
	^ self instVarAt: (self class allInstVarNames
		indexOf: aSymbol 
		ifAbsent: [ ^ aBlock value ])
]

{ #category : #accessing }
PPCompositeParser >> start [
	"Answer the production to start this parser with."
	
	self subclassResponsibility
]
