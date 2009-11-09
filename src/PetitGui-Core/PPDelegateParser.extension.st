Extension { #name : #PPDelegateParser }

{ #category : #'*petitgui-accessing' }
PPDelegateParser >> exampleOn: aStream [
	parser exampleOn: aStream
]

{ #category : #'*petitgui-accessing' }
PPDelegateParser >> morphicShapeSeen: aSet depth: anInteger [
	aSet add: self.
	^ parser morphicShapeSeen: aSet depth: anInteger
]
