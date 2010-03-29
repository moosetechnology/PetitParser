Class {
	#name : #PPBrowser,
	#superclass : #Object,
	#instVars : [
		'browser'
	],
	#category : #'PetitGui-Core'
}

{ #category : #initialization }
PPBrowser class >> initialize [
	TheWorldMenu registerOpenCommand: (Array with: self label with: (Array with: self with: #open))
]

{ #category : #accessing }
PPBrowser class >> label [
	^ 'PetitParser Browser'
]

{ #category : #'instance-creation' }
PPBrowser class >> open [
	^ self new open
]

{ #category : #'browse-parts' }
PPBrowser >> browseClassesOn: aBrowser [
	aBrowser tree
		title: 'Grammars';
		format: [ :class | class name ];
		children: [ :class | self subclassesOf: class ];
		act: [
			self selectedClass removeFromSystem.
			aBrowser entity: self rootClass ]
			on: $r entitled: 'remove (x)';
		act: [
			StandardToolSet browse: self selectedClass selector: nil ] 
			on: $b entitled: 'browse (b)'
]

{ #category : #'browse-parts' }
PPBrowser >> browseCyclesOn: aBrowser [
	aBrowser list
		title: 'Cycles';
		useExplicitNotNil;
		format: [ :parser | parser displayName ];
		display: [ :parsers | self production cycleSet ]
]

{ #category : #'browse-parts' }
PPBrowser >> browseExampleOn: aBrowser [
	aBrowser text
		title: 'Example';
		useExplicitNotNil;
		display: [ :parsers | self production example ]
]

{ #category : #'browse-parts' }
PPBrowser >> browseFirstOn: aBrowser [
	aBrowser list
		title: 'First';
		useExplicitNotNil;
		format: [ :parser | parser displayName ];
		display: [ :parsers | self production firstSet ]
]

{ #category : #'browse-parts' }
PPBrowser >> browseFollowOn: aBrowser [
	aBrowser list
		title: 'Follow';
		useExplicitNotNil;
		format: [ :parser | parser displayName ];
		display: [ :parsers | self production followSet ]
]

{ #category : #'browse-parts' }
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

{ #category : #browse }
PPBrowser >> browseOn: aBrowser [
	aBrowser title: self class label; color: Color yellow muchDarker.
	aBrowser row: [ :row | row column: #classes; column: #selectors ].
	aBrowser row: [ :row | row column: #actions span: 2 ] span: 2.
	
	aBrowser showOn: #classes; using: [ 
		self browseClassesOn: aBrowser ].
	aBrowser showOn: #selectors; from: #classes; using: [
		self browseSelectorsOn: aBrowser ].

	aBrowser showOn: #actions; from: #classes; from: #selectors; using: [
		self browseSourceOn: aBrowser.
		self browseTestOn: aBrowser.
		self browseGraphOn: aBrowser.
		self browseExampleOn: aBrowser.
		self browseCyclesOn: aBrowser.
		self browseFirstOn: aBrowser.
		self browseFollowOn: aBrowser ]
]

{ #category : #'browse-parts' }
PPBrowser >> browseSelectorsOn: aBrowser [
	aBrowser list
		title: 'Productions';
		format: [ :class | class asString ];
		display: [ :class | 
			(((class allInstVarNames
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

{ #category : #'browse-parts' }
PPBrowser >> browseSourceOn: aBrowser [
	aBrowser text
		title: 'Source';
		useExplicitNotNil;
		display: [ self sourceCode ];
		forSmalltalk: [ self selectedClass ];
		act: [ :node | 
			| class selector |
			class := self selectedClass.
			selector := self sourceCode: node text asString in: class.
			aBrowser entity: self rootModel.
			self selectedClass: class.
			self selectedSelector: selector ]
		on: $s entitled: 'accept (s)'
]

{ #category : #'browse-parts' }
PPBrowser >> browseTestOn: aBrowser [
	| table input output stream |
	table := aBrowser tabulator.
	table title: 'Test'; useExplicitNotNil.
	table row: #input; row: #output.
	
	input := String new.
	output := String new.
	stream := PPBrowserStream on: input.
	
	table showOn: #input; using: [
		table text
			useExplicitNotNil;
			display: [ :parsers | input ];
			populate: #selection on: $s entitled: 'parse (s)' with: [ :presentation |
				input := presentation text asString.
				stream := PPBrowserStream on: input.
				output := self production end 
					parse: stream.
				output isPetitFailure
					ifTrue: [ presentation selectionInterval: (output position + 1 to: output position)].
				output ];
			populate: #selection on: $s entitled: 'inspect (i)' with: [ :presentation |
				input := presentation text copy.
				stream := PPBrowserStream on: input.
				output := self production end
					parse: stream.
				output explore ] ].
	table showOn: #output; from: #input; using: [
		table text
			title: 'Result';
			display: [ output ].
		table table 
			title: 'Count';
			column: 'Parser' evaluated: [ :each | each first displayName ];
			column: 'Count' evaluated: [ :each | each second printString ];
			column: 'Percentage (%)' evaluated: [ :each | each third printString ];
			display: [ stream asFrequencyTable ].
		table table 
			title: 'Time';
			column: 'Parser' evaluated: [ :each | each first displayName ];
			column: 'Time (ms)' evaluated: [ :each | each second printString ];
			column: 'Percentage (%)' evaluated: [ :each | each third printString ];
			display: [ stream asTimingTable ].
		table morph 
			title: 'Positions';
			display: [
				| morph |
				morph := ScrollPane new.
				morph color: Color white.
				morph scroller addMorph: stream asPositionMorph.
				morph ] ]
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
	^ ((browser paneNamed: #classes) port: #selection) value
]

{ #category : #'accessing-view' }
PPBrowser >> selectedClass: aClass [
	((browser paneNamed: #classes) port: #selection) value: aClass
]

{ #category : #'accessing-view' }
PPBrowser >> selectedSelector [
	^ ((browser paneNamed: #selectors) port: #selection) value
]

{ #category : #'accessing-view' }
PPBrowser >> selectedSelector: aSelector [
	((browser paneNamed: #selectors) port: #selection) value: aSelector
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
