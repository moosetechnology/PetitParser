"
self open
"
Class {
	#name : #PPBrowser,
	#superclass : #GLMCompositePresentation,
	#category : #'PetitGui-Core'
}

{ #category : #'as yet unclassified' }
PPBrowser class >> open [ 
	^ self new openOn: PPCompositeParser
]

{ #category : #'private building' }
PPBrowser >> addNewSubParserOf: class in: list [
	| refactoring className |
	className := UIManager default request: 'Parser class name' initialAnswer: '' title: 'Add new parser'.
	^ className
		ifNotNil: [ 
			refactoring := PPAddParserRefactoring name: className asSymbol category: #ParserExample superclass: class.
			PPRefactoringUtils new performRefactoring: refactoring.
			list update ]
]

{ #category : #'private building' }
PPBrowser >> classesIn: composite [
	composite tree
		title: 'Parsers';
		format: [ :class | class name ];
		children: [ :class | class subclasses asSortedCollection: [ :a :b | a name < b name ] ];
		display: [ :class | class subclasses asSortedCollection: [ :a :b | a name < b name ] ];
		selectionAct: [ :list :class | Smalltalk tools browser fullOnClass: list selection ] on: $b entitled: 'Browse (b)';
		selectionAct: [ :list :class | self addNewSubParserOf: list selection in: list ]
			entitled: 'Add new sub parser';
		act: [ :list :class | self addNewSubParserOf: class in: list ]
			icon: GLMUIThemeExtraIcons glamorousAdd
			on: $+
			entitled: 'Add new parser'
]

{ #category : #building }
PPBrowser >> compose [
	"self open"
	self title: self defaultTitle.
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

{ #category : #building }
PPBrowser >> defaultTitle [
	^ 'PetitParser Browser'
]
