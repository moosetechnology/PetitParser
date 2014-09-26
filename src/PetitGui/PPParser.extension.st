Extension { #name : #PPParser }

{ #category : #'*petitgui-accessing' }
PPParser >> backgroundForDepth: anInteger [
	^ Color gray: 1.0 - (anInteger / 20.0)
]

{ #category : #'*petitgui-debug' }
PPParser >> debug: anObject [
	"Parse anObject with the receiving parser and answer the parse-result or an instance of PPFailure."
	
	^ self enableDebug parse: anObject asPetitStream
]

{ #category : #'*petitgui-debug' }
PPParser >> debuggerOutput [
	^ self propertyAt: #debuggerOutput ifAbsentPut: true.
]

{ #category : #'*petitgui-debug' }
PPParser >> debuggerOutput: aBoolean [
	self propertyAt: #debuggerOutput put: aBoolean
]

{ #category : #'*petitgui-debug' }
PPParser >> disableDebuggerOutput [ 
	self debuggerOutput: false.	
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

{ #category : #'*petitgui-debug' }
PPParser >> enableDebug [
   | root newParser  |
	root := PPParserDebuggerResult new.
	
	newParser := self transform: [:each |
		each >=> [:stream :continuation | 
			| result child |
			child := PPParserDebuggerResult new 
					parser: each;
					parent: root.
			root := root children add: child.
 			child start: stream position + 1.
			child showChildren: each debuggerOutput.
			result := continuation value.
			child end: stream position.
			root result: result.
			root := root parent.
			result 
		]
	].
	
	^ PPDebugParser on: newParser root: root.

]

{ #category : #'*petitgui-debug' }
PPParser >> enableDebuggerOutput [ 
	self debuggerOutput: true.
]

{ #category : #'*petitgui-accessing' }
PPParser >> example [
	^ String streamContents: [ :stream | self exampleOn: stream ] limitedTo: 1024
]

{ #category : #'*petitgui-accessing' }
PPParser >> exampleOn: aStream [
]

{ #category : #'*petitgui' }
PPParser >> gtGraphViewIn: composite [
	<gtInspectorPresentationOrder: 50>

	composite roassal
		title: 'Graph'; 
		painting: [ :view |
			self visualizeStructureInGraphOn: view.	
		].
]

{ #category : #'*petitgui' }
PPParser >> gtInspectorParserInspectorIn: composite [
	<gtInspectorPresentationOrder: 30>
	composite custom: (
		PPVerticalParserInspector new 
			title: 'Sampler';
			startOn: self)
]

{ #category : #'*petitgui' }
PPParser >> gtNamedTreeViewIn: composite [
	<gtInspectorPresentationOrder: 40>

	composite tree
		title: 'Named Tree';
		children: [:n | n namedChildren ];
		format: [:n| n name ifNil: [ n asString ] ];
		shouldExpandToLevel: 3
]

{ #category : #'*petitgui' }
PPParser >> gtTreeViewIn: composite [
	<gtInspectorPresentationOrder: 40>

	composite tree
			title: 'Tree';
			children: [:n | n children ];
			format: [:n| n name ifNil: [ n asString ] ifNotNil: [n name] ];
			shouldExpandToLevel: 6
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
	view := RTMondrianViewBuilder new.
	self viewAllNamedParsersOn: view.
	^ view open setLabel: 'All named parsers'
]

{ #category : #'*petitgui-mondrian' }
PPParser >> viewAllNamedParsersOn: view [
	view shape label text: #displayName; height: 10.
	view nodes: (self allParsers reject: [ :each | each name isEmptyOrNil ]).
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
		color: [ :each | 
					(aCollectionOfNames includes: each name)
						ifFalse: [ Color black ]
						ifTrue: [ Color red ] ];
		text: [ :each | each displayName ].
	view interaction popupText: aBlock.
	view interaction item: 'Explore' action: #explore.
	view nodes: (self allParsers reject: [ :each | each name isEmptyOrNil ]).
	view edges: (self allParsers reject: [ :each | each name isEmptyOrNil ]) from: #yourself toAll: #namedParsers.
	view horizontalDominanceTreeLayout
		verticalGap: 10;
		layered
]

{ #category : #'*petitgui-mondrian' }
PPParser >> visualizationGraphType [
	^ nil
]

{ #category : #'*petitgui-mondrian' }
PPParser >> visualizeStructureInGraph [

	"
	PPSmalltalkParser new visualize
	
	
	"
	| view |
	view := RTMondrianViewBuilder new.
	self visualizeStructureInGraphOn: view.
	view open.
	^ view
]

{ #category : #'*petitgui-mondrian' }
PPParser >> visualizeStructureInGraphOn: view [
	view shape rectangle 
		"borderWidth: 1";
		if: [ :p | p name isNil ] fillColor: Color lightGray.
	
	view interaction
		item: 'Explore' action: #explore;
		highlightWhenOver: [ :p | 
			self allParsers select: [ :ch | ch children includes: p ]
		] color: Color orange muchLighter;
		highlightWhenOver: [ :p | |children|
			children := p namedChildren.
		] color: Color orange muchDarker;
		highlightWhenOver: [ :p | Array with: p ] color: Color orange;
		popupText: [:p | p class name asString ].
	
	view
		nodes: self allParsers
		forEach: [ :aParser | |labels|
			labels := OrderedCollection new.
			aParser name notNil ifTrue: [ labels add: aParser name ].
			aParser visualizationGraphType notNil ifTrue: [ labels add: aParser visualizationGraphType ].
			labels isEmpty ifFalse: [ 
					view shape label.
					view interaction forwarder.
					view nodes: labels asArray ].
		].
	
	view shape: (ROLine new add: (ROArrow new size: 4) offset: 0.1).
	view edgesToAll: #children.	
	view treeLayout
		layered;
		on: ROLayoutEnd do: [ :evt | ROFocusView on: (view raw elementFromModel: self) ].
		
	view zoomInButton.
	view zoomOutButton.
]
