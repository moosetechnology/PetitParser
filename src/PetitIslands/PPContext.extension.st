Extension { #name : #PPContext }

{ #category : #'*petitislands' }
PPContext >> identifier [
	^ stream
]

{ #category : #'*petitislands' }
PPContext >> waterPosition [
	^ self globalAt:  #waterPosition ifAbsentPut: [ nil ]
]

{ #category : #'*petitislands' }
PPContext >> waterPosition: position [
	^ self globalAt:  #waterPosition put: position
]
