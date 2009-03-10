Extension { #name : #SequenceableCollection }

{ #category : #'*petitparser-core-converting' }
SequenceableCollection >> asParser [
	^ PPSequenceParser withAll: (self collect: [ :each | each asParser ])
]

{ #category : #'*petitparser-core-converting' }
SequenceableCollection >> asParserStream [
	^ PPStream on: self
]
