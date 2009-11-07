Extension { #name : #PPCompositeParser }

{ #category : #'*petitgui-accessing' }
PPCompositeParser >> productions [
	| productions |
	productions := OrderedCollection new.
	PPCompositeParser instSize + 1 to: self class instSize
		do: [ :index | productions add: (self instVarAt: index) ].
	^ productions
]
