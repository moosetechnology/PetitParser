Extension { #name : #Set }

{ #category : #'*petitparser-core-converting' }
Set >> asParser [
	^ PPChoiceParser withAll: (self collect: [ :each | each asParser ])
]
