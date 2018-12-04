Extension { #name : #PPToken }

{ #category : #'*PetitParser-Deprecated' }
PPToken >> value [
	self
		deprecated: 'Token>>#value is no longer supported. Instead use Token>>#inputValue'
		transformWith: '`@receiver value' 
						-> '`@receiver inputValue'.
	^ self inputValue
]
