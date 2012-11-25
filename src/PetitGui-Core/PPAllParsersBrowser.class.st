"
self open
"
Class {
	#name : #PPAllParsersBrowser,
	#superclass : #GLMCompositePresentation,
	#category : #'PetitGui-Core'
}

{ #category : #'as yet unclassified' }
PPAllParsersBrowser class >> open [ 
	^ self new openOn: PPCompositeParser
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

{ #category : #building }
PPAllParsersBrowser >> compose [
	"self open"
	self title: 'PetitParser Browser'.
	self tabulator with: [ :tabulator | 
		tabulator 
			column: #classes;
			column: #parser span: 3.
		tabulator transmit to: #classes; andShow: [:a | 
			self classesIn: a ]. 
		tabulator transmit to: #parser; from: #classes; andShow: [:a | 
			a custom: PPParserBrowser new noTitle ]
	]
]
