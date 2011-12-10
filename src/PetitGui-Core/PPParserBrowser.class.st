"
self openOn: PPArithmeticParser
"
Class {
	#name : #PPParserBrowser,
	#superclass : #GLMBrowserTemplate,
	#category : #'PetitGui-Core'
}

{ #category : #building }
PPParserBrowser >> buildBrowser [
	"self openOn: PPArithmeticParser"
	browser := GLMTabulator new.
	browser title: [:each | each name].
	browser column: #productions ; column: #workspace span: 2.
	browser transmit to: #productions; andShow: [:a | 
	 	self productionsIn: a ]. 
	browser transmit to: #workspace; fromOutsidePort: #entity; from: #productions; andShow: [:a | 
		self workspaceIn: a ]. 
	browser transmit from: #workspace; toOutsidePort: #productionToSelect; 
		transformed: [:parser | parser name ];
		when: [:parser | parser name notNil ].
	browser transmit fromOutsidePort: #productionToSelect; to: #productions port: #selection.
	^ browser
]

{ #category : #'private building' }
PPParserBrowser >> exampleIn: composite [
	composite text
		title: 'Example';
		useExplicitNotNil;
		display: [ :class :productionSelector | (self production: productionSelector from: class) example ]
]

{ #category : #'private building' }
PPParserBrowser >> graphIn: composite [
	composite morph
		title: 'Graph';
		useExplicitNotNil;
		display: [ :class :selector |
			| morph |
			morph := ScrollPane new.
			morph color: Color white.
			morph scroller addMorph: (self production: selector from: class) morphicProduction.
			morph ]
]

{ #category : #'private refactoring' }
PPParserBrowser >> handleError: anException [
	self halt.
	anException actionBlock isNil
		ifTrue: [ UIManager default inform: anException messageText ]
		ifFalse: [ 
			(UIManager default confirm: anException messageText) 
				ifTrue: [ anException actionBlock value ] ].
	anException return
]

{ #category : #'private refactoring' }
PPParserBrowser >> handleWarning: anException [ 
	| message |
	message := (anException messageText endsWith: '?')
		ifTrue: [ anException messageText ]
		ifFalse: [ anException messageText , String cr , 'Do you want to proceed?' ].
	(UIManager default confirm: message)
		ifTrue: [ anException resume ]
		ifFalse: [ anException return ]
]

{ #category : #'private building' }
PPParserBrowser >> inspectorIn: composite [
	composite dynamic
		title: 'Inspector';
		display: [ :class :parser | 
					| wrapperBrowser |
					wrapperBrowser := GLMTabulator new.
					wrapperBrowser column: #wrapped.
					wrapperBrowser transmit
						to: #wrapped;
						andShow: [ :a | a custom: PPParserInspector new browser noTitle ].
					wrapperBrowser startOn: (class new productionAt: parser) ]
]

{ #category : #'private building' }
PPParserBrowser >> mapIn: composite [
	self class environment at: #GLMMondrianPresentation ifPresent: [ :cls |
		composite mondrian
			title: 'Map';
			useExplicitNotNil;
			painting: [ :view :class :selector |
				(self production: #start from: class)
					viewAllNamedParsersWithSelection: (Array with: selector)  
					previewing: [:eachParser | self sourceCodeFrom: class selector: eachParser name ]
					on:  view ] ]	

]

{ #category : #'private refactoring' }
PPParserBrowser >> performRefactoring: aRefactoring [
	[ [ aRefactoring execute ]
		on: RBRefactoringWarning
		do: [ :exception | self handleWarning: exception ] ]
		on: RBRefactoringError
		do: [ :exception | self handleError: exception ]
]

{ #category : #'private utilities' }
PPParserBrowser >> production: selector from: class [
	| parser |
	parser := class new.
	^ selector isNil 
		ifTrue: [ parser ]
		ifFalse: [ parser productionAt: selector ]
]

{ #category : #'private utilities' }
PPParserBrowser >> productionSelectorsFrom: class [
	^ (((class allInstVarNames copyWithoutAll: class ignoredNames) 
		collect: [ :each | each asSymbol ])
			select: [ :each | class includesSelector: each ]) asSortedCollection
]

{ #category : #'private building' }
PPParserBrowser >> productionsIn: composite [
	composite list
		title: [ :class | class name ];
		format: [ :class | class asString ];
		display: [ :class | self productionSelectorsFrom: class ];
		shouldValidate: true;
		
		"Doru: These menus should be built dynamically: title and enabled status should adapt"
		selectionAct: [ :list :class |
 			RBRefactoryChangeManager instance
				redoOperation.
			list pane browser update ]
			"enabled: RBRefactoryChangeManager instance hasRedoableOperations"
			entitled: 'Redo' " , RBRefactoryChangeManager instance redoChange";
		selectionAct: [ :list :class |
 			RBRefactoryChangeManager instance
				undoOperation.
			list pane browser update ]
			"enabled: RBRefactoryChangeManager instance hasUndoableOperations"
			entitled: 'Undo ' " , RBRefactoryChangeManager instance undoChange ";

		"Doru: Need a horizontal ruler here"
		selectionAct: [ :list :class | 
			self performRefactoring: (PPRenameProdcutionRefactoring
				onClass: class
				rename: list selection
				to: (UIManager default
					request: 'Production name:'
					initialAnswer: list selection)).
			list pane browser update ]  
			on: $r
			entitled: 'Rename (r)';
		selectionAct: [ :list :class | 
			self performRefactoring: (PPRemoveProdcutionRefactoring
				onClass: class 
				production: list selection).
			list pane browser update ]  
			on: $x
			entitled: 'Remove (x)';

		"Doru: Need a horizontal ruler here"
		selectionAct: [ :list :class | StandardToolSet browse: class selector: list selection ] 
			on: $b 
			entitled: 'Browse (b)'
]

{ #category : #'private building' }
PPParserBrowser >> sourceCodeFrom: class selector: production [
	^ class sourceCodeAt: (production ifNil: [ #start ]) ifAbsent: [ String new ]
]

{ #category : #'private building' }
PPParserBrowser >> sourceIn: composite [
	composite smalltalkCode
		title: 'Source';
		useExplicitNotNil;
		display: [ :class :production | self sourceCodeFrom: class selector: production ];
		smalltalkClass: [ :class | class ];
		act: [ :text :class :production | 
				| selector refactoring |
				refactoring := PPDefineProdcutionRefactoring 	
						onClass: class 
						source: text text asString 
						protocols: #(grammar).
				self performRefactoring: refactoring.
				selector := refactoring changes changes last selector.
				selector = production 
					ifTrue: [text update]
					ifFalse: [
						text pane browser update.
						(text pane port: #productionToSelect) value: selector ] ]
			icon: GLMUIThemeExtraIcons glamorousAccept
			on: $s
			entitled: 'Accept'
]

{ #category : #'private building' }
PPParserBrowser >> workspaceIn: composite [
	self sourceIn: composite.
	self graphIn: composite.
	self mapIn: composite.
	self exampleIn: composite.
	self inspectorIn: composite.

]
