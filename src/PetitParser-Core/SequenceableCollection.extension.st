Extension { #name : #SequenceableCollection }

{ #category : #'*petitparser-core-converting' }
SequenceableCollection >> asParser [
	self notify: 'SquenceableCollection>>#asParser is no longer supported. If you would like to create a PPSequenceParser from a Collection consider using #asSequenceParser instead.'.
	^ self asSequenceParser
]

{ #category : #'*petitparser-core-converting' }
SequenceableCollection >> asPetitStream [
	^ PPStream on: self
]
