Class {
	#name : #PPSmalltalkCompiler,
	#superclass : #PPSmalltalkGrammar,
	#category : #'PetitSmalltalk-Core'
}

{ #category : #grammar }
PPSmalltalkCompiler >> array [
	^ super array ==> 
		[ :nodes | 
		RBArrayNode 
			leftBrace: nodes first
			rightBrace: nodes last
			statements: nodes second ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> arrayLiteral [
	^ super arrayLiteral ==> [ :nodes | RBLiteralNode value: nodes second asArray ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> arrayLiteralArray [
	^ super arrayLiteralArray ==> [ :nodes | nodes second asArray ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> arrayLiteralByte [
	^ super arrayLiteralByte ==> [ :nodes | nodes second asByteArray ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> arrayLiteralChar [
	^ super arrayLiteralChar ==> [ :token | token value second ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> arrayLiteralFalse [
	^ super arrayLiteralFalse ==> [ :token | false ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> arrayLiteralNil [
	^ super arrayLiteralNil ==> [ :token | nil ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> arrayLiteralNumber [
	^ super arrayLiteralNumber ==> [ :token | Number readFrom: token value ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> arrayLiteralString [
	^ super arrayLiteralString ==> [ :token | self buildString: token value ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> arrayLiteralSymbol [
	^ super arrayLiteralSymbol ==> [ :token | (self buildString: token value) asSymbol ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> arrayLiteralTrue [
	^ super arrayLiteralTrue ==> [ :token | true ]
]

{ #category : #grammar }
PPSmalltalkCompiler >> assignment [
	^ super assignment ==> #first
]

{ #category : #'grammar-messages' }
PPSmalltalkCompiler >> binaryExpression [
	^ super binaryExpression map: 
		[ :receiver :messages | 
		self 
			build: receiver
			messages: messages ]
]

{ #category : #'grammar-blocks' }
PPSmalltalkCompiler >> block [
	^ super block ==> #second
]

{ #category : #'grammar-blocks' }
PPSmalltalkCompiler >> blockArgument [
	^ super blockArgument ==> #second
]

{ #category : #'grammar-blocks' }
PPSmalltalkCompiler >> blockArgumentsEmpty [
	^ super blockArgumentsEmpty ==> 
		[ :nodes | 
		#() ]
]

{ #category : #'grammar-blocks' }
PPSmalltalkCompiler >> blockBody [
	^ super blockBody ==> 
		[ :nodes | 
		RBBlockNode 
			arguments: nodes first
			body: nodes last ]
]

{ #category : #'grammar-blocks' }
PPSmalltalkCompiler >> blockSequenceEmpty [
	^ super blockSequenceEmpty ==> [ :nodes | RBSequenceNode statements: #() ]
]

{ #category : #private }
PPSmalltalkCompiler >> build: aNode assignment: anArray [ 
	^ anArray isEmpty 
		ifTrue: [ aNode ]
		ifFalse: 
			[ anArray reverse 
				inject: aNode
				into: 
					[ :result :each | 
					RBAssignmentNode 
						variable: each
						value: result ] ]
]

{ #category : #private }
PPSmalltalkCompiler >> build: aNode cascade: anArray [ 
	| messages |
	^ (anArray isNil or: [ anArray isEmpty ]) 
		ifTrue: [ aNode ]
		ifFalse: 
			[ messages := OrderedCollection new: anArray size + 1.
			messages addLast: aNode.
			anArray do: 
				[ :each | 
				messages addLast: (self 
						build: aNode receiver
						messages: (Array with: each second)) ].
			RBCascadeNode messages: messages ]
]

{ #category : #private }
PPSmalltalkCompiler >> build: aNode messages: anArray [ 
	^ (anArray isNil or: [ anArray isEmpty ]) 
		ifTrue: [ aNode ]
		ifFalse: 
			[ anArray 
				inject: aNode
				into: 
					[ :rec :msg | 
					msg isNil 
						ifTrue: [ rec ]
						ifFalse: 
							[ RBMessageNode 
								receiver: rec
								selectorParts: msg first
								arguments: msg second ] ] ]
]

{ #category : #private }
PPSmalltalkCompiler >> build: aTempCollection sequence: aStatementCollection [ 
	^ (aTempCollection isEmpty 
		ifTrue: [ RBSequenceNode new ]
		ifFalse: 
			[ RBSequenceNode 
				leftBar: aTempCollection first
				temporaries: aTempCollection second
				rightBar: aTempCollection last ])
		statements: aStatementCollection;
		yourself
]

{ #category : #private }
PPSmalltalkCompiler >> buildPragma: anArray [ 
	^ Pragma 
		keyword: (anArray first 
			inject: String new
			into: [ :result :each | result , each value ]) asSymbol
		arguments: anArray second
]

{ #category : #private }
PPSmalltalkCompiler >> buildString: aString [ 
	(aString isEmpty not and: [ aString first = $# ]) ifTrue: [ ^ (self buildString: aString allButFirst) asSymbol ].
	(aString isEmpty or: [ aString first ~= $' or: [ aString last ~= $' ] ]) ifTrue: [ ^ aString ].
	^ (aString 
		copyFrom: 2
		to: aString size - 1) 
		copyReplaceAll: ''''''
		with: ''''
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> byteLiteral [
	^ super byteLiteral ==> [ :nodes | RBLiteralNode value: nodes second asByteArray ]
]

{ #category : #'grammar-messages' }
PPSmalltalkCompiler >> cascadeExpression [
	^ super cascadeExpression map: 
		[ :receiver :messages | 
		self 
			build: receiver
			cascade: messages ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> charLiteral [
	^ super charLiteral ==> 
		[ :token | 
		RBLiteralNode 
			literalToken: token
			value: token value second ]
]

{ #category : #grammar }
PPSmalltalkCompiler >> expression [
	^ super expression map: 
		[ :vars :expr | 
		self 
			build: expr
			assignment: vars ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> falseLiteral [
	^ super falseLiteral ==> 
		[ :token | 
		RBLiteralNode 
			literalToken: token
			value: false ]
]

{ #category : #'grammar-messages' }
PPSmalltalkCompiler >> keywordExpression [
	^ super keywordExpression map: 
		[ :rec :msg | 
		self 
			build: rec
			messages: (Array with: msg) ]
]

{ #category : #grammar }
PPSmalltalkCompiler >> method [
	^ super method map: 
		[ :declaration :body | 
		declaration pragmas: body first.
		declaration body: (self 
				build: body second
				sequence: body third).
		declaration ]
]

{ #category : #grammar }
PPSmalltalkCompiler >> methodDeclaration [
	^ super methodDeclaration ==> 
		[ :nodes | 
		RBMethodNode 
			selectorParts: nodes first
			arguments: nodes second ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> nilLiteral [
	^ super nilLiteral ==> 
		[ :token | 
		RBLiteralNode 
			literalToken: token
			value: nil ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> numberLiteral [
	^ super numberLiteral ==> 
		[ :token | 
		RBLiteralNode 
			literalToken: token
			value: (Number readFrom: token value) ]
]

{ #category : #grammar }
PPSmalltalkCompiler >> parens [
	^ super parens ==> #second
]

{ #category : #grammar }
PPSmalltalkCompiler >> pragma [
	^ super pragma ==> 
		[ :nodes | 
		| prag |
		prag := self buildPragma: nodes second.
		RBPragmaNode 
			pragma: prag
			spec: prag keyword
			start: nodes first start
			stop: nodes last stop
			firstToken: nodes first
			lastToken: nodes last ]
]

{ #category : #grammar }
PPSmalltalkCompiler >> return [
	^ super return map: [ :token :expr | RBReturnNode value: expr ]
]

{ #category : #grammar }
PPSmalltalkCompiler >> sequence [
	^ super sequence map: 
		[ :temps :stats | 
		self 
			build: temps
			sequence: stats ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> stringLiteral [
	^ super stringLiteral ==> 
		[ :token | 
		RBLiteralNode 
			literalToken: token
			value: (self buildString: token value) ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> symbolLiteral [
	^ super symbolLiteral ==> 
		[ :node | 
		RBLiteralNode 
			literalToken: node
			value: (self buildString: node value) ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> trueLiteral [
	^ super trueLiteral ==> 
		[ :token | 
		RBLiteralNode 
			literalToken: token
			value: true ]
]

{ #category : #'grammar-messages' }
PPSmalltalkCompiler >> unaryExpression [
	^ super unaryExpression map: 
		[ :receiver :messages | 
		self 
			build: receiver
			messages: messages ]
]

{ #category : #grammar }
PPSmalltalkCompiler >> variable [
	^ super variable ==> [ :token | RBVariableNode identifierToken: token ]
]
