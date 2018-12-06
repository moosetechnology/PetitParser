Extension { #name : #PPStream }

{ #category : #'*PetitPreprocessor' }
PPStream >> absolutePosition [
	^ self absolutePosition: self position
]

{ #category : #'*PetitPreprocessor' }
PPStream >> absolutePosition: aPosition [
	^ aPosition
]
