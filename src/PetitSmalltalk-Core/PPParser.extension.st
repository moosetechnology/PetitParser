Extension { #name : #PPParser }

{ #category : #'*petitsmalltalk-operations' }
PPParser >> smalltalkToken [
	^ PPSmalltalkTokenParser on: self
]
