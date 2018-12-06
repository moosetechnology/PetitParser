Extension { #name : #PPContext }

{ #category : #'*petitpreprocessor-core' }
PPContext >> absolutePosition [
	^ self absolutePosition: self position
]

{ #category : #'*PetitPreprocessor' }
PPContext >> absolutePosition: aPosition [
	^ self stream absolutePosition: aPosition
]
