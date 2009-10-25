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
	^ super arrayLiteral ==> [ :nodes | RBLiteralNode value: (nodes second collect: [ :each | each value ]) asArray ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> arrayLiteralArray [
	^ super arrayLiteralArray ==> [ :nodes | RBLiteralNode value: (nodes second collect: [ :each | each value ]) asArray ]
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
PPSmalltalkCompiler >> buildString: aString [ 
	(aString isEmpty not and: [ aString first = $# ]) 
		ifTrue: [ ^ (self buildString: aString allButFirst) asSymbol ].
	(aString isEmpty or: [ aString first ~= $' or: [ aString last ~= $' ] ])
		ifTrue: [ ^ aString ].
	^ (aString 
		copyFrom: 2
		to: aString size - 1) 
		copyReplaceAll: ''''''
		with: ''''
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> byteLiteral [
	^ super byteLiteral ==> [ :nodes | RBLiteralNode value: (nodes second collect: [ :each | each value ]) asByteArray ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> byteLiteralArray [
	^ super byteLiteralArray ==> [ :nodes | RBLiteralNode value: (nodes second collect: [ :each | each value ]) asByteArray ]
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
	^ super charLiteral ==> [ :token | RBLiteralNode value: token value second ]
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
	^ super falseLiteral ==> [ :token | RBLiteralNode value: false ]
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
	^ super method map: [ :declaration :body | 
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
	^ super nilLiteral ==> [ :token | RBLiteralNode value: nil ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> numberLiteral [
	^ super numberLiteral ==> [ :token | RBLiteralNode value: (Number readFrom: token value) ]
]

{ #category : #grammar }
PPSmalltalkCompiler >> parens [
	^ super parens ==> #second
]

{ #category : #grammar }
PPSmalltalkCompiler >> pragma [
	^ super pragma ==> [ :nodes | RBPragmaNode selectorParts: nodes second first arguments: nodes second second ]
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
	^ super stringLiteral ==> [ :token | RBLiteralNode value: (self buildString: token value) ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> symbolLiteral [
	^ super symbolLiteral ==> [ :token | RBLiteralNode value: (self buildString: token value) ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> symbolLiteralArray [
	^ super symbolLiteralArray ==> [ :token | RBLiteralNode value: (self buildString: token value) asSymbol ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> trueLiteral [
	^ super trueLiteral ==> [ :token | RBLiteralNode value: true ]
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
