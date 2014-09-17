Extension { #name : #PPDelegateParser }

{ #category : #'*petitislands' }
PPDelegateParser >> acceptsEpsilon [
	^ parser acceptsEpsilonOpenSet: (IdentitySet with: self).
]

{ #category : #'*petitislands' }
PPDelegateParser >> acceptsEpsilonOpenSet: set [
	(set includes: parser) ifFalse: [ 
		set add: parser.
		^ parser acceptsEpsilonOpenSet: set 
	].
	^ false
]
