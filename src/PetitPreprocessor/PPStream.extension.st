Extension { #name : #PPStream }

{ #category : #'*PetitPreprocessor' }
PPStream >> absolutePosition [
	^ self absolutePosition: self position
]

{ #category : #'*PetitPreprocessor' }
PPStream >> absolutePosition: aPosition [
	^ aPosition
]

{ #category : #'*PetitPreprocessor' }
PPStream >> relativePosition [
	^ self relativePosition: self position
]

{ #category : #'*PetitPreprocessor' }
PPStream >> relativePosition: aPosition [
	^ aPosition
]
