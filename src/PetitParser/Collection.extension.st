Extension { #name : #Collection }

{ #category : #'*petitparser-core-converting' }
Collection >> asChoiceParser [
	^ PPChoiceParser withAll: (self collect: [ :each | each asParser ])
]

{ #category : #'*petitparser-core-converting' }
Collection >> asSequenceParser [
	^ PPSequenceParser withAll: (self collect: [ :each | each asParser ])
]
