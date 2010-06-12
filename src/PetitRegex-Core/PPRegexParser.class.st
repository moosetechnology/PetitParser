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
		'characterGroup',
		'quantifier',
		'characterSet',
		'characterSetClass',
		'characterSetEscape',
		'characterSetRange',
		'characterSetCharacter'
	],
	#classVars : [
		'ClassMap',
		'EscapeMap'
	],
	#category : #'PetitRegex-Core'
}

{ #category : #private }
PPRegexParser class >> atBeginOfWord: aStream [
	^ (self isWordChar: (self lastCharIn: aStream)) not and: [ self isWordChar: aStream peek ]
]

{ #category : #private }
PPRegexParser class >> atEndOfWord: aStream [
	^ (self isWordChar: (self lastCharIn: aStream)) and: [ (self isWordChar: aStream peek) not ]
]

{ #category : #private }
PPRegexParser class >> atWordBoundary: aStream [
	^ (self isWordChar: (self lastCharIn: aStream)) xor: (self isWordChar: aStream peek)
]

{ #category : #initialization }
PPRegexParser class >> condition: aBlock message: aString [
	^ [ :stream | (aBlock value: stream) ifFalse: [ PPFailure message: aString at: stream position ] ] asParser
]

{ #category : #initialization }
PPRegexParser class >> initialize [
	self initializeClassMap.
	self initializeEscapeMap
]

{ #category : #initialization }
PPRegexParser class >> initializeClassMap [
	ClassMap := Dictionary new.
	ClassMap
		at: 'alnum' put: #word asParser;
		at: 'alpha' put: #letter asParser;
		at: 'cntrl' put: #control asParser;
		at: 'digit' put: #digit asParser;
		at: 'graph' put: #control asParser negate;
		at: 'lower' put: #lowercase asParser;
		at: 'print' put: #control asParser negate;
		at: 'punct' put: #punctuation asParser;
		at: 'space' put: #space asParser;
		at: 'upper' put: #uppercase asParser;
		at: 'xdigit' put: #hex asParser
]

{ #category : #initialization }
PPRegexParser class >> initializeEscapeMap [
	EscapeMap := Dictionary new.
	EscapeMap
		"only at beginning of string"
		at: $A put: (self condition: [ :stream | stream position = 0 ] message: 'beginning of input expected');
		"only at end of string"		
		at: $Z put: (self condition: [ :stream | stream atEnd ] message: 'end of input expected');
		"an empty string at a word boundary"
		at: $b put: (self condition: [ :stream | self atWordBoundary: stream ] message: 'word boundary expected');
		"an empty string not at a word boundary"
		at: $B put: (self condition: [ :stream | (self atWordBoundary: stream) not ] message: 'no word boundary expected');
		"an empty string at the beginning of a word"
		at: $< put: (self condition: [ :stream | self atBeginOfWord: stream ] message: 'beginning of word expected');
		"an empty string at the end of a word"
		at: $> put: (self condition: [ :stream | self atEndOfWord: stream ] message: 'end of word expected');
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
		at: $S put: #space asParser negate;
		"backslash"
		at: $\ put: $\ asParser
]

{ #category : #private }
PPRegexParser class >> isWordChar: aCharacterOrNil [
	^ aCharacterOrNil ~~ nil and: [ aCharacterOrNil isAlphaNumeric ]
]

{ #category : #private }
PPRegexParser class >> lastCharIn: aStream [
	^ aStream position = 0 ifFalse: [ aStream skip: -1; next ]
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
			ifFalse: [ PPFailure message: '^ not expected' at: stream position ] ] asParser ]
]

{ #category : #'grammar-atoms' }
PPRegexParser >> characterAtom [
	^ $) asParser negate map: [ :char | char asParser ]
]

{ #category : #'grammar-atoms' }
PPRegexParser >> characterGroup [
	^ $[ asParser , $^ asParser optional , characterSet star , $] asParser map: [ :open :negate :parsers :close |
		| result |
		result := parsers
			inject: PPChoiceParser new
			into: [ :parser :each | parser / each ].
		result children size = 1
			ifTrue: [ result := result children first ].		
		negate isNil
			ifTrue: [ result ]
			ifFalse: [ result negate ] ]
]

{ #category : #'grammar-characters' }
PPRegexParser >> characterSet [
	^ characterSetClass / characterSetEscape / characterSetRange / characterSetCharacter
]

{ #category : #'grammar-characters' }
PPRegexParser >> characterSetCharacter [
	^ $] asParser negate map: [ :char | char asParser ]
]

{ #category : #'grammar-characters' }
PPRegexParser >> characterSetClass [
	^ '[:' asParser , #word asParser star flatten , ':]' asParser map: [ :open :class :close | ClassMap at: class ifAbsent: [ self error: 'Invalid character class [:' , class , ':]' ] ]
]

{ #category : #'grammar-characters' }
PPRegexParser >> characterSetEscape [
	^ escapeAtom
]

{ #category : #'grammar-characters' }
PPRegexParser >> characterSetRange [
	^ #any asParser , $- asParser , $] asParser negate
		map: [ :start :sep :stop | PPPredicateObjectParser between: start and: stop ]
]

{ #category : #'grammar-atoms' }
PPRegexParser >> endOfLineAtom [
	^ $$ asParser map: [ :char | [ :stream | 
		(stream atEnd or: [ stream peek = Character cr ])
			ifFalse: [ PPFailure message: '$ not expected' at: stream position ] ] asParser ]
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
	
	^ $+ asParser , quantifier map: [ :op :qu | qu on: nil min: 1 max: SmallInteger maxVal ]
]

{ #category : #'grammar-operators' }
PPRegexParser >> quantifier [
	^ ($+ asParser ==> [ :node | PPRepeatingParser ])
	/ ($? asParser ==> [ :node | PPLazyQuantifierStub ])
	/ (nil asParser ==> [ :node | PPGreedyQuantifierStub ])
]

{ #category : #'grammar-operators' }
PPRegexParser >> rangePiece [
	^ ${ asParser , rangePieceSpec , $} asParser , quantifier 
		map: [ :op :ra :cl :qu | qu on: nil min: ra first max: ra last ]
]

{ #category : #'grammar-operators' }
PPRegexParser >> rangePieceSpec [
	"{n,m}	at least n but not more than m times
	{n,}	at least n times
	{n}	exactly n times"
	
	^ number optional , $, asParser optional , number optional
		map: [ :n :op :m | (n ifNil: [ 0 ]) to: (m ifNil: [ SmallInteger maxVal ]) ]
]

{ #category : #grammar }
PPRegexParser >> regex [
	^ PPExpressionParser new
		term: atom;
		group: [ :g |.
			g postfix: self zeroOrOnePiece do: [ :at :op | op setParser: at ].
			g postfix: self zeroOrMorePiece do: [ :at :op | op setParser: at ].
			g postfix: self oneOrMorePiece do: [ :at :op | op setParser: at ].
			g postfix: self rangePiece do: [ :at :op | op setParser: at ] ];
		group: [ :g |
			g left: $| do: [ :left :op :right | left / right ].
			g left: nil do: [ :left :op :right | left , right ] ];
		yourself
]

{ #category : #private }
PPRegexParser >> resolveStubs: aParser [
	"In this post-processing step we need to fix the quantifiers."
	
	aParser followSets keysAndValuesDo: [ :each :set |
		(each class = PPGreedyQuantifierStub or: [ each class = PPLazyQuantifierStub ]) ifTrue: [
			each def: (each resolve: (set size = 1
				ifTrue: [ set anyOne ]
				ifFalse: [ PPChoiceParser withAll: set ])) ] ].
	^ aParser
]

{ #category : #accessing }
PPRegexParser >> start [
	^ regex end ==> [ :node | self resolveStubs: node ]
]

{ #category : #'grammar-operators' }
PPRegexParser >> zeroOrMorePiece [
	"*	0 or more times"
		
	^ $* asParser , quantifier map: [ :op :qu | qu on: nil min: 0 max: SmallInteger maxVal ]
]

{ #category : #'grammar-operators' }
PPRegexParser >> zeroOrOnePiece [
	"?	0 or 1 times"

	^ $? asParser , quantifier map: [ :op :qu | qu on: nil min: 0 max: 1 ]
]
