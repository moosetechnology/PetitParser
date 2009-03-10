Extension { #name : #ReadStream }

{ #category : #'*petitparser-core' }
ReadStream >> for: aParser do: aBlock [
	^ aBlock value
]
