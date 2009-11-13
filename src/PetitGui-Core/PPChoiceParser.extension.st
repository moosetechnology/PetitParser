Extension { #name : #PPChoiceParser }

{ #category : #'*petitgui-accessing' }
PPChoiceParser >> exampleOn: aStream [
	"If there is already a lot written, try to pick an empty possiblity."
	
	aStream position > 512 ifTrue: [
		parsers
			detect: [ :each | each isNullable ]
			ifNone: [ ^ self ] ].
	parsers atRandom exampleOn: aStream
]

{ #category : #'*petitgui-accessing' }
PPChoiceParser >> morphicShapeSeen: aSet depth: anInteger [
	^ self morphicShapeSeen: aSet depth: anInteger do: [ :cc |
		| morph |
		morph := AlignmentMorph newColumn.
		morph
			cellInset: 5;
			layoutInset: 0 @ 5;
			vResizing: #shrinkWrap;
			color: Color transparent.
		self children
			do: [ :each | morph addMorphBack: (cc value: each) ].
		morph ]
]
