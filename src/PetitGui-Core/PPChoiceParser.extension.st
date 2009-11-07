Extension { #name : #PPChoiceParser }

{ #category : #'*petitgui-accessing' }
PPChoiceParser >> morphicShapeSeen: aSet depth: anInteger [
	| morph |
	^ (anInteger < 1 or: [ aSet includes: self ])
		ifTrue: [ super morphicShapeSeen: aSet depth: anInteger ]
		ifFalse: [
			aSet add: self.
			morph := RectangleMorph new.
			morph 
				borderWidth: 0;
				color: Color transparent;
				layoutPolicy: TableLayout new;
				listDirection: #topToBottom;
				wrapCentering: #center;
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap;
				layoutInset: 5;
				cellInset: 5.
			self children
				do: [ :each | morph addMorphBack: (each morphicShapeSeen: aSet depth: anInteger - 1) ].
			morph ]
]
