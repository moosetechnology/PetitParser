Extension { #name : #PPParser }

{ #category : #'*petitgui-accessing' }
PPParser >> backgroundForDepth: anInteger [
	^ Color gray: 1.0 - (anInteger / 20.0)
]

{ #category : #'*petitgui-accessing' }
PPParser >> displayColor [
	^ self isTerminal
		ifTrue: [ Color purple ]
		ifFalse: [ Color blue ]
]

{ #category : #'*petitgui-accessing' }
PPParser >> displayName [
	^ self name isNil
		ifFalse: [ self name asString ]
		ifTrue: [ self class name asString ]
]

{ #category : #'*petitgui-accessing' }
PPParser >> example [
	^ String streamContents: [ :stream | self exampleOn: stream ] limitedTo: 1024
]

{ #category : #'*petitgui-accessing' }
PPParser >> exampleOn: aStream [
]

{ #category : #'*petitgui-morphic' }
PPParser >> morphicProduction [
	^ self newRowMorph
		layoutInset: 4;
		addMorphBack: (self newRowMorph
			layoutInset: 4;
			addMorphBack: (StringMorph new
				contents: self displayName;
				emphasis: TextEmphasis bold emphasisCode;
				yourself);
			yourself);
		addMorphBack: (self morphicShapeSeen: IdentitySet new depth: 0);
		addMorphBack: (self newColumnMorph
			addMorphBack: (self newSpacerMorph);
			addMorphBack: (LineMorph from: 0 @ 0 to: 20 @ 0 color: Color black width: 1)	
				makeForwardArrow;
			yourself);
		yourself
]

{ #category : #'*petitgui-morphic' }
PPParser >> morphicShapeDefault [
	^ self newRowMorph
		addMorphBack: (self newColumnMorph
			addMorphBack: (self newSpacerMorph);
			addMorphBack: (LineMorph from: 0 @ 0 to: 20 @ 0 color: Color black width: 1)	
				makeForwardArrow;
			yourself);
		addMorphBack: (self newRowMorph
			borderWidth: 1;
			layoutInset: 3;
			color: Color white;
			on: #click send: #value to: [ Transcript show: self; cr ];
			addMorphBack: (StringMorph new
				contents: self displayName;
				color: self displayColor;
				yourself);
			yourself);
		yourself
]

{ #category : #'*petitgui-morphic' }
PPParser >> morphicShapeSeen: aSet depth: anInteger [
	^ self morphicShapeDefault
]

{ #category : #'*petitgui-morphic' }
PPParser >> morphicShapeSeen: aSet depth: anInteger do: aBlock [
	" avoid recursion "
	(aSet includes: self)
		ifTrue: [ ^ self morphicShapeDefault ].
	" display nice name when possible "
	(anInteger > 0 and: [ self name notNil ]) 
		ifTrue: [ ^ self morphicShapeDefault ].
	" don't do it too deep "
	(anInteger > 10)
		ifTrue: [ ^ self morphicShapeDefault ].
	aSet add: self. 
	^ aBlock value: [ :parser |
		parser 
			morphicShapeSeen: aSet 
			depth: anInteger + 1 ]
]

{ #category : #'*petitgui-morphic-creational' }
PPParser >> newColumnMorph [
	^ AlignmentMorph newColumn
		cellPositioning: #topLeft;
		color: Color transparent;
		listCentering: #topLeft;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: 0;
		yourself
]

{ #category : #'*petitgui-morphic-creational' }
PPParser >> newRowMorph [
	^ AlignmentMorph newRow
		cellPositioning: #topLeft;
		color: Color transparent;
		listCentering: #topLeft;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: 0;
		yourself
]

{ #category : #'*petitgui-morphic-creational' }
PPParser >> newSpacerMorph [
	^ Morph new
		color: Color transparent;
		borderWidth: 0;
		extent: 7 @ 7;
		yourself
]
