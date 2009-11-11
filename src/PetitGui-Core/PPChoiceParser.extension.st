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
				cellPositioning: #leftCenter;
				listDirection: #topToBottom;
				hResizing: #shrinkWrap;
				vResizing: #spaceFill;
				layoutInset: 5;
				cellInset: 5.
			self children
				do: [ :each | morph addMorphBack: (each morphicShapeSeen: aSet depth: anInteger - 1) ].
			morph ]
]
