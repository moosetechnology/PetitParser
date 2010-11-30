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

{ #category : #initialization }
PPBrowser class >> initialize [
	Smalltalk at: #TheWorldMenu ifPresent: [ :class |
		class class methodDict at: #registerOpenCommand: ifPresent: [ :method |
			(method sendsSelector: #deprecated:) 
				ifFalse: [ TheWorldMenu registerOpenCommand: (Array with: self label with: (Array with: self with: #open)) ] ] ]
]

{ #category : #accessing }
PPBrowser class >> label [
	^ 'PetitParser'
]

{ #category : #accessing }
PPBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>

	(aBuilder item: self label)
		parent: #Tools;
		action: [ self new open ]
]

{ #category : #'instance-creation' }
PPBrowser class >> open [
	^ self new open
]

{ #category : #initialization }
PPBrowser class >> unload [
	Smalltalk at: #TheWorldMenu ifPresent: [ :class |
		class class methodDict at: #unregisterOpenCommandWithReceiver: ifPresent: [ :method |
			(method sendsSelector: #deprecated:) 
				ifFalse: [ class unregisterOpenCommandWithReceiver: self ] ] ]
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
			StandardToolSet browse: self selectedClass selector: nil ] 
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
		populate: #selection on: $s entitled: 'parse (s)' with: [ :presentation |
			input := presentation text asString.
			stream := PPBrowserStream on: input.
			output := self production end 
				parse: stream.
			output isPetitFailure
				ifTrue: [ presentation selectionInterval: (output position + 1 to: output position) ].
			output ];
		populate: #selection on: $s entitled: 'inspect (i)' with: [ :presentation |
			input := presentation text asString.
			stream := PPBrowserStream on: input.
			output := self production end
				parse: stream.
			output explore.
			output ]
]

{ #category : #'browse-static' }
PPBrowser >> browseMapOn: aBrowser [
	aBrowser mondrian
		title: 'Map';
		useExplicitNotNil;
		painting: [ :view :parsers |
			self production viewAllNamedParsersOn: view ]
]

{ #category : #browse }
PPBrowser >> browseOn: aBrowser [
	aBrowser title: self class label; color: Color yellow muchDarker.
	aBrowser row: [ :row | row column: #class; column: #selector ].
	aBrowser row: [ :row | row column: #part span: 2 ] span: 2.
	aBrowser transmit 
		to: #class; 
		andShow: [ :aPane | self browseClassesOn: aPane ].
	aBrowser transmit 
		to: #selector; 
		from: #class; 
		andShow: [ :aPane | self browseSelectorsOn: aPane ].
	aBrowser transmit
		to: #part;
		from: #class;
		from: #selector;
		andShow: [ :aPane | self browsePartsOn: aPane ]
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
		act: [
			StandardToolSet 
				browse: self selectedClass 
				selector: self selectedSelector ] 
			on: $b entitled: 'browse (b)';
		act: [
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
	aBrowser text
		title: 'Source';
		useExplicitNotNil;
		display: [ self sourceCode ];
		forSmalltalk: [ self selectedClass ];
		selectionAct: [ :node | 
			| class selector |
			class := self selectedClass.
			selector := self sourceCode: node text asString in: class.
			aBrowser entity: self rootModel.
			self selectedClass: class.
			self selectedSelector: selector ]
		on: $s entitled: 'accept (s)'
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
