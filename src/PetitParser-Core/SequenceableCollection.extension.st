Extension { #name : #SequenceableCollection }

{ #category : #'*petitparser' }
SequenceableCollection >> asParser [
	^ self 
		inject: PPSequenceParser new
		into: [ :result :each | result , each asParser ]
]

{ #category : #'*petitparser' }
SequenceableCollection >> asParserStream [
	^ PPStream on: self
]
