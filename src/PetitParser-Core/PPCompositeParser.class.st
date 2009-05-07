Class {
	#name : #PPCompositeParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Builder'
}

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
	superInstVarNames := PPCompositeParser allInstVarNames.
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
