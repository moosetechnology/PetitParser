Class {
	#name : #PPRegexParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'regex',
		'atom',
		'escapeCharacterAtom',
		'anyAtom',
		'beginOfLineAtom',
		'endOfLineAtom',
		'characterAtom'
	],
	#category : #'PetitRegex-Core'
}

{ #category : #'grammar-atoms' }
PPRegexParser >> anyAtom [
	^ $. asParser map: [ :char | #any asParser ]
]

{ #category : #grammar }
PPRegexParser >> atom [
	^ escapeCharacterAtom / anyAtom / beginOfLineAtom / endOfLineAtom / characterAtom
]

{ #category : #'grammar-atoms' }
PPRegexParser >> beginOfLineAtom [
	^ $^ asParser map: [ :char | [ :stream | stream position or: [ (stream skip: -1; next) = Character cr ] ] asParser ]
]

{ #category : #'grammar-atoms' }
PPRegexParser >> characterAtom [
	^ #any asParser map: [ :char | char asParser ]
]

{ #category : #'grammar-atoms' }
PPRegexParser >> endOfLineAtom [
	^ $$ asParser map: [ :char | [ :stream | stream atEnd or: [ stream peek = Character cr ] ] asParser ]
]

{ #category : #'grammar-atoms' }
PPRegexParser >> escapeCharacterAtom [
	^ $\ asParser , #any asParser map: [ :escape :char | char asParser ]
]

{ #category : #grammar }
PPRegexParser >> regex [
	^ PPExpressionParser new
		term: atom;
		group: [ :g |
			g postfix: $* do: [ :atom :op | atom star ].
			g postfix: $+ do: [ :atom : op | atom plus ].
			g postfix: $? do: [ :atom :op | atom optional ] ];
		group: [ :g |
			g left: nil asParser do: [ :left :operator :right | left , right ] ];
		group: [ :g |
			g left: $| do: [ :left :operator :right | left / right ] ];
		yourself
]

{ #category : #accessing }
PPRegexParser >> start [
	^ regex end
]
