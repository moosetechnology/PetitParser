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
			StandardToolSet browse: self selectedClass selector: nil ] 
			on: $b entitled: 'browse (b)';
		act: [
			self selectedClass removeFromSystem.
			aBrowser entity: self rootClass ]
			on: $r entitled: 'remove (x)'
]

{ #category : #'browse-parts' }
PPBrowser >> browseExampleOn: aBrowser [
	aBrowser text
		title: 'Example';
		display: [ :parsers | self production example ]
]

{ #category : #'browse-parts' }
PPBrowser >> browseFirstOn: aBrowser [
	aBrowser list
		title: 'First';
		format: [ :parser | parser displayName ];
		display: [ :parsers | self production firstSet ]
]

{ #category : #'browse-parts' }
PPBrowser >> browseFollowOn: aBrowser [
	aBrowser list
		title: 'Follow';
		format: [ :parser | parser displayName ];
		display: [ :parsers | self production followSet ]
]

{ #category : #'browse-parts' }
PPBrowser >> browseGraphOn: aBrowser [
	aBrowser morph
		title: 'Graph';
		display: [ :parsers |
			| morph |
			morph := ScrollPane new.
			morph scroller addMorph: self production morphicShape.
			morph ]
]

{ #category : #browse }
PPBrowser >> browseOn: aBrowser [
	aBrowser title: 'PetitParser Browser'; color: Color purple lighter lighter.
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
		forSmalltalk: [ self selectedClass ];
		display: [ self sourceCode ];
		act: [ :node | 
			| class selector |
			class := self selectedClass.
			selector := class compile: node text asString.
			(selector numArgs = 0 and: [ (class allInstVarNames includes: selector) not ])
				ifTrue: [ class addInstVarName: selector asString ].
			aBrowser entity: self rootModel.
			self selectedClass: class.
			self selectedSelector: selector ]
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
	^ self selectedClass 
		sourceCodeAt: (self selectedSelector ifNil: [ #start ])
		ifAbsent: [ String new ]
]

{ #category : #querying }
PPBrowser >> subclassesOf: aBehavior [
	^ aBehavior subclasses asSortedCollection: [ :a :b | a name < b name ]
]
