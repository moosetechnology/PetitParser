Class {
	#name : #PPEbnfParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'rule',
		'identifier',
		'definition',
		'expression',
		'list',
		'separation',
		'term',
		'option',
		'optionOpen',
		'optionClose',
		'repetition',
		'repetitionOpen',
		'repetitionClose',
		'grouping',
		'groupingOpen',
		'groupingClose',
		'string',
		'terminator',
		'terminal',
		'nonterminal'
	],
	#category : #'PetitParser-Builder'
}

{ #category : #token }
PPEbnfParser >> definition [
	^ $= asParser token
]

{ #category : #grammar }
PPEbnfParser >> expression [
	^ list separatedBy: separation
]

{ #category : #grammar }
PPEbnfParser >> grouping [
	^ groupingOpen , expression , groupingClose
]

{ #category : #token }
PPEbnfParser >> groupingClose [
	^ $) asParser token
]

{ #category : #token }
PPEbnfParser >> groupingOpen [
	^ $( asParser token
]

{ #category : #token }
PPEbnfParser >> identifier [
	^ #letter asParser plus token
]

{ #category : #grammar }
PPEbnfParser >> list [
	^ term plus
]

{ #category : #grammar }
PPEbnfParser >> nonterminal [
	^ identifier
]

{ #category : #grammar }
PPEbnfParser >> option [
	^ optionOpen , expression , optionClose
]

{ #category : #token }
PPEbnfParser >> optionClose [
	^ $] asParser token
]

{ #category : #token }
PPEbnfParser >> optionOpen [
	^ $[ asParser token
]

{ #category : #grammar }
PPEbnfParser >> repetition [
	^ repetitionOpen , expression , repetitionClose
]

{ #category : #token }
PPEbnfParser >> repetitionClose [
	^ $} asParser token
]

{ #category : #token }
PPEbnfParser >> repetitionOpen [
	^ ${ asParser token
]

{ #category : #grammar }
PPEbnfParser >> rule [
	^ identifier , definition , expression , terminator
]

{ #category : #token }
PPEbnfParser >> separation [
	^ $| asParser token
]

{ #category : #accessing }
PPEbnfParser >> start [
	^ rule end
]

{ #category : #token }
PPEbnfParser >> string [
	^ (($" asParser , $" asParser not star , $" asParser) | ($' asParser , $' asParser not star , $' asParser)) token
]

{ #category : #grammar }
PPEbnfParser >> term [
	^ option | repetition | grouping | nonterminal | terminal
]

{ #category : #grammar }
PPEbnfParser >> terminal [
	^ string
]

{ #category : #token }
PPEbnfParser >> terminator [
	^ $; asParser token
]
