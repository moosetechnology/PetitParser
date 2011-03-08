Class {
	#name : #PPParserBrowser,
	#superclass : #GLMBrowserTemplate,
	#category : #'PetitGui-Core'
}

{ #category : #'as yet unclassified' }
PPParserBrowser >> buildBrowser [
	"self openOn: PPArithmeticParser"
	browser := GLMTabulator new.
	browser column: #productions ; column: #workspace.
	browser transmit to: #productions; andShow: [:a | 
	 	self productionsIn: a ]. 
	browser transmit to: #workspace; fromOutside: #entity; from: #productions; andShow: [:a | 
		self workspaceIn: a ]. 
	^ browser
]

{ #category : #'private building' }
PPParserBrowser >> productionsIn: composite [
	composite list
			title: 'Productions';
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
	composite text
		title: 'Source';
		useExplicitNotNil;
		display: [ :class :production | 
			class 
				sourceCodeAt: (production ifNil: [ #start ])
				ifAbsent: [ String new ] ];
		forSmalltalk: [ :class | class ];
		act: [ :node  | 
				| class selector |
				class := self selectedClass.
				selector := self sourceCode: node text asString in: class.
				self selectedClass: class.
				self selectedSelector: selector ]
			icon: GLMUIThemeExtraIcons glamorousAccept 
			on: $s 
			entitled: 'accept (s)'
]

{ #category : #'private building' }
PPParserBrowser >> workspaceIn: composite [
	self sourceIn: composite.
	composite custom: (PPParserInspector new browser title: 'Inspector')
]
