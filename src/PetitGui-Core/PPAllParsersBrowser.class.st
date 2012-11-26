"
self open
"
Class {
	#name : #PPAllParsersBrowser,
	#superclass : #GLMGlobalBrowserTemplate,
	#category : #'PetitGui-Core'
}

{ #category : #building }
PPAllParsersBrowser >> buildBrowser [
	"self open"
	browser := GLMTabulator new.
	browser title: 'PetitParser Browser'.
	browser 
		column: #classes;
		column: #parser span: 3.
	browser transmit to: #classes; andShow: [:a | 
		self classesIn: a ]. 
	browser transmit to: #parser; from: #classes; andShow: [:a | 
		a custom: PPParserBrowser new browser noTitle ].
	^ browser
]

{ #category : #'private building' }
PPAllParsersBrowser >> classesIn: composite [
	composite tree
		title: 'Grammars';
		format: [ :class | class name ];
		children: [ :class | class subclasses asSortedCollection: [ :a :b | a name < b name ] ];
		display: [ :class | class subclasses asSortedCollection: [ :a :b | a name < b name ] ];
		selectionAct: [ :list :class | Smalltalk tools browser fullOnClass: list selection ]
			on: $b
			entitled: 'Browse (b)'	
]

{ #category : #opening }
PPAllParsersBrowser >> entity [
	^ PPCompositeParser
]
