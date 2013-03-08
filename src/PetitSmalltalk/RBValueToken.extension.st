Extension { #name : #RBValueToken }

{ #category : #'*PetitSmalltalk-Test' }
RBValueToken >> inputValue [
	self flag: 'ugly hack to deal with PPToken #value deprecation '.
	^ self value
]
