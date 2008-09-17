Extension { #name : #SequenceableCollection }

{ #category : #'*petitparser-converting' }
SequenceableCollection >> asParser [
	^ PPSequenceParser withAll: (self collect: [ :each | each asParser ])
]

{ #category : #'*petitparser-converting' }
SequenceableCollection >> asParserStream [
	^ PPStream on: self
]
