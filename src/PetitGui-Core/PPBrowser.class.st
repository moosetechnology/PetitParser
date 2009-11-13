Class {
	#name : #PPBrowser,
	#superclass : #Object,
	#instVars : [
		'browser'
	],
	#category : #'PetitGui-Core'
}

{ #category : #'instance-creation' }
PPBrowser class >> open [
	^ self new open
]

{ #category : #'browse-parts' }
PPBrowser >> browseClassesOn: aBrowser [
	aBrowser tree
		title: 'Classes';
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
			morph scroller addMorph: self production morphicShape.
			morph ]
]

{ #category : #browse }
PPBrowser >> browseOn: aBrowser [
	aBrowser title: 'PetitParser Browser'; color: Color yellow muchDarker.
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
		self browseFirstOn: aBrowser.
		self browseFollowOn: aBrowser ]
]

{ #category : #'browse-parts' }
PPBrowser >> browseSelectorsOn: aBrowser [
	aBrowser list
		title: 'Selectors';
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
	| table contents |
	table := aBrowser table.
	table title: 'Test'; useExplicitNotNil.
	table row: #input; row: #output.
	
	contents := String new.
	table showOn: #input; using: [
		table text
			display: [ :parsers | contents ];
			update: #selection on: $s entitled: 'parse (s)' with: [ :presentation | 
				contents := presentation text copy ] ].
	table showOn: #output; from: #outer -> #entity; from: #input; using: [
		table text
			useExplicitNotNil;
			when: [ :parsers | parsers notNil ];
			display: [
				| result |
				result := self production
					parse: contents asParserStream.
				result isFailure
					ifTrue: [  ].
				result ] ]
]

{ #category : #public }
PPBrowser >> open [
	browser := GLMTableLayoutBrowser new.
	self browseOn: browser.
	browser openOn: self rootModel
]

{ #category : #'accessing-view' }
PPBrowser >> production [
	| parser selector |
	parser := self selectedClass new.
	selector := self selectedSelector ifNil: [ ^ parser ].
	^ parser instVarNamed: selector asString
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
