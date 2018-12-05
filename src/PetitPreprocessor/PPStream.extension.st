Extension { #name : #PPStream }

{ #category : #'*petitPreprocessor-core' }
PPStream >> absolutePosition [
	^ self absolutePosition: position
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
