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
	"Answer a collection of instance-variables that should not be automatically initialized with productions, but that are used internal to the composite parser."

	^ PPCompositeParser allInstVarNames
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
PPCompositeParser class >> parse: anObject [
	^ self parse: anObject startingAt: self startSymbol
]

{ #category : #parsing }
PPCompositeParser class >> parse: anObject onError: aBlock [
	^ self parse: anObject startingAt: self startSymbol onError: aBlock
]

{ #category : #parsing }
PPCompositeParser class >> parse: anObject startingAt: aSymbol [
	^ (self newStartingAt: aSymbol) parse: anObject
]

{ #category : #parsing }
PPCompositeParser class >> parse: anObject startingAt: aSymbol onError: aBlock [
	^ (self newStartingAt: aSymbol) parse: anObject onError: aBlock
]

{ #category : #accessing }
PPCompositeParser class >> startSymbol [
	"Answer the method that represents the default start symbol."

	^ #start
]

{ #category : #initialization }
PPCompositeParser >> initializeStartingAt: aSymbol [
	| productionNames |
	self initialize.
	productionNames := self productionNames.
	parser := PPDelegateParser named: aSymbol.
	productionNames keysAndValuesDo: [ :key :value |
		self instVarAt: key put: (PPDelegateParser named: value) ].
	parser setParser: (self perform: aSymbol).
	productionNames keysAndValuesDo: [ :key :value |
		(self instVarAt: key) setParser: (self perform: value) ]
]

{ #category : #querying }
PPCompositeParser >> productionAt: aSymbol [
	"Answer the production named aSymbol."
	
	^ self productionAt: aSymbol ifAbsent: [ nil ]
]

{ #category : #querying }
PPCompositeParser >> productionAt: aSymbol ifAbsent: aBlock [
	"Answer the production named aSymbol, if there is no such production answer the result of evaluating aBlock."
	
	(self class ignoredNames includes: aSymbol asString)
		ifTrue: [ ^ aBlock value ].
	(self class startSymbol = aSymbol)
		ifTrue: [ ^ parser ].
	^ self instVarAt: (self class allInstVarNames
		indexOf: aSymbol asString
		ifAbsent: [ ^ aBlock value ])
]

{ #category : #querying }
PPCompositeParser >> productionNames [
	"Answer a dictionary of slot indexes and production names."
	
	| productionNames ignoredNames |
	productionNames := Dictionary new.
	ignoredNames := self class ignoredNames.
	self class allInstVarNames keysAndValuesDo: [ :key :value |
		(ignoredNames includes: value asSymbol)
			ifFalse: [ productionNames at: key put: value asSymbol ] ].
	^ productionNames
]

{ #category : #accessing }
PPCompositeParser >> start [
	"Answer the production to start this parser with."
	
	self subclassResponsibility
]
