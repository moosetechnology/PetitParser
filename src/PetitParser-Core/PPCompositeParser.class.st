Class {
	#name : #PPCompositeParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Builder'
}

{ #category : #parsing }
PPCompositeParser class >> parse: aString [
	^ self new parse: aString asParserStream
]

{ #category : #parsing }
PPCompositeParser class >> parse: aString ifError: aBlock [
	| result |
	^ (result := self parse: aString) isFailure
		ifTrue: [ aBlock value: result ]
		ifFalse: [ result ]
]

{ #category : #private }
PPCompositeParser >> endOfLastToken [
	^ 0
]

{ #category : #initialization }
PPCompositeParser >> initialize [
	| resolved unresolved symbol |
	super initialize.
	resolved := Array new: self class instSize.
	unresolved := Array new: self class instSize.
	1 to: self class instSize do: [ :each |
		self instVarAt: each put: (unresolved at: each put: PPUnresolvedParser new) ].
	self class allInstVarNames keysAndValuesDo: [ :index :name |
		symbol := index = 1 ifTrue: [ #start ] ifFalse: [ name asSymbol ].
		(self respondsTo: symbol)
			ifTrue: [ resolved at: index put: (self perform: symbol) ]
			ifFalse: [ self error: 'Unable to initialize ' , symbol printString ].
		(resolved at: index) == self
			ifTrue: [ self error: 'Invalid definition for ' , symbol printString ] ].
	unresolved with: resolved do: [ :a :b |
		(a isKindOf: PPUnresolvedParser)
			ifTrue: [ a becomeForward: b ] ]
]

{ #category : #private }
PPCompositeParser >> parseSelector: aString [
]

{ #category : #accessing }
PPCompositeParser >> start [
	"Answer the production to start this parser with."
	
	self subclassResponsibility
]
