Class {
	#name : #PPBrowser,
	#superclass : #Object,
	#category : #'PetitGui-Core'
}

{ #category : #'instance-creation' }
PPBrowser class >> open [
	^ self new open
]

{ #category : #'browse-parts' }
PPBrowser >> browseExampleOn: aBrowser [
	aBrowser text
		title: 'Example';
		display: [ :parsers | (self productionFor: parsers) example ]
]

{ #category : #'browse-parts' }
PPBrowser >> browseFirstOn: aBrowser [
	aBrowser list
		title: 'First';
		format: [ :parser | parser displayName ];
		display: [ :parsers | (self productionFor: parsers) firstSet ]
]

{ #category : #'browse-parts' }
PPBrowser >> browseFollowOn: aBrowser [
	aBrowser list
		title: 'Follow';
		format: [ :parser | parser displayName ];
		display: [ :parsers | (self productionFor: parsers) followSet ]
]

{ #category : #'browse-parts' }
PPBrowser >> browseGraphOn: aBrowser [
	aBrowser morph
		title: 'Graph';
		display: [ :parsers |
			| morph |
			morph := ScrollPane new.
			morph scroller addMorph: (self productionFor: parsers) morphicShape.
			morph ]
]

{ #category : #browse }
PPBrowser >> browseOn: aBrowser [
	aBrowser title: 'PetitParser Browser'; color: Color purple lighter lighter.
	aBrowser column: #parsers; column: #production span: 3.
	
	aBrowser showOn: #parsers; using: [ 
		self browseParserOn: aBrowser ].
	aBrowser showOn: #production; from: #parsers -> #selectionPath; using: [
		self browseSourceOn: aBrowser.
		self browseTestOn: aBrowser.
		self browseGraphOn: aBrowser.
		self browseExampleOn: aBrowser.
		self browseFirstOn: aBrowser.
		self browseFollowOn: aBrowser ]
]

{ #category : #'browse-parts' }
PPBrowser >> browseParserOn: aBrowser [
	aBrowser tree
		format: [ :value | value asString ];
		children: [ :value | self childrenOf: value ];
		act: [ :node | 
			StandardToolSet
				browse: (self classFor: node selectionPath)
				selector: (self selectorFor: node selectionPath) ]
			on: $b entitled: 'browse (b)';
		act: [ :node :parsers | 
			| class selector |
			class := self classFor: node selectionPath.
			selector := self selectorFor: node selectionPath.
			selector = #start
				ifTrue: [ class removeFromSystem ]
				ifFalse: [
					(class allInstVarNames includes: selector asString)
						ifTrue: [ class removeInstVarName: selector asString ].
					class removeSelector: selector ].
			aBrowser entity: self model.
			((aBrowser paneNamed: #parsers)
				port: #selection) 
					value: class ]
			on: $x entitled: 'remove (x)'
]

{ #category : #'browse-parts' }
PPBrowser >> browseSourceOn: aBrowser [
	aBrowser text
		title: 'Source';
		display: [ :parsers | 
			(self classFor: parsers)
				sourceCodeAt: (self selectorFor: parsers) ];
		forSmalltalk: [ :parsers | self classFor: parsers ];
		act: [ :node :parsers | 
			| class selector |
			class := self classFor: parsers.
			selector := class compile: node text asString.
			(selector numArgs = 0 and: [ (class allInstVarNames includes: selector asString) not ])
				ifTrue: [ class addInstVarName: selector asString ].
			aBrowser entity: self model.
			((aBrowser paneNamed: #parsers) 
				port: #selection)
				value: selector ]
		on: $s entitled: 'accept (s)'
		
]

{ #category : #'browse-parts' }
PPBrowser >> browseTestOn: aBrowser [
	| browser contents |
	browser := aBrowser table.
	browser title: 'Test'; row: #input; row: #output.
	
	contents := String new.
	browser showOn: #input; using: [
		browser text
			display: [ :parsers | contents ];
			update: #selection on: $s entitled: 'parse (s)' with: [ :presentation | 
				contents := presentation text copy ] ].
	browser showOn: #output; from: #outer -> #entity; from: #input; using: [
		browser text
			useExplicitNotNil;
			when: [ :parsers | parsers notNil ];
			display: [ :parsers | 
				(self productionFor: parsers)
					parse: contents asParserStream ] ]
]

{ #category : #querying }
PPBrowser >> childrenOf: aBehavior [
	| variables |
	aBehavior isBehavior
		ifFalse: [ ^ Array new ].
	variables := ((aBehavior allInstVarNames
		copyWithoutAll: self root allInstVarNames)
			collect: [ :each | each asSymbol ])
				select: [ :each | aBehavior includesSelector: each ].
	^ OrderedCollection new
		addAll: (aBehavior subclasses asSortedCollection: [ :a :b | a name < b name ]);
		addAll: (variables asSortedCollection);
		yourself
]

{ #category : #querying }
PPBrowser >> classFor: aSelectionPath [
	aSelectionPath reverseDo: [ :each |
		each isBehavior
			ifTrue: [ ^ each ] ].
	^ self root
]

{ #category : #accessing }
PPBrowser >> model [
	^ self childrenOf: self root
]

{ #category : #public }
PPBrowser >> open [
	| browser |
	browser := GLMTableLayoutBrowser new.
	self browseOn: browser.
	browser openOn: self model
]

{ #category : #querying }
PPBrowser >> parserFor: aSelectionPath [
	aSelectionPath reverseDo: [ :each |
		each isBehavior
			ifTrue: [ ^ each ] ].
	^ self root
]

{ #category : #querying }
PPBrowser >> productionFor: aSelectionPath [
	| parser selector |
	parser := (self classFor: aSelectionPath) new.
	selector := self selectorFor: aSelectionPath.
	^ selector = #start 
		ifFalse: [ parser instVarNamed: selector ]
		ifTrue: [ parser ]
]

{ #category : #accessing }
PPBrowser >> root [
	^ PPCompositeParser
]

{ #category : #querying }
PPBrowser >> selectorFor: aSelectionPath [
	^ (aSelectionPath isEmpty or: [ aSelectionPath last isBehavior ])
		ifFalse: [ aSelectionPath last ]
		ifTrue: [ #start ]
]
