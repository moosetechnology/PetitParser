Extension { #name : #PPParser }

{ #category : #'*petitgui-accessing' }
PPParser >> backgroundForDepth: anInteger [
	^ Color gray: 1.0 - (anInteger / 20.0)
]

{ #category : #'*petitgui-accessing' }
PPParser >> displayColor [
	^ self isTerminal
		ifTrue: [ Color r: 0.5 g: 0.0 b: 0.5 ]
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

{ #category : #'*petitgui' }
PPParser >> gtInspectorParserInspectorIn: composite [
	<gtInspectorPresentationOrder: 30>
	composite custom: (
		PPParserInspector new 
			title: 'Inspector';
			startOn: self)
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

{ #category : #'*petitgui-mondrian' }
PPParser >> namedParsers [
    | result |
    result := OrderedCollection new.
    self namedParsersDo: [ :parser | result addLast: parser ].
    ^ result
]

{ #category : #'*petitgui-mondrian' }
PPParser >> namedParsersDo: aBlock [
    self namedParsersDo: aBlock seen: IdentitySet new
]

{ #category : #'*petitgui-mondrian' }
PPParser >> namedParsersDo: aBlock seen: aSet [
    self children do: [ :each | 
        (aSet includes: each)
            ifFalse: [
		        aSet add: each.
		        each name isEmptyOrNil
		            ifFalse: [ aBlock value: each ]
		            ifTrue: [ each namedParsersDo: aBlock seen: aSet ] ] ]
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

{ #category : #'*petitgui-mondrian' }
PPParser >> viewAllNamedParsers [
	| view |
	view := MOViewRenderer new.
	self viewAllNamedParsersOn: view.
	view open
]

{ #category : #'*petitgui-mondrian' }
PPParser >> viewAllNamedParsersOn: view [
	view shape rectangle text: #displayName; withoutBorder. 
	view nodes: (self allParsers select: [:each |  each name isEmptyOrNil not ]).
	view edgesToAll: #namedParsers.
	view horizontalDominanceTreeLayout layered
]

{ #category : #'*petitgui-mondrian' }
PPParser >> viewAllNamedParsersWithSelection: aCollectionOfNames on: view [
	self viewAllNamedParsersWithSelection: aCollectionOfNames previewing: [ :each | each name ] on: view
]

{ #category : #'*petitgui-mondrian' }
PPParser >> viewAllNamedParsersWithSelection: aCollectionOfNames previewing: aBlock on: view [
	view shape label 
		color: [:each | (aCollectionOfNames includes: each name) ifFalse: [Color black] ifTrue: [Color red]];
		text: [:each |each displayName].
	view interaction popupText: aBlock.
	view interaction item: 'Explore' action: #explore.
	view nodes: (self allParsers select: [:each |  each name isEmptyOrNil not ]).
	view edges: (self allParsers select: [:each |  each name isEmptyOrNil not ])from: #yourself toAll: #namedParsers.
	view horizontalDominanceTreeLayout verticalGap: 10; layered
]
