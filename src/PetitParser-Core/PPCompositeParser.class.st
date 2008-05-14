Class {
	#name : #PPCompositeParser,
	#superclass : #PPDelegateParser,
	#instVars : [
		'productions',
		'unresolved'
	],
	#category : #'PetitParser-Builder'
}

{ #category : #private }
PPCompositeParser class >> isActionNode: aNode [
	aNode parent isNil
		ifTrue: [ ^ false ].
	(aNode parent isSend 
		and: [ aNode parent selector = #==>
		and: [ aNode parent arguments first = aNode ] ])
			ifTrue: [ ^ true ].
	^ self isActionNode: aNode parent
]

{ #category : #rules }
PPCompositeParser class >> transformParser [
	<transform: 100>

	^ DSLConditionPattern new
		if: [ :visitor | visitor tree isMethod and: [ visitor tree selector isUnary and: [ visitor theClass ~= PPCompositeParser ] ] ]
		then: (Array
			with: (DSLSearchPattern new
				expression: '`#var';
				action: [ :visitor |
					((self isActionNode: visitor node) not and: [ visitor node value isString or: [ visitor node value isCharacter ] ])
						ifTrue: [ visitor node replaceWith: ``(`,(visitor node value) asParser) ] ])
			with: (DSLSearchPattern new
				expression: '`var';
				action: [ :visitor |
					((self isActionNode: visitor node) not
						and: [ (visitor theClass bindingOf: visitor node name) isNil
						and: [ (visitor tree allDefinedVariables includes: visitor node name) not
						and: [ (visitor theClass allInstVarNames includes: visitor node name) not
						and: [ (#('self' 'super' 'thisContext') includes: visitor node name) not ] ] ] ])
						ifTrue: [ visitor node replaceWith: (``(self selector) selector: visitor node name asSymbol) ] ])
			with: (DSLSearchPattern new
				expression: 'super `message';
				action: [ :visitor |
					| method tree |
					method := visitor theClass superclass lookupSelector: visitor node selector.
					method isNil ifFalse: [
						tree := RBParser parseMethod: method decompileString.
						tree isNil
							ifFalse: [ visitor node replaceWith: tree body statements first value arguments second body ] ] ])
			with: [ :visitor |
				visitor tree body lastIsReturn ifTrue: [
					visitor tree body statements last
						replaceWith: visitor tree body statements last value ].
				visitor tree body addNodeFirst: ``(self
					productionAt: `,(visitor tree selector)
					definition: [ `,(visitor tree body) ]).
				visitor tree body statements allButFirst
					do: [ :each | visitor tree body removeNode: each ].
				visitor tree body addReturn ])
]

{ #category : #initialization }
PPCompositeParser >> initialize [
	super initialize.
	productions := Dictionary new.
	unresolved := OrderedCollection new.
	parser := self startProduction.
	self resolve
]

{ #category : #accessing }
PPCompositeParser >> productionAt: aSymbol definition: aBlock [
	productions 
		at: aSymbol
		ifPresent: [ :production | ^ production ].
	productions
		at: aSymbol
		put: (unresolved add: (PPUnresolvedParser on: aSymbol)).
	^ productions
		at: aSymbol
		put: aBlock value
]

{ #category : #actions }
PPCompositeParser >> resolve [
	| resolved |
	unresolved := unresolved asArray.
	resolved := unresolved collect: [ :each | productions at: each symbol ].
	unresolved elementsForwardIdentityTo: resolved.
	unresolved := #()
]

{ #category : #accessing }
PPCompositeParser >> startProduction [
	"Answer the production to start this parser with."
	
	self subclassResponsibility
]
