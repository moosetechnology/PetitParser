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
	^ #(parser)
]

{ #category : #parsing }
PPCompositeParser class >> parse: aString [
	^ self new parse: aString
]

{ #category : #parsing }
PPCompositeParser class >> parse: aString ifError: aBlock [
	^ self new parse: aString ifError: aBlock
]

{ #category : #initialization }
PPCompositeParser >> initialize [
	| thisInstVarNames superInstVarNames instVarNames |
	super initialize.
	thisInstVarNames := self class allInstVarNames.
	superInstVarNames := self class allIgnoredInstVarNames.
	instVarNames := ((1 to: self class instSize) 
		collect: [ :index | index -> (thisInstVarNames at: index) asSymbol ])
		reject: [ :assoc | superInstVarNames includes: assoc value ].
	instVarNames do: [ :assoc |
		self instVarAt: assoc key put: (PPUnresolvedParser new name: assoc value) ].
	parser := self start.
	instVarNames do: [ :assoc |
		(self respondsTo: assoc value)
			ifFalse: [ self error: 'Unable to initialize ' , assoc value printString ]
			ifTrue: [ 
				(self instVarAt: assoc key) 
					def: ((self perform: assoc value) name: assoc value) ] ]
]

{ #category : #parsing }
PPCompositeParser >> parse: aStream [
	^ super parse: aStream asParserStream
]

{ #category : #parsing }
PPCompositeParser >> parse: aStream ifError: aBlock [
	| result |
	result := self parse: aStream.
	^ result isFailure
		ifTrue: [ aBlock value: result ]
		ifFalse: [ result ]
]

{ #category : #accessing }
PPCompositeParser >> start [
	"Answer the production to start this parser with."
	
	self subclassResponsibility
]
