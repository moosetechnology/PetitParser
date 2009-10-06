Extension { #name : #Collection }

{ #category : #'*petitparser-core' }
Collection >> flatten [
	^ Array streamContents: [ :stream |
		self flattenedDo: [ :each |
			stream nextPut: each ] ]
]

{ #category : #'*petitparser-core' }
Collection >> flattenedDo: aBlock [
	self do: [ :each | each flattenedDo: aBlock ]
]
