Extension { #name : #PPSequenceParser }

{ #category : #'*petitgui-accessing' }
PPSequenceParser >> exampleOn: aStream [
	parsers do: [ :each | each exampleOn: aStream ]
]

{ #category : #'*petitgui-accessing' }
PPSequenceParser >> morphicShapeSeen: aSet depth: anInteger [
	^ self morphicShapeSeen: aSet depth: anInteger do: [ :cc |
		| morph |
		morph := AlignmentMorph newRow.
		morph 
			cellInset: 0;				
			layoutInset: 0;
			vResizing: #shrinkWrap;
			color: (self backgroundForDepth: anInteger).
		morph addMorphBack: (LineMorph from: 0 @ 0 to: 20 @ 0 color: Color black width: 1) 	makeForwardArrow.
		self children
			do: [ :each | morph addMorphBack: (cc value: each) ]
			separatedBy: [ morph addMorphBack: (LineMorph from: 0 @ 0 to: 20 @ 0 color: Color black width: 1) makeForwardArrow ].
		morph addMorphBack: ((LineMorph from: 0 @ 0 to: 20 @ 0 color: Color black width: 1) 
			makeForwardArrow;
			yourself).
		morph ]
]
