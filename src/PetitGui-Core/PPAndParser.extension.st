Extension { #name : #PPAndParser }

{ #category : #'*petitgui-accessing' }
PPAndParser >> morphicShapeSeen: aSet depth: anInteger [
	aSet add: self.
	^ parser morphicShapeSeen: aSet depth: anInteger
]
