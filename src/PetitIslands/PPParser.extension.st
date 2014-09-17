Extension { #name : #PPParser }

{ #category : #'*petitislands' }
PPParser >> acceptsEpsilon [
	"return true, if parser can accept epsilon without failure"
	^ self subclassResponsibility
]

{ #category : #'*petitislands' }
PPParser >> acceptsEpsilonOpenSet: set [
	"private helper for acceptsEmpsilon that makes sure to avoid cycles (using open set)"
	self children isEmpty ifTrue: [ ^ self acceptsEpsilon ].
	
	self shouldBeImplemented .
]

{ #category : #'*petitislands' }
PPParser >> island [
	^ PPIsland new
		island: self;
		yourself;
		memoized
]

{ #category : #'*petitislands' }
PPParser >> nextSets [
	| nextSets |
	
	nextSets := IdentityDictionary new.
	self allParsersDo: [ :each | nextSets at: each put: IdentitySet new ].
	
	(nextSets at: self) add: PPSentinel instance.
	
	[ 	| changed |
		changed := false.
	
		nextSets keysAndValuesDo: [:parser :next |
			changed := (parser 
				nextSets: nextSets
				into: next) or: [ changed ].
		].
		changed ] whileTrue.
	
	^ nextSets
]

{ #category : #'*petitislands' }
PPParser >> nextSets: aNextDictionary into: aSet [
	"return true/false, if something has changed or not...."
	| childSet change tally |
	
	change := false.

	self children do: [:each | 
		childSet := aNextDictionary at: each.
		tally := childSet size.
		childSet addAll: aSet.
		change := change or: [ tally ~= childSet size ].
	].

	^ change
	
]
