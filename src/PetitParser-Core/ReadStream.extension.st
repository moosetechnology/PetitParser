Extension { #name : #ReadStream }

{ #category : #'*petitparser' }
ReadStream >> for: aParser do: aBlock [
	^ aBlock value
]
