Class {
	#name : #PPEbnfHighlighter,
	#superclass : #PPEbnfParser,
	#category : #'PetitParser-Builder'
}

{ #category : #private }
PPEbnfHighlighter class >> apply: anObject on: aText [
	anObject isCollection
		ifTrue: [ anObject do: [ :each | self apply: each on: aText ] ].
	anObject isVariableBinding 
		ifTrue: [ aText addAttribute: anObject value from: anObject key start to: anObject key stop ].
	^ aText
]

{ #category : #parsing }
PPEbnfHighlighter class >> parse: aText [
	^ self 
		apply: (super parse: aText asString)
		on: aText
]

{ #category : #grammar }
PPEbnfHighlighter >> nonterminal [
	^ super nonterminal ==> [ :node | node -> TextEmphasis italic ]
]

{ #category : #grammar }
PPEbnfHighlighter >> terminal [
	^ super terminal ==> [ :node | node -> TextColor blue ]
]
