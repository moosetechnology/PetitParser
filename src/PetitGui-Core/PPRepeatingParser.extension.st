Extension { #name : #PPRepeatingParser }

{ #category : #'*petitgui-accessing' }
PPRepeatingParser >> exampleOn: aStream [
	(min to: (max min: min + 5)) atRandom
		timesRepeat: [ super exampleOn: aStream ]
]

{ #category : #'*petitgui-accessing' }
PPRepeatingParser >> morphicShapeSeen: aSet depth: anInteger [
	| morph |
	^ (anInteger < 1 or: [ aSet includes: self ])
		ifTrue: [ super morphicShapeSeen: aSet depth: anInteger ]
		ifFalse: [
			aSet add: self.
			morph := RectangleMorph new.
			morph 
				borderWidth: 1;
				color: Color transparent;
				layoutPolicy: TableLayout new;
				listDirection: #leftToRight;
				wrapCentering: #center;
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap;
				layoutInset: 0 @ 5.
			morph addMorphBack: (LineMorph from: 0 @ 0 to: 20 @ 0 color: Color black width: 1) makeForwardArrow.
			morph addMorphBack: (parser morphicShapeSeen: aSet depth: anInteger - 1).
			morph addMorphBack: (LineMorph from: 0 @ 0 to: 20 @ 0 color: Color black width: 1) makeForwardArrow.
			morph ]
]
