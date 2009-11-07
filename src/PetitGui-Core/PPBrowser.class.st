Class {
	#name : #PPBrowser,
	#superclass : #Object,
	#category : #'PetitGui-Core'
}

{ #category : #'instance-creation' }
PPBrowser class >> open [
	^ self new open
]

{ #category : #'as yet unclassified' }
PPBrowser >> browserOn: aBrowser [
	aBrowser title: 'PetitParser Browser'.
	aBrowser
		column: #parsers;
		column: [ :col | 
			col 
				row: #production;
				row: [ :row |
					row
						column: #first;
						column: #follow ] ]
		span: 2.
	aBrowser showOn: #parsers; using: [ 
		aBrowser tree
			format: [ :parser | parser displayName ];
			children: [ :parser | parser productions ] ].
	aBrowser showOn: #production; from: #parsers -> #selectionPath; using: [
		aBrowser text
			title: 'Source';
			when: [ :parsers | parsers size > 1 ];
			display: [ :parsers | 
				parsers first class
					sourceCodeAt: parsers last name asSymbol ];
			forSmalltalk: [ :parsers | parsers first class ].
		aBrowser morph
			title: 'Graph';
			display: [ :parsers |
				| morph |
				morph := ScrollPane new.
				morph scroller addMorph: parsers last morphicShape.
				morph ] ].
	aBrowser showOn: #first; from: #parsers; using: [
		aBrowser list
			format: [ :parser | parser displayName ];
			display: [ :parser | parser firstSet ] ].
	aBrowser showOn: #follow; from: #parsers; using: [
		aBrowser list
			format: [ :parser | parser displayName ];
			display: [ :parser | parser followSet ] ]
]

{ #category : #'as yet unclassified' }
PPBrowser >> open [
	| browser |
	browser := GLMTableLayoutBrowser new.
	self browserOn: browser.
	browser openOn: (PPCompositeParser allSubclasses
		collect: [ :class | class named: class name ])
]
