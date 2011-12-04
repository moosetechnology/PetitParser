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
						andShow: [ :a | a custom: PPParserInspector new browser ].
					wrapperBrowser startOn: (class new productionAt: parser) ]
]

{ #category : #'private building' }
PPParserBrowser >> mapIn: composite [
	self class environment at: #GLMMondrianPresentation ifPresent: [ :cls |
		composite mondrian
			title: 'Map';
			useExplicitNotNil;
			painting: [ :view :class :selector |
				(self production: selector from: class) viewAllNamedParsersOn: view ] ]	

]

{ #category : #'private utilities' }
PPParserBrowser >> production: selector from: class [
	| parser |
	parser := class new.
	^ selector isNil 
		ifTrue: [ parser ]
		ifFalse: [ parser productionAt: selector ]
]

{ #category : #'private building' }
PPParserBrowser >> productionsIn: composite [
	composite list
			title: [:class | class name ];
			format: [ :class | class asString ];
			display: [ :class | 
				((((class allInstVarNames
					copyWithoutAll: class ignoredNames))
					collect: [ :each | each asSymbol ])
					select: [ :each | class includesSelector: each ])
					asSortedCollection ];
			selectionAct: [ :list :class |
				StandardToolSet 
					browse: class 
					selector: list selection ] 
				on: $b entitled: 'browse (b)'
]

{ #category : #'private utilities' }
PPParserBrowser >> sourceCode: aString in: aClass [
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

{ #category : #'private building' }
PPParserBrowser >> sourceIn: composite [
	composite smalltalkCode
		title: 'Source';
		useExplicitNotNil;
		display: [ :class :production | 
			class 
				sourceCodeAt: (production ifNil: [ #start ])
				ifAbsent: [ String new ] ];
		smalltalkClass: [ :class | class ];
		act: [ :text :class  | 
				|  selector |
				selector := self sourceCode: text text asString in: class.
				text selection: selector ]
			icon: GLMUIThemeExtraIcons glamorousAccept 
			on: $s 
			entitled: 'accept (s)'
]

{ #category : #'private building' }
PPParserBrowser >> workspaceIn: composite [
	self sourceIn: composite.
	self mapIn: composite.
	self exampleIn: composite.
	self inspectorIn: composite.

]
