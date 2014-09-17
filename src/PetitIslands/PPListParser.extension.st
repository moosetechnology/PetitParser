Extension { #name : #PPListParser }

{ #category : #'*petitislands' }
PPListParser >> acceptsEpsilon [
	^ self acceptsEpsilonOpenSet: IdentitySet new.
]
