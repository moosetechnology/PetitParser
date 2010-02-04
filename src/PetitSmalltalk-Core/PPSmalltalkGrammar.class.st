"
A parser for Smalltalk methods and expressions.
"
Class {
	#name : #PPSmalltalkGrammar,
	#superclass : #PPCompositeParser,
	#instVars : [
		'array',
		'arrayLiteral',
		'arrayLiteralArray',
		'assignment',
		'assignmentToken',
		'binary',
		'binaryExpression',
		'binaryMessage',
		'binaryMethod',
		'binaryPragma',
		'binaryToken',
		'block',
		'blockArgument',
		'blockArguments',
		'blockBody',
		'byteLiteral',
		'cascadeExpression',
		'cascadeMessage',
		'char',
		'charLiteral',
		'charToken',
		'expression',
		'falseLiteral',
		'falseToken',
		'identifier',
		'identifierToken',
		'keyword',
		'keywordExpression',
		'keywordMessage',
		'keywordMethod',
		'keywordPragma',
		'keywordToken',
		'literal',
		'message',
		'method',
		'methodDeclaration',
		'methodSequence',
		'multiword',
		'nilLiteral',
		'nilToken',
		'number',
		'numberLiteral',
		'numberToken',
		'parens',
		'pragma',
		'pragmaMessage',
		'pragmas',
		'primary',
		'return',
		'sequence',
		'statements',
		'string',
		'stringLiteral',
		'stringToken',
		'symbol',
		'symbolLiteral',
		'temporaries',
		'trueLiteral',
		'trueToken',
		'unary',
		'unaryExpression',
		'unaryMessage',
		'unaryMethod',
		'unaryPragma',
		'unaryToken',
		'variable',
		'symbolLiteralArray',
		'byteLiteralArray',
		'arrayItem',
		'blockArgumentsWith',
		'blockArgumentsWithout'
	],
	#category : #'PetitSmalltalk-Core'
}

{ #category : #parsing }
PPSmalltalkGrammar class >> parseExpression: aString [ 
	^ self parseExpression: aString onError: [ :msg :pos | self error: msg ]
]

{ #category : #parsing }
PPSmalltalkGrammar class >> parseExpression: aString onError: aBlock [
	^ self parse: aString startingAt: #startExpression onError: aBlock
]

{ #category : #parsing }
PPSmalltalkGrammar class >> parseMethod: aString [ 
	^ self parseMethod: aString onError: [ :msg :pos | self error: msg ]
]

{ #category : #parsing }
PPSmalltalkGrammar class >> parseMethod: aString onError: aBlock [
	^ self parse: aString onError: aBlock
]

{ #category : #grammar }
PPSmalltalkGrammar >> array [
	^ ${ asParser token , statements , $} asParser token
]

{ #category : #'grammar-literals' }
PPSmalltalkGrammar >> arrayItem [
	^ literal / symbolLiteralArray / arrayLiteralArray / byteLiteralArray
]

{ #category : #'grammar-literals' }
PPSmalltalkGrammar >> arrayLiteral [
	^ '#(' asParser token , arrayItem star , $) asParser token
]

{ #category : #'grammar-literals' }
PPSmalltalkGrammar >> arrayLiteralArray [
	^ $( asParser token , arrayItem star , $) asParser token
]

{ #category : #grammar }
PPSmalltalkGrammar >> assignment [
	^ variable , assignmentToken
]

{ #category : #token }
PPSmalltalkGrammar >> assignmentToken [
	^ (':=' asParser / '_' asParser) token
]

{ #category : #primitives }
PPSmalltalkGrammar >> binary [
	^ $~ asParser / $- asParser / $! asParser / $@ asParser / $% asParser / $& asParser / $* asParser / $+ asParser / $= asParser / $\ asParser / $| asParser / $? asParser / $/ asParser / $> asParser / $< asParser / $, asParser , ($~ asParser / $! asParser / $@ asParser / $% asParser / $& asParser / $* asParser / $+ asParser / $= asParser / $\ asParser / $| asParser / $? asParser / $/ asParser / $> asParser / $< asParser / $, asParser) star
]

{ #category : #'grammar-messages' }
PPSmalltalkGrammar >> binaryExpression [
	^ unaryExpression , binaryMessage star
]

{ #category : #'grammar-messages' }
PPSmalltalkGrammar >> binaryMessage [
	^ (binaryToken , unaryExpression) ==> [ :nodes | 
		Array 
			with: (Array with: nodes first)
			with: (Array with: nodes second) ]
]

{ #category : #'grammar-methods' }
PPSmalltalkGrammar >> binaryMethod [
	^ (binaryToken , variable) ==> [ :nodes | 
		Array 
			with: (Array with: nodes first)
			with: (Array with: nodes second) ]
]

{ #category : #'grammar-pragmas' }
PPSmalltalkGrammar >> binaryPragma [
	^ (binaryToken , arrayItem) ==> [ :nodes | 
		Array 
			with: (Array with: nodes first)
			with: (Array with: nodes second) ]
]

{ #category : #token }
PPSmalltalkGrammar >> binaryToken [
	^ binary token
]

{ #category : #'grammar-blocks' }
PPSmalltalkGrammar >> block [
	^ $[ asParser token , blockBody , $] asParser token
]

{ #category : #'grammar-blocks' }
PPSmalltalkGrammar >> blockArgument [
	^ $: asParser token , variable
]

{ #category : #'grammar-blocks' }
PPSmalltalkGrammar >> blockArguments [
	^ blockArgumentsWith / blockArgumentsWithout
]

{ #category : #'grammar-blocks' }
PPSmalltalkGrammar >> blockArgumentsWith [
	^ blockArgument plus , ($| asParser token / ($] asParser token and ==> [ :node | nil ]))
]

{ #category : #'grammar-blocks' }
PPSmalltalkGrammar >> blockArgumentsWithout [
	^ nil asParser ==> [ :nodes | Array with: #() with: nil ]
]

{ #category : #'grammar-blocks' }
PPSmalltalkGrammar >> blockBody [
	^ blockArguments , sequence
]

{ #category : #'grammar-literals' }
PPSmalltalkGrammar >> byteLiteral [
	^ '#[' asParser token , numberLiteral star , $] asParser token
]

{ #category : #'grammar-literals' }
PPSmalltalkGrammar >> byteLiteralArray [
	^ $[ asParser token , numberLiteral star , $] asParser token
]

{ #category : #'grammar-messages' }
PPSmalltalkGrammar >> cascadeExpression [
	^ keywordExpression , cascadeMessage star
]

{ #category : #'grammar-messages' }
PPSmalltalkGrammar >> cascadeMessage [
	^ $; asParser token , message
]

{ #category : #primitives }
PPSmalltalkGrammar >> char [
	^ $$ asParser , #any asParser
]

{ #category : #'grammar-literals' }
PPSmalltalkGrammar >> charLiteral [
	^ charToken
]

{ #category : #token }
PPSmalltalkGrammar >> charToken [
	^ char token
]

{ #category : #grammar }
PPSmalltalkGrammar >> expression [
	^ assignment star , cascadeExpression
]

{ #category : #'grammar-literals' }
PPSmalltalkGrammar >> falseLiteral [
	^ falseToken
]

{ #category : #token }
PPSmalltalkGrammar >> falseToken [
	^ ('false' asParser , #word asParser not) token
]

{ #category : #primitives }
PPSmalltalkGrammar >> identifier [
	^ #letter asParser , #word asParser star
]

{ #category : #token }
PPSmalltalkGrammar >> identifierToken [
	^ identifier token
]

{ #category : #primitives }
PPSmalltalkGrammar >> keyword [
	^ identifier , $: asParser
]

{ #category : #'grammar-messages' }
PPSmalltalkGrammar >> keywordExpression [
	^ binaryExpression , keywordMessage optional
]

{ #category : #'grammar-messages' }
PPSmalltalkGrammar >> keywordMessage [
	^ (keywordToken , binaryExpression) plus ==> [ :nodes | 
		Array 
			with: (nodes collect: [ :each | each first ])
			with: (nodes collect: [ :each | each second ]) ]
]

{ #category : #'grammar-methods' }
PPSmalltalkGrammar >> keywordMethod [
	^ (keywordToken , variable) plus ==> [ :nodes | 
		Array 
			with: (nodes collect: [ :each | each first ])
			with: (nodes collect: [ :each | each second ]) ]
]

{ #category : #'grammar-pragmas' }
PPSmalltalkGrammar >> keywordPragma [
	^ (keywordToken , arrayItem) plus ==> [ :nodes | 
		Array 
			with: (nodes collect: [ :each | each first ])
			with: (nodes collect: [ :each | each second ]) ]
]

{ #category : #token }
PPSmalltalkGrammar >> keywordToken [
	^ keyword token
]

{ #category : #grammar }
PPSmalltalkGrammar >> literal [
	^ charLiteral / numberLiteral / stringLiteral / symbolLiteral / arrayLiteral / byteLiteral / trueLiteral / falseLiteral / nilLiteral 
]

{ #category : #grammar }
PPSmalltalkGrammar >> message [
	^ keywordMessage / binaryMessage / unaryMessage
]

{ #category : #grammar }
PPSmalltalkGrammar >> method [
	^ methodDeclaration , methodSequence
]

{ #category : #grammar }
PPSmalltalkGrammar >> methodDeclaration [
	^ keywordMethod / unaryMethod / binaryMethod
]

{ #category : #grammar }
PPSmalltalkGrammar >> methodSequence [
	^ ($. asParser token star , pragmas , temporaries , pragmas , statements) ==> [ :nodes | 
		Array 
			with: nodes second , nodes fourth
			with: nodes third
			with: nodes fifth ]
]

{ #category : #primitives }
PPSmalltalkGrammar >> multiword [
	^ keyword plus
]

{ #category : #'grammar-literals' }
PPSmalltalkGrammar >> nilLiteral [
	^ nilToken
]

{ #category : #token }
PPSmalltalkGrammar >> nilToken [
	^ ('nil' asParser , #word asParser not) token
]

{ #category : #primitives }
PPSmalltalkGrammar >> number [
	^ ($- asParser optional , #digit asParser plus , ($. asParser , #digit asParser plus) optional) and , [ :stream | 
		[ Number readFrom: stream ] 
			on: Error
			do: [ :err | PPFailure reason: err messageText at: stream position ] ] 
				asParser
]

{ #category : #'grammar-literals' }
PPSmalltalkGrammar >> numberLiteral [
	^ numberToken
]

{ #category : #token }
PPSmalltalkGrammar >> numberToken [
	^ number token
]

{ #category : #grammar }
PPSmalltalkGrammar >> parens [
	^ $( asParser token , expression , $) asParser token
]

{ #category : #grammar }
PPSmalltalkGrammar >> pragma [
	^ $< asParser token , pragmaMessage , $> asParser token
]

{ #category : #'grammar-pragmas' }
PPSmalltalkGrammar >> pragmaMessage [
	^ keywordPragma / unaryPragma / binaryPragma
]

{ #category : #grammar }
PPSmalltalkGrammar >> pragmas [
	^ pragma star
]

{ #category : #grammar }
PPSmalltalkGrammar >> primary [
	^ block / parens / array / literal / variable
]

{ #category : #grammar }
PPSmalltalkGrammar >> return [
	^ $^ asParser token , expression
]

{ #category : #grammar }
PPSmalltalkGrammar >> sequence [
	^ temporaries , statements
]

{ #category : #accessing }
PPSmalltalkGrammar >> start [
	^ method end
]

{ #category : #accessing }
PPSmalltalkGrammar >> startExpression [
	^ sequence end
]

{ #category : #grammar }
PPSmalltalkGrammar >> statements [
	^ 	(expression wrapped , $. asParser token plus , statements
			==> [ :nodes | (Array with: nodes first) , (nodes second) , (nodes last) ])
	/	(expression wrapped , $. asParser token star
			==> [ :nodes | (Array with: nodes first) , (nodes second) ]) 
	/	(return , $. asParser token star
			==> [ :nodes | (Array with: nodes first) , (nodes last) ]) 
	/	($. asParser token star)
]

{ #category : #primitives }
PPSmalltalkGrammar >> string [
	^ $' asParser , ('''''' asParser / $' asParser negate) star , $' asParser
]

{ #category : #'grammar-literals' }
PPSmalltalkGrammar >> stringLiteral [
	^ stringToken
]

{ #category : #token }
PPSmalltalkGrammar >> stringToken [
	^ string token
]

{ #category : #primitives }
PPSmalltalkGrammar >> symbol [
	^ unary / binary / multiword / string
]

{ #category : #'grammar-literals' }
PPSmalltalkGrammar >> symbolLiteral [
	^ ($# asParser , symbol) token
]

{ #category : #'grammar-literals' }
PPSmalltalkGrammar >> symbolLiteralArray [
	^ symbol token
]

{ #category : #grammar }
PPSmalltalkGrammar >> temporaries [
	^ ($| asParser token , variable star , $| asParser token) optional ==> [ :nodes | nodes ifNil: [ #() ] ]
]

{ #category : #accessing }
PPSmalltalkGrammar >> tokenParser [
	^ PPSmalltalkTokenParser
]

{ #category : #'grammar-literals' }
PPSmalltalkGrammar >> trueLiteral [
	^ trueToken
]

{ #category : #token }
PPSmalltalkGrammar >> trueToken [
	^ ('true' asParser , #word asParser not) token
]

{ #category : #primitives }
PPSmalltalkGrammar >> unary [
	^ identifier , $: asParser not
]

{ #category : #'grammar-messages' }
PPSmalltalkGrammar >> unaryExpression [
	^ primary , unaryMessage star
]

{ #category : #'grammar-messages' }
PPSmalltalkGrammar >> unaryMessage [
	^ unaryToken ==> [ :node | 
		Array 
			with: (Array with: node)
			with: Array new ]
]

{ #category : #'grammar-methods' }
PPSmalltalkGrammar >> unaryMethod [
	^ identifierToken ==> [ :node | 
		Array 
			with: (Array with: node)
			with: Array new ]
]

{ #category : #'grammar-pragmas' }
PPSmalltalkGrammar >> unaryPragma [
	^ identifierToken ==> [ :node | 
		Array 
			with: (Array with: node)
			with: (Array new) ]
]

{ #category : #token }
PPSmalltalkGrammar >> unaryToken [
	^ unary token
]

{ #category : #grammar }
PPSmalltalkGrammar >> variable [
	^ identifierToken
]
