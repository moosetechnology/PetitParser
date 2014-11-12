"
A MiniFSharpGrammar is proof of concept of FSharp indentation sensitive rules.

Instance Variables

"
Class {
	#name : #MiniFSharpGrammar,
	#superclass : #PPCompositeParser,
	#instVars : [
		'let',
		'valueDefinition',
		'expr',
		'if',
		'if_ElseBranch',
		'let_val',
		'const',
		'number',
		'pat',
		'identifier',
		'let_valNormal',
		'let_valLightweight',
		'infixOp',
		'spaces',
		'blanks',
		'kwLet',
		'_in',
		'string',
		'expr_sequence',
		'expr_terminal',
		'kwFor',
		'kwTo',
		'kwDo',
		'kwDone',
		'for',
		'expr_print',
		'semicolon',
		'_semicolon',
		'seqBlock',
		'seqBlockOffsideLine',
		'kwLetLevel',
		'kw',
		'kwIn',
		'sep',
		'forBlock',
		'_done',
		'kwForLevel'
	],
	#category : #'PetitIndent-Examples'
}

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> _done [
	^ spaces, kwDone not, (nil asParser alignedTo: seqBlockOffsideLine) not
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> _in [
	^ spaces, (nil asParser alignedTo: kwLetLevel)
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> _semicolon [
	^ spaces, (nil asParser alignedTo: seqBlockOffsideLine)
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> blanks [
	^ #blank asParser star ==> [ :tokens | #whitespaces ]
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> block [
	^ 'begin' asParser trim, expr, 'end' asParser trim
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> const [
	^ number / string
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> expr [
	^ 
	  expr_sequence
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> expr_print [
	^ spaces, 'printf' asParser, blanks, expr_terminal ==> [:tokens | OrderedCollection with: #printf with: tokens fourth ]
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> expr_sequence [
	^ expr_terminal, 
		(
		 ((semicolon trim, (expr_terminal onsideTo: seqBlockOffsideLine) optional) ==> #second)
		/ 
		 ((_semicolon trim, expr_terminal) ==> #second)
		/ 
		 (((infixOp onsideTo: seqBlockOffsideLine tolerance: 2) trim, expr_terminal) ==> #second)
		) star ==> [ :tokens | (OrderedCollection with: tokens first) addAll: tokens second; yourself ]
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> expr_terminal [
	
	^ let / for / if / expr_print / const / identifier.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> for [
	^ kwFor trim, identifier, '=' asParser trim, expr, kwTo trim, expr, kwDo trim, forBlock
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> forBlock [
	^ spaces, seqBlockOffsideLine, expr, spaces, (_done / kwDone), seqBlockOffsideLine pop ==> #third
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> identifier [
	^ kw not, #letter asParser plus flatten ==> #second
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> if [
	^ 'if' asParser trim, expr, 'then' asParser trim, expr, if_ElseBranch optional
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> if_ElseBranch [
	^ 'else' asParser trim, expr
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> infixOp [
	^ '+' asParser / '-' asParser / '*' asParser
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> kw [
	^ kwDo / kwDone / kwFor / kwIn / kwLet / kwTo
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> kwDo [
	^ 'do' asParser
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> kwDone [
	^ 'done' asParser
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> kwFor [
	^ kwForLevel, 'for' asParser
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> kwForLevel [
	^ PPPushParser new
		ref: kwForLevel
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> kwIn [
	^ 'in' asParser
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> kwLet [
	^ kwLetLevel, 'let' asParser
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> kwLetLevel [
	^ PPPushParser new
		ref: kwLetLevel
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> kwTo [
	^ 'to' asParser
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> let [
	^ let_val
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> let_val [
	^ let_valNormal / let_valLightweight
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> let_valLightweight [

	^ kwLet trim, valueDefinition, _in, expr, kwLetLevel pop ==> [ :tokens | Array with: tokens second with: tokens fourth ]
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> let_valNormal [
	^ kwLet trim, valueDefinition, kwIn trim, expr  
		==> [ :tokens | Array with: tokens second with: tokens fourth ]
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> number [
	^ #digit asParser plus flatten ==> [:token | token asNumber]
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> pat [
	^ identifier / const
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> semicolon [
	^ $; asParser
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> sep [
	^ semicolon / _semicolon
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> seqBlock [
	^ spaces, seqBlockOffsideLine, expr, seqBlockOffsideLine pop ==> #third
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> seqBlockOffsideLine [
	^ PPPushParser new
		ref: seqBlockOffsideLine
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> spaces [
	^ #space asParser star ==> [ :tokens | #whitespaces ]
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> start [
	^ seqBlock trim
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> string [
	^ $" asParser, (#any asParser starLazy: $" asParser) flatten, $" asParser ==> [ :tokens | tokens second  ]
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammar >> valueDefinition [
	^ pat, spaces, '=' asParser, seqBlock
		 ==> [ :tokens | Array with: tokens first with: tokens fourth ]
]
