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
		display: [ :parsers | parsers last example ]
]

{ #category : #'browse-parts' }
PPBrowser >> browseFirstOn: aBrowser [
	aBrowser list
		title: 'First';
		format: [ :parser | parser displayName ];
		display: [ :parsers | parsers last firstSet ]
]

{ #category : #'browse-parts' }
PPBrowser >> browseFollowOn: aBrowser [
	aBrowser list
		title: 'Follow';
		format: [ :parser | parser displayName ];
		display: [ :parsers | parsers last followSet ]
]

{ #category : #'browse-parts' }
PPBrowser >> browseGraphOn: aBrowser [
	aBrowser morph
		title: 'Graph';
		display: [ :parsers |
			| morph |
			morph := ScrollPane new.
			morph scroller addMorph: parsers last morphicShape.
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
		format: [ :parser | parser displayName ];
		children: [ :parser | 
			parser productions
				asSortedCollection: [ :a :b | a displayName < b displayName ] ];
		act: [ :node | 
			StandardToolSet
				browse: (self parserClassFor: node selectionPath)
				selector: (self parserSelectorFor: node selectionPath) ]
		on: $b entitled: 'browse (b)';
		act: [ :node :parsers | 
			| class selector |
			class := self parserClassFor: node selectionPath.
			selector := self parserSelectorFor: node selectionPath.
			selector = #start
				ifTrue: [ class removeFromSystem ]
				ifFalse: [
					(class allInstVarNames includes: selector asString)
						ifTrue: [ class removeInstVarName: selector asString ].
					class removeSelector: selector ] ]
		on: $x entitled: 'remove (x)'
]

{ #category : #'browse-parts' }
PPBrowser >> browseSourceOn: aBrowser [
	aBrowser text
		title: 'Source';
		display: [ :parsers | 
			(self parserClassFor: parsers)
				sourceCodeAt: (self parserSelectorFor: parsers) ];
		forSmalltalk: [ :parsers | self parserClassFor: parsers ];
		act: [ :node :parsers | 
			| class selector |
			class := self parserClassFor: parsers.
			selector := class compile: node text asString.
			(selector numArgs = 0 and: [ (class allInstVarNames includes: selector asString) not ])
				ifTrue: [ class addInstVarName: selector asString ] ]
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
			display: [ :parsers :value | parsers last parse: contents asParserStream ] ]
]

{ #category : #public }
PPBrowser >> open [
	| browser |
	browser := GLMTableLayoutBrowser new.
	self browseOn: browser.
	browser openOn: (PPCompositeParser allSubclasses
		collect: [ :class | class named: class name ])
]

{ #category : #utilities }
PPBrowser >> parserClassFor: anArray [
	^ anArray isEmpty 
		ifFalse: [ anArray first class ]
]

{ #category : #utilities }
PPBrowser >> parserSelectorFor: anArray [
	^ anArray size > 1
		ifTrue: [ anArray second name asSymbol ]
		ifFalse: [ #start ]
]
