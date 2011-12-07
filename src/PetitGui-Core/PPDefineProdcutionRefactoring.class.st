Class {
	#name : #PPDefineProdcutionRefactoring,
	#superclass : #PPGrammarRefactoring,
	#instVars : [
		'source',
		'method'
	],
	#category : #'PetitGui-Refactoring'
}

{ #category : #private }
PPDefineProdcutionRefactoring >> checkSource [
	| rewriter |
	method := RBParser
		parseMethod: source
		onError: [ :string :position | ^ false ].
	((rewriter := self rewriter) executeTree: method)
		ifTrue: [ method := rewriter tree ].
	^ method selector isUnary
]

{ #category : #preconditions }
PPDefineProdcutionRefactoring >> preconditions [
	^ super preconditions & (RBCondition withBlock: [ self checkSource ] errorString: 'Unable to parse source code')
]

{ #category : #initialization }
PPDefineProdcutionRefactoring >> setSource: aString [
	source := aString
]

{ #category : #private }
PPDefineProdcutionRefactoring >> sourceRewriter [
	^ RBParseTreeRewriter new
		replace: '`#literal' with: '`#literal asParser' when: [ :node |
			(node isLiteralNode and: [ node value isString or: [ node value isCharacter ] ])
				and: [ (node parent isNil or: [ node parent isMessage not or: [ node parent selector ~= #asParser ] ])
				and: [ (node parents noneSatisfy: [ :each | each isBlock ]) ] ] ];
		replaceMethod: '`@method: `@args | `@temps | ``@.statements. ``.statement `{ :node | node isReturn not }' 
			with: '`@method: `@args | `@temps | ``@.statements. ^ ``.statement'.
]

{ #category : #transforming }
PPDefineProdcutionRefactoring >> transform [
	(self selector isUnary and: [ (class definesInstanceVariable: self variable) not ])
		ifTrue: [ class addInstanceVariable: method selector asString ].
	class compileTree: method
]
