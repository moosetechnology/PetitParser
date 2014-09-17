Extension { #name : #PPSequenceParser }

{ #category : #'*petitislands' }
PPSequenceParser >> acceptsEpsilonOpenSet: set [
	set add: self.
	^ self children allSatisfy: [:e | e acceptsEpsilonOpenSet: set ]
]

{ #category : #'*petitislands' }
PPSequenceParser >> nextSets: aNextDictionary into: aSet [
	
	| nextSet eachNextSet change tally |
	nextSet := aSet copy.
	
	change := false.
	
	self children reverseDo: [:each |
		eachNextSet := aNextDictionary at: each.	
		tally := eachNextSet size.
		eachNextSet addAll: nextSet.
		change := change or: [ tally ~= eachNextSet size ].
		
		each acceptsEpsilon ifTrue: [
			nextSet add: each.
		] ifFalse: [
			nextSet := IdentitySet with: each.
		].
	].

	^ change
]
