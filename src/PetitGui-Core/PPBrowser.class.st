"
self open
"
Class {
	#name : #PPBrowser,
	#superclass : #Object,
	#instVars : [
		'browser',
		'input',
		'stream',
		'output'
	],
	#category : #'PetitGui-Core'
}

{ #category : #accessing }
PPBrowser class >> icon [
	^ (Form
	extent: 16@16
	depth: 32
	fromArray: #( 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 1069534679 2139069360 2139069360 2139069360 2139069360 1551866800 1199545264 1451203504 2139069360 2139069360 2139069360 2139069360 2139069360 260021168 8362928 16777215 2139069360 14177 67123041 620771169 1224750945 1845507937 3372234593 3087021921 4278204257 4278204257 4278204257 4278204257 4278204257 3405789025 452999009 16777215 2139069360 14177 117454689 704657249 1325414241 1728067425 2197829473 3288348513 4278204257 4278204257 3758110561 3691001697 4278204257 4278204257 654325601 16777215 2139069360 14177 201340769 822097761 1409300321 1543518049 1811953505 3523229537 4278204257 4278204257 2231383905 3019913057 4278204257 4278204257 620771169 16777215 2139069360 14177 318781281 939538273 1509963617 1862285153 2717923169 3573561185 4278204257 4278204257 3238016865 3640670049 4278204257 4060100449 452999009 16777215 2139069360 1593849697 1862285153 2248161121 2281715553 2751477601 3003135841 3825219425 4278204257 4278204257 4278204257 4278204257 4278204257 1476409185 100677473 16777215 2139069360 33568609 536885089 1157642081 1644181345 1946171233 2214606689 4278204257 4278204257 3389011809 2281715553 2130720609 268449633 16791393 14177 16777215 2139069360 83900257 637548385 1258305377 1543518049 1543518049 1543518049 4278204257 4278204257 2466264929 201340769 14177 14177 14177 14177 16777215 2139069360 151009121 754988897 1375745889 1543518049 1543518049 1543518049 4278204257 4278204257 2298492769 125803440 16777215 16777215 16777215 16777215 16777215 2139069360 234895201 872429409 1426077537 1543518049 1543518049 2902472545 4278204257 4278204257 603993953 75471792 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215 16777215)
	offset: 0@0)
]

{ #category : #accessing }
PPBrowser class >> label [
	^ 'PetitParser'
]

{ #category : #private }
PPBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>

	(aBuilder item: self label)
		parent: #Tools;
		icon: self icon;
		action: [ self new open ]
]

{ #category : #'instance-creation' }
PPBrowser class >> open [
	^ self new open
]

{ #category : #browse }
PPBrowser >> browseClassesOn: aBrowser [
	aBrowser tree
		title: 'Grammars';
		format: [ :class | class name ];
		children: [ :class | self subclassesOf: class ];
		selectionAct: [
			self selectedClass removeFromSystem.
			aBrowser entity: self rootClass ]
			on: $r entitled: 'remove (x)';
		selectionAct: [
			self selectedClass browse ] 
			on: $b entitled: 'browse (b)'
]

{ #category : #'browse-static' }
PPBrowser >> browseCyclesOn: aBrowser [
	aBrowser list
		title: 'Cycles';
		useExplicitNotNil;
		format: [ :parser | parser displayName ];
		display: [ :parsers | self production cycleSet ]
]

{ #category : #browse }
PPBrowser >> browseDynamicOn: aBrowser [
	| tabulator |
	aBrowser useExplicitNotNil.
	
	tabulator := aBrowser tabulator.
	tabulator
		title: 'Dynamic';
		useExplicitNotNil;
		row: #input; row: #output.
	tabulator transmit
		to: #input;
		andShow: [ :a | self browseInputOn: a ].
	tabulator transmit
		to: #output;
		from: #input;
		andShow: [ :a | self browseOutputOn: a ].
		
	tabulator transmit
		from: #output;
		to: #input->#selectionInterval;
		when: [ :selection | selection notNil ];
		transformed: [ :selection | selection second to: selection third ]

]

{ #category : #'browse-static' }
PPBrowser >> browseExampleOn: aBrowser [
	aBrowser text
		title: 'Example';
		useExplicitNotNil;
		display: [ :parsers | self production example ]
]

{ #category : #'browse-static' }
PPBrowser >> browseFirstOn: aBrowser [
	aBrowser list
		title: 'First';
		useExplicitNotNil;
		format: [ :parser | parser displayName ];
		display: [ :parsers | self production firstSet ]
]

{ #category : #'browse-static' }
PPBrowser >> browseFollowOn: aBrowser [
	aBrowser list
		title: 'Follow';
		useExplicitNotNil;
		format: [ :parser | parser displayName ];
		display: [ :parsers | 
			| parser |
			parser := self selectedClass new.
			parser followSets
				at: (parser productionAt: self selectedSelector)
				ifAbsent: [ Array with: nil asParser ] ]
]

{ #category : #'browse-static' }
PPBrowser >> browseGraphOn: aBrowser [
	aBrowser morph
		title: 'Graph';
		useExplicitNotNil;
		display: [ :parsers |
			| morph |
			morph := ScrollPane new.
			morph color: Color white.
			morph scroller addMorph: self production morphicProduction.
			morph ]
]

{ #category : #'browse-dynamic' }
PPBrowser >> browseInputOn: aBrowser [
	aBrowser text
		useExplicitNotNil;
		display: [ :class :selector | input ];
		selectionPopulate: #selection on: $s entitled: 'Parse (s)' with: [ :presentation |
			input := presentation text asString.
			stream := PPBrowserStream on: input.
			output := self production end 
				parse: stream.
			output isPetitFailure
				ifTrue: [ presentation selectionInterval: (output position + 1 to: output position) ].
			output ]
]

{ #category : #'browse-static' }
PPBrowser >> browseMapOn: aBrowser [
	self class environment at: #GLMMondrianPresentation ifPresent: [ :class |
		aBrowser roassal
			title: 'Map';
			useExplicitNotNil;
			painting: [ :view :parsers |
				self production viewAllNamedParsersOn: view ] ]
]

{ #category : #browse }
PPBrowser >> browseOn: aComposite [
	aComposite title: self class label; color: Color yellow muchDarker.
	aComposite row: [ :row | row column: #class; column: #selector ].
	aComposite row: [ :row | row column: #part span: 2 ] span: 2.
	aComposite transmit 
		to: #class; 
		andShow: [ :composite | self browseClassesOn: composite ].
	aComposite transmit 
		to: #selector; 
		from: #class; 
		andShow: [ :composite | self browseSelectorsOn: composite ].
	aComposite transmit
		to: #part;
		from: #class;
		from: #selector;
		andShow: [ :composite | self browsePartsOn: composite ]
]

{ #category : #'browse-dynamic' }
PPBrowser >> browseOutputOn: aBrowser [
	aBrowser text
		title: 'Result';
		display: [ output ];
		act: [:text | output inspect ] entitled: 'Inspect'.

	aBrowser list
		title: 'Debugger';
		format: [ :each | (String new: 2 * each fourth withAll: $ ) asText , each first, ' - ', each last printString ];
		selectionAct: [:list | list selection last inspect ] entitled: 'Inspect token';
		display: [ 
			| depth trace |
			depth := -1.
			trace := OrderedCollection new.
			(self production end transform: [ :each |
				each name notNil 
					ifTrue: [ 
						each >=> [ :s :cc |
							| t r |
							depth := depth + 1. 
							trace addLast: (t := Array with: each name with: s position + 1 with: s position with: depth with: Object new with: nil).
							r := cc value.
							t at: t size put: r.
							t at: 3 put: s position.
							r isPetitFailure
								ifFalse: [ t at: 1 put: (t at: 1) asText allBold ].
							depth := depth - 1.
							r ] ]
					ifFalse: [ each ] ])
				parse: input.
			trace ].
	aBrowser table 
		title: 'Tally';
		column: 'Parser' evaluated: [ :each | each first displayName ];
		column: 'Count' evaluated: [ :each | each second printString ];
		column: 'Percentage (%)' evaluated: [ :each | each third printString ];
		display: [ stream asFrequencyTable ].
	aBrowser table 
		title: 'Profile';
		column: 'Parser' evaluated: [ :each | each first displayName ];
		column: 'Time (ms)' evaluated: [ :each | each second printString ];
		column: 'Percentage (%)' evaluated: [ :each | each third printString ];
		display: [ stream asTimingTable ].
	aBrowser morph 
		title: 'Progress';
		display: [
			| morph |
			morph := ScrollPane new.
			morph color: Color white.
			morph scroller addMorph: stream asPositionMorph.
			morph ]
]

{ #category : #browse }
PPBrowser >> browsePartsOn: aComposite [
	aComposite useExplicitNotNil.
	aComposite tabbedArrangement.
	self browseStaticOn: aComposite.
	self browseDynamicOn: aComposite
]

{ #category : #browse }
PPBrowser >> browseSelectorsOn: aBrowser [
	aBrowser list
		title: 'Productions';
		format: [ :class | class asString ];
		display: [ :class | 
			((((class allInstVarNames
				copyWithoutAll: class ignoredNames)
				copyWithoutAll: self rootClass allInstVarNames)
				collect: [ :each | each asSymbol ])
				select: [ :each | class includesSelector: each ])
				asSortedCollection ];
		selectionAct: [
			Smalltalk tools browser 
				fullOnClass: self selectedClass 
				selector: self selectedSelector ] 
			on: $b entitled: 'browse (b)';
		selectionAct: [
			| class selector |
			class := self selectedClass.
			selector := self selectedSelector.
			(class instVarNames includes: selector)
				ifTrue: [ class removeInstVarName: selector ].
			class removeSelector: selector.
			aBrowser entity: self rootModel.
			self selectedClass: class ]
			on: $r entitled: 'remove (x)'
]

{ #category : #'browse-static' }
PPBrowser >> browseSourceOn: aBrowser [
	aBrowser smalltalkCode
		title: 'Source';
		useExplicitNotNil;
		display: [ self sourceCode ];
		smalltalkClass: [ self selectedClass ];
		act: [ :node | 
			| class selector |
			class := self selectedClass.
			selector := self sourceCode: node text asString in: class.
			aBrowser entity: self rootModel.
			self selectedClass: class.
			self selectedSelector: selector ]
		on: $s 
		entitled: 'accept (s)'
]

{ #category : #browse }
PPBrowser >> browseStaticOn: aBrowser [
	aBrowser useExplicitNotNil.
	aBrowser tabbedArrangement.
	self browseSourceOn: aBrowser.
	self browseGraphOn: aBrowser.
	self browseMapOn: aBrowser.
	self browseCyclesOn: aBrowser.
	self browseFirstOn: aBrowser.
	self browseFollowOn: aBrowser.
	self browseExampleOn: aBrowser
]

{ #category : #'initialize-release' }
PPBrowser >> initialize [
	super initialize.
	input := String new.
	output := String new.
	stream := PPBrowserStream on: input
]

{ #category : #public }
PPBrowser >> open [
	browser := GLMTabulator new.
	self browseOn: browser.
	browser openOn: self rootModel
]

{ #category : #'accessing-view' }
PPBrowser >> production [
	| parser |
	^ (parser := self selectedClass new)
		productionAt: (self selectedSelector
			ifNil: [ ^ parser ])
]

{ #category : #accessing }
PPBrowser >> rootClass [
	^ PPCompositeParser
]

{ #category : #accessing }
PPBrowser >> rootModel [
	^ self subclassesOf: self rootClass
]

{ #category : #'accessing-view' }
PPBrowser >> selectedClass [
	^ ((browser paneNamed: #class) port: #selection) value
]

{ #category : #'accessing-view' }
PPBrowser >> selectedClass: aClass [
	((browser paneNamed: #class) port: #selection) value: aClass
]

{ #category : #'accessing-view' }
PPBrowser >> selectedSelector [
	^ ((browser paneNamed: #selector) port: #selection) value
]

{ #category : #'accessing-view' }
PPBrowser >> selectedSelector: aSelector [
	((browser paneNamed: #selector) port: #selection) value: aSelector
]

{ #category : #'accessing-view' }
PPBrowser >> sourceCode [
	^ (self selectedClass ifNil: [ ^ String new ]) 
		sourceCodeAt: (self selectedSelector ifNil: [ #start ])
		ifAbsent: [ String new ]
]

{ #category : #'accessing-view' }
PPBrowser >> sourceCode: aString in: aClass [
	| tree source selector |
	tree := RBParser parseMethod: aString onError: [ :msg :pos | nil ].
	source := tree isNil
		ifTrue: [ aString ]
		ifFalse: [ 
			| rewriter |
			rewriter := RBParseTreeRewriter new.
			rewriter
				replace: '`#literal' with: '`#literal asParser' when: [ :node |
					(node isLiteralNode and: [ node value isString or: [ node value isCharacter ] ])
						and: [ (node parent isNil or: [ node parent isMessage not or: [ node parent selector ~= #asParser ] ])
						and: [ (node parents noneSatisfy: [ :each | each isBlock ]) ] ] ];
				replaceMethod: '`@method: `@args | `@temps | ``@.statements. ``.statement `{ :node | node isReturn not }' 
					with: '`@method: `@args | `@temps | ``@.statements. ^ ``.statement'.
			(rewriter executeTree: tree)
				ifTrue: [ rewriter tree newSource ]
				ifFalse: [ aString ] ].
	selector := aClass compile: source.
	(aString numArgs = 0 and: [ (aClass allInstVarNames includes: selector) not ])
		ifTrue: [ aClass addInstVarName: selector asString ].
	^ selector
]

{ #category : #querying }
PPBrowser >> subclassesOf: aBehavior [
	^ aBehavior subclasses asSortedCollection: [ :a :b | a name < b name ]
]
