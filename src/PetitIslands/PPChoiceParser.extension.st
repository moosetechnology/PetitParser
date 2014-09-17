Extension { #name : #PPChoiceParser }

{ #category : #'*petitislands' }
PPChoiceParser >> acceptsEpsilonOpenSet: set [
	set add: self.
	^ self children anySatisfy: [:e | e acceptsEpsilonOpenSet: set ].
]
