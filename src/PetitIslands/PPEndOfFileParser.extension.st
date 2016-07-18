Extension { #name : #PPEndOfFileParser }

{ #category : #'*petitislands' }
PPEndOfFileParser >> acceptsEpsilon [
	^ false
]

{ #category : #'*petitislands' }
PPEndOfFileParser >> isIslandBorder [
	^ true
]

{ #category : #'*petitislands' }
PPEndOfFileParser >> nonEmpty [
	"I know I am empty, but it does not count in my case, I represent virtual non-existent character"
	^ self
]
