Class {
	#name : #PPRegexParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'regex',
		'atom',
		'anyAtom',
		'beginOfLineAtom',
		'endOfLineAtom',
		'characterAtom',
		'rangePieceSpec',
		'number',
		'groupAtom',
		'escapeAtom',
		'characterGroup'
	],
	#classVars : [
		'EscapeMap'
	],
	#category : #'PetitRegex-Core'
}

{ #category : #initialization }
PPRegexParser class >> condition: aBlock [
	^ [ :stream | (aBlock value: stream) ifFalse: [ PPFailure new ] ] asParser
]

{ #category : #initialization }
PPRegexParser class >> initialize [
	EscapeMap := Dictionary new.
	EscapeMap
		"only at beginning of string"
		at: $A put: (self condition: [ :stream | stream position = 0 ]);
		"only at end of string"		
		at: $Z put: (self condition: [ :stream | stream atEnd ]);
		"newline"
		at: $n put: Character lf asParser;
		"carriage return"
		at: $r put: Character cr asParser;
		"tab"
		at: $t put: Character tab asParser;
		"digit"
		at: $d put: #digit asParser;
		"not digit"
		at: $D put: #digit asParser negate;
		"word"
		at: $w put: #word asParser;
		"not word"
		at: $W put: #word asParser negate;
		"whitespace"
		at: $s put: #space asParser;
		"not whitespace"
		at: $S put: #space asParser negate
]

{ #category : #'grammar-atoms' }
PPRegexParser >> anyAtom [
	^ $. asParser map: [ :char | #any asParser ]
]

{ #category : #grammar }
PPRegexParser >> atom [
	^ escapeAtom / anyAtom / beginOfLineAtom / endOfLineAtom / characterGroup / groupAtom / characterAtom
]

{ #category : #'grammar-atoms' }
PPRegexParser >> beginOfLineAtom [
	^ $^ asParser map: [ :char | [ :stream | 
		(stream position = 0 or: [ (stream skip: -1; next) = Character cr ])
			ifFalse: [ PPFailure at: stream position ] ] asParser ]
]

{ #category : #'grammar-atoms' }
PPRegexParser >> characterAtom [
	^ $) asParser negate map: [ :char | char asParser ]
]

{ #category : #'grammar-atoms' }
PPRegexParser >> characterGroup [
	^ $[ asParser , $^ asParser optional , [ :stream |
			| set |
			set := OrderedCollection new.
			[ stream atEnd or: [ stream peek = $] ] ] whileFalse: [
				(stream peek = $- and: [ set notEmpty ])
					ifTrue: [ set addAll: (set removeLast to: (stream next; next)) ]
					ifFalse: [ set add: stream next ] ].
			set ] asParser , $] asParser map: [ :open :negate :set :close |
				negate isNil
					ifTrue: [ (PPPredicateParser anyOf: set asSet)  ]
					ifFalse: [ (PPPredicateParser anyOf: set asSet) negate ] ]
]

{ #category : #'grammar-atoms' }
PPRegexParser >> endOfLineAtom [
	^ $$ asParser map: [ :char | [ :stream | 
		(stream atEnd or: [ stream peek = Character cr ])
			ifFalse: [ PPFailure at: stream position ]  ] asParser ]
]

{ #category : #'grammar-atoms' }
PPRegexParser >> escapeAtom [
	^ $\ asParser , #any asParser map: [ :escape :char | EscapeMap at: char ifAbsent: [ char asParser ] ]
]

{ #category : #'grammar-atoms' }
PPRegexParser >> groupAtom [
	^ $( asParser , regex , $) asParser ==> #second
]

{ #category : #other }
PPRegexParser >> number [
	^ #digit asParser plus flatten ==> [ :token | token asInteger ]
]

{ #category : #'grammar-operators' }
PPRegexParser >> oneOrMorePiece [
	"+	1 or more times"
	
	^ $+ asParser map: [ :op | PPRepeatingParser on: nil min: 1 ]
]

{ #category : #'grammar-operators' }
PPRegexParser >> rangePiece [
	^ ${ asParser , rangePieceSpec ,  $} asParser ==> #second
]

{ #category : #'grammar-operators' }
PPRegexParser >> rangePieceSpec [
	"{n,m}	at least n but not more than m times
	{n,}	at least n times
	{n}	exactly n times"
	
	^ number optional , $, asParser optional , number optional map: [ :n :op :m | 
		PPRepeatingParser 
			on: nil
			min: (n ifNil: [ 0 ])
			max: (m ifNil: [ SmallInteger maxVal ]) ]
]

{ #category : #grammar }
PPRegexParser >> regex [
	^ PPExpressionParser new
		term: atom;
		group: [ :g |.
			g postfix: self zeroOrOnePiece do: [ :atom :op | op setParser: atom ].
			g postfix: self zeroOrMorePiece do: [ :atom :op | op setParser: atom ].
			g postfix: self oneOrMorePiece do: [ :atom :op | op setParser: atom ].
			g postfix: self rangePiece do: [ :atom :op | op setParser: atom ] ];
		group: [ :g |
			g left: nil asParser do: [ :left :op :right | left , right ] ];
		group: [ :g |
			g left: $| do: [ :left :op :right | left / right ] ];
		yourself
]

{ #category : #accessing }
PPRegexParser >> start [
	^ regex end
]

{ #category : #'grammar-operators' }
PPRegexParser >> zeroOrMorePiece [
	"*	0 or more times"
		
	^ $* asParser map: [ :op | PPRepeatingParser on: nil min: 0 ]
]

{ #category : #'grammar-operators' }
PPRegexParser >> zeroOrOnePiece [
	"?	0 or 1 times"

	^ $? asParser map: [ :op | PPRepeatingParser on: nil min: 0 max: 1 ]
]
