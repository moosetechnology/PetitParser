Class {
	#name : #PPSmalltalkCompiler,
	#superclass : #PPSmalltalkGrammar,
	#category : #'PetitSmalltalk-Core'
}

{ #category : #grammar }
PPSmalltalkCompiler >> array [
	^ super array ==> [ :nodes | 
		(self buildArray: nodes second)
			left: nodes first start;
			right: nodes last start;
			yourself ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> arrayLiteral [
	^ super arrayLiteral ==> [ :nodes | RBLiteralArrayNode startPosition: nodes first start contents: nodes second stopPosition: nodes last start isByteArray: false ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> arrayLiteralArray [
	^ super arrayLiteralArray ==> [ :nodes | RBLiteralArrayNode startPosition: nodes first start contents: nodes second stopPosition: nodes last start isByteArray: false ]
]

{ #category : #'grammar-messages' }
PPSmalltalkCompiler >> binaryExpression [
	^ super binaryExpression map: [ :receiver :messages | self build: receiver messages: messages ]
]

{ #category : #'grammar-blocks' }
PPSmalltalkCompiler >> block [
	^ super block map: [ :left :block :right | block left: left start; right: right start ]
]

{ #category : #'grammar-blocks' }
PPSmalltalkCompiler >> blockArgument [
	^ super blockArgument ==> #second
]

{ #category : #'grammar-blocks' }
PPSmalltalkCompiler >> blockArgumentsEmpty [
	^ super blockArgumentsEmpty ==> [ :nodes | #() ]
]

{ #category : #'grammar-blocks' }
PPSmalltalkCompiler >> blockBody [
	^ super blockBody ==> [ :nodes | RBBlockNode arguments: nodes first body: nodes last ]
]

{ #category : #'grammar-blocks' }
PPSmalltalkCompiler >> blockSequenceEmpty [
	^ super blockSequenceEmpty ==> [ :nodes | RBSequenceNode statements: #() ]
]

{ #category : #private }
PPSmalltalkCompiler >> build: aNode assignment: anArray [
	^ anArray isEmpty
		ifTrue: [ aNode ]
		ifFalse: [
			anArray reverse 
				inject: aNode
				into: [ :result :each |
					RBAssignmentNode 
						variable: each first
						value: result
						position: each second start ] ]
]

{ #category : #private }
PPSmalltalkCompiler >> build: aNode cascade: anArray [ 
	| messages |
	^ (anArray isNil or: [ anArray isEmpty ]) 
		ifTrue: [ aNode ]
		ifFalse: [
			messages := OrderedCollection new: anArray size + 1.
			messages addLast: aNode.
			anArray do: [ :each | 
				messages addLast: (self 
					build: aNode receiver
					messages: (Array with: each second)) ].
			RBCascadeNode messages: messages ]
]

{ #category : #private }
PPSmalltalkCompiler >> build: aNode messages: anArray [ 
	^ (anArray isNil or: [ anArray isEmpty ]) 
		ifTrue: [ aNode ]
		ifFalse: [
			anArray 
				inject: aNode
				into: [ :rec :msg | 
					msg isNil 
						ifTrue: [ rec ]
						ifFalse: [
							RBMessageNode 
								receiver: rec
								selectorParts: msg first
								arguments: msg second ] ] ]
]

{ #category : #private }
PPSmalltalkCompiler >> build: aTempCollection sequence: aStatementCollection [
	| nodes periods result |
	nodes := OrderedCollection new.
	periods := OrderedCollection new.
	aStatementCollection do: [ :each |
		(each isKindOf: RBProgramNode)
			ifTrue: [ nodes add: each ]
			ifFalse: [ periods add: each start ] ].
	result := RBSequenceNode statements: nodes.
	result periods: periods.
	aTempCollection isEmpty ifFalse: [
		result
			leftBar: aTempCollection first start
			temporaries: aTempCollection second
			rightBar: aTempCollection last start ].
	^ result
]

{ #category : #private }
PPSmalltalkCompiler >> buildArray: aStatementCollection [
	| nodes periods result |
	nodes := OrderedCollection new.
	periods := OrderedCollection new.
	aStatementCollection do: [ :each |
		(each isKindOf: RBProgramNode)
			ifTrue: [ nodes add: each ]
			ifFalse: [ periods add: each start ] ].
	result := RBArrayNode statements: nodes.
	result periods: periods.
	^ result
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
	^ super byteLiteral ==> [ :nodes | RBLiteralArrayNode startPosition: nodes first start contents: nodes second stopPosition: nodes last start isByteArray: true ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> byteLiteralArray [
	^ super byteLiteralArray ==> [ :nodes | RBLiteralArrayNode startPosition: nodes first start contents: nodes second stopPosition: nodes last start isByteArray: true ]
]

{ #category : #'grammar-messages' }
PPSmalltalkCompiler >> cascadeExpression [
	^ super cascadeExpression map: [ :receiver :messages | self build: receiver cascade: messages ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> charLiteral [
	^ super charLiteral ==> [ :token | RBLiteralValueNode literalToken: (RBLiteralToken value: token value second start: token start stop: token stop) ]
]

{ #category : #grammar }
PPSmalltalkCompiler >> expression [
	^ super expression map: [ :vars :expr | self build: expr assignment: vars ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> falseLiteral [
	^ super falseLiteral ==> [ :token | RBLiteralValueNode literalToken: (RBLiteralToken value: false start: token start stop: token stop) ]
]

{ #category : #'grammar-messages' }
PPSmalltalkCompiler >> keywordExpression [
	^ super keywordExpression map: [ :receiver :message | self build: receiver messages: (Array with: message) ]
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
	^ super methodDeclaration ==> [ :nodes | 
		RBMethodNode 
			selectorParts: nodes first
			arguments: nodes second ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> nilLiteral [
	^ super nilLiteral ==> [ :token | RBLiteralValueNode literalToken: (RBLiteralToken value: nil start: token start stop: token stop) ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> numberLiteral [
	^ super numberLiteral ==> [ :token | RBLiteralValueNode literalToken: (RBNumberLiteralToken value: (Number readFrom: token value) start: token start stop: token stop source: token value) ]
]

{ #category : #grammar }
PPSmalltalkCompiler >> parens [
	^ super parens map: [ :open :expr :close | expr addParenthesis: (open start to: close start) ]
]

{ #category : #grammar }
PPSmalltalkCompiler >> pragma [
	^ super pragma ==> [ :nodes | 
		(RBPragmaNode selectorParts: nodes second first arguments: nodes second second)
			left: nodes first start;
			right: nodes last start;
			yourself ]
]

{ #category : #grammar }
PPSmalltalkCompiler >> return [
	^ super return map: [ :token :expr | RBReturnNode return: token start value: expr ]
]

{ #category : #grammar }
PPSmalltalkCompiler >> sequence [
	^ super sequence map: [ :temps :stats | self build: temps sequence: stats ]
]

{ #category : #accessing }
PPSmalltalkCompiler >> start [
	^ ([ :stream | stream collection ] asParser and , super start)
		map: [ :source :node | node source: source ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> stringLiteral [
	^ super stringLiteral ==> [ :token | RBLiteralValueNode literalToken: (RBLiteralToken value: (self buildString: token value) start: token start stop: token stop) ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> symbolLiteral [
	^ super symbolLiteral ==> [ :token | RBLiteralValueNode literalToken: (RBLiteralToken value: (self buildString: token value) start: token start stop: token stop) ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> symbolLiteralArray [
	^ super symbolLiteralArray ==> [ :token | RBLiteralValueNode literalToken: (RBLiteralToken value: (self buildString: token value) asSymbol start: token start stop: token stop) ]
]

{ #category : #'grammar-literals' }
PPSmalltalkCompiler >> trueLiteral [
	^ super trueLiteral ==> [ :token | RBLiteralValueNode literalToken: (RBLiteralToken value: true start: token start stop: token stop) ]
]

{ #category : #'grammar-messages' }
PPSmalltalkCompiler >> unaryExpression [
	^ super unaryExpression map: [ :receiver :messages | self build: receiver messages: messages ]
]

{ #category : #grammar }
PPSmalltalkCompiler >> variable [
	^ super variable ==> [ :token | RBVariableNode identifierToken: token ]
]
