Extension { #name : #PPParser }

{ #category : #'*PetitParser-GTExtensions' }
PPParser >> displayName [
	^ self name isNil
		ifFalse: [ self name asString ]
		ifTrue: [ self class name asString ]
]

{ #category : #'*PetitParser-GTExtensions' }
PPParser >> enableDebug [
   | root newParser  |
	root := PPParserDebuggerResult new.
	
	"In order to debug island waters, we need to compute the island water..."
	self allParsers select: [ :p | p isKindOf: PPSea  ] thenDo: [ :island |
		island createWaterForRoot: self	
	].
	
	newParser := self transform: [:each |
		each >=> [:stream :continuation | 
			| result child |
			child := PPParserDebuggerResult new 
					parser: each;
					parent: root.
			root := root children add: child.
 			child start: stream position + 1.
			result := continuation value.
			child end: stream position.
			root result: result.
			root := root parent.
			result 
		]
	].
	
	^ PPDebugParser on: newParser root: root.

]

{ #category : #'*PetitParser-GTExtensions' }
PPParser >> gtInspectorParserInspectorIn: composite [
	<gtInspectorPresentationOrder: 30>
	composite custom: (
		PPVerticalParserInspector new 
			title: 'Sampler';
			startOn: self)
]

{ #category : #'*PetitParser-GTExtensions' }
PPParser >> gtNamedTreeViewIn: composite [
	<gtInspectorPresentationOrder: 40>

	composite tree
		title: 'Named Tree';
		children: [:n | n namedChildren ];
		format: [:n| n name ifNil: [ n asString ] ];
		shouldExpandToLevel: 3
]

{ #category : #'*PetitParser-GTExtensions' }
PPParser >> gtTreeViewIn: composite [
	<gtInspectorPresentationOrder: 40>

	composite tree
			title: 'Tree';
			children: [:n | n children ];
			format: [:n| n name ifNil: [ n asString ] ifNotNil: [n name] ];
			shouldExpandToLevel: 6
]
