"
Enhances the Smalltalk grammar with production actions to build parse-tree nodes of the refactoring browser.
"
Class {
	#name : #PPSmalltalkParser,
	#superclass : #PPSmalltalkGrammar,
	#category : #'PetitSmalltalk-Core'
}

{ #category : #grammar }
PPSmalltalkParser >> array [
	^ super array ==> [ :nodes | 
		(self buildArray: nodes second)
			left: nodes first start;
			right: nodes last start;
			yourself ]
]

{ #category : #'grammar-literals' }
PPSmalltalkParser >> arrayLiteral [
	^ super arrayLiteral ==> [ :nodes | RBLiteralArrayNode startPosition: nodes first start contents: nodes second stopPosition: nodes last start isByteArray: false ]
]

{ #category : #'grammar-literals' }
PPSmalltalkParser >> arrayLiteralArray [
	^ super arrayLiteralArray ==> [ :nodes | RBLiteralArrayNode startPosition: nodes first start contents: nodes second stopPosition: nodes last start isByteArray: false ]
]

{ #category : #'grammar-messages' }
PPSmalltalkParser >> binaryExpression [
	^ super binaryExpression map: [ :receiverNode :messageNodes | self build: receiverNode messages: messageNodes ]
]

{ #category : #'grammar-blocks' }
PPSmalltalkParser >> block [
	^ super block map: [ :leftToken :blockNode :rightToken | blockNode left: leftToken start; right: rightToken start ]
]

{ #category : #'grammar-blocks' }
PPSmalltalkParser >> blockArgument [
	^ super blockArgument ==> #second
]

{ #category : #'grammar-blocks' }
PPSmalltalkParser >> blockBody [
	^ super blockBody ==> [ :nodes | 
		| result |
		result := RBBlockNode arguments: nodes first first body: nodes last.
		nodes first last isNil
			ifFalse: [ result bar: nodes first last start ].
		result ]
]

{ #category : #private }
PPSmalltalkParser >> build: aNode assignment: anArray [
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
PPSmalltalkParser >> build: aNode cascade: anArray [ 
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
PPSmalltalkParser >> build: aNode messages: anArray [ 
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
PPSmalltalkParser >> build: aTempCollection sequence: aStatementCollection [
	| nodes periods result |
	nodes := OrderedCollection new.
	periods := OrderedCollection new.
	aStatementCollection do: [ :each |
		(each isKindOf: RBProgramNode)
			ifTrue: [ nodes add: each ]
			ifFalse: [
				nodes isEmpty
					ifFalse: [ nodes last addComments: each comments ].
				periods add: each start ] ].
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
PPSmalltalkParser >> buildArray: aStatementCollection [
	| nodes periods result |
	nodes := OrderedCollection new.
	periods := OrderedCollection new.
	aStatementCollection do: [ :each |
		(each isKindOf: RBProgramNode)
			ifTrue: [ nodes add: each ]
			ifFalse: [
				nodes isEmpty
					ifFalse: [ nodes last addComments: each comments ].
				periods add: each start ] ].
	result := RBArrayNode statements: nodes.
	result periods: periods.
	^ result
]

{ #category : #private }
PPSmalltalkParser >> buildMethod: aMethodNode [
	aMethodNode selectorParts 
		do: [ :each | aMethodNode addComments: each comments ].
	aMethodNode arguments
		do: [ :each | aMethodNode addComments: each token comments ].
	aMethodNode pragmas do: [ :pragma |
		aMethodNode addComments: pragma comments.
		pragma selectorParts 
			do: [ :each | aMethodNode addComments: each comments ].
		pragma arguments do: [ :each | 
			each isLiteralArray
				ifFalse: [ aMethodNode addComments: each token comments ] ].
		pragma comments: nil ].
	^ aMethodNode
]

{ #category : #private }
PPSmalltalkParser >> buildString: aString [ 
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
PPSmalltalkParser >> byteLiteral [
	^ super byteLiteral ==> [ :nodes | RBLiteralArrayNode startPosition: nodes first start contents: nodes second stopPosition: nodes last start isByteArray: true ]
]

{ #category : #'grammar-literals' }
PPSmalltalkParser >> byteLiteralArray [
	^ super byteLiteralArray ==> [ :nodes | RBLiteralArrayNode startPosition: nodes first start contents: nodes second stopPosition: nodes last start isByteArray: true ]
]

{ #category : #'grammar-messages' }
PPSmalltalkParser >> cascadeExpression [
	^ super cascadeExpression map: [ :receiverNode :messageNodes | self build: receiverNode cascade: messageNodes ]
]

{ #category : #'grammar-literals' }
PPSmalltalkParser >> charLiteral [
	^ super charLiteral ==> [ :token | RBLiteralValueNode literalToken: (RBLiteralToken value: token value second start: token start stop: token stop) ]
]

{ #category : #grammar }
PPSmalltalkParser >> expression [
	^ super expression map: [ :variableNodes :expressionNodes | self build: expressionNodes assignment: variableNodes ]
]

{ #category : #'grammar-literals' }
PPSmalltalkParser >> falseLiteral [
	^ super falseLiteral ==> [ :token | RBLiteralValueNode literalToken: (RBLiteralToken value: false start: token start stop: token stop) ]
]

{ #category : #'grammar-messages' }
PPSmalltalkParser >> keywordExpression [
	^ super keywordExpression map: [ :receiveNode :messageNode | self build: receiveNode messages: (Array with: messageNode) ]
]

{ #category : #grammar }
PPSmalltalkParser >> method [
	^ super method map: [ :methodNode :bodyNode | 
		methodNode pragmas: bodyNode first.
		methodNode body: (self 
			build: bodyNode second
			sequence: bodyNode third).
		self buildMethod: methodNode ]
]

{ #category : #grammar }
PPSmalltalkParser >> methodDeclaration [
	^ super methodDeclaration ==> [ :nodes |
		RBMethodNode 
			selectorParts: nodes first
			arguments: nodes second ]
]

{ #category : #'grammar-literals' }
PPSmalltalkParser >> nilLiteral [
	^ super nilLiteral ==> [ :token | RBLiteralValueNode literalToken: (RBLiteralToken value: nil start: token start stop: token stop) ]
]

{ #category : #'grammar-literals' }
PPSmalltalkParser >> numberLiteral [
	^ super numberLiteral ==> [ :token | RBLiteralValueNode literalToken: (RBNumberLiteralToken value: (Number readFrom: token value) start: token start stop: token stop source: token value) ]
]

{ #category : #grammar }
PPSmalltalkParser >> parens [
	^ super parens map: [ :openToken :expressionNode :closeToken | expressionNode addParenthesis: (openToken start to: closeToken start) ]
]

{ #category : #grammar }
PPSmalltalkParser >> pragma [
	^ super pragma ==> [ :nodes | 
		(RBPragmaNode selectorParts: nodes second first arguments: nodes second second)
			addComments: nodes first comments;
			addComments: nodes last comments;
			left: nodes first start;
			right: nodes last start;
			yourself ]
]

{ #category : #grammar }
PPSmalltalkParser >> return [
	^ super return map: [ :token :expressionNode | RBReturnNode return: token start value: expressionNode ]
]

{ #category : #grammar }
PPSmalltalkParser >> sequence [
	^ super sequence map: [ :tempNodes :statementNodes | self build: tempNodes sequence: statementNodes ]
]

{ #category : #accessing }
PPSmalltalkParser >> startExpression [
	"Make the sequence node has a method node as its parent and that the source is set."

	^ ([ :stream | stream collection ] asParser and , super startExpression) map: [ :source :node | 
		(RBMethodNode selector: #doIt body: node)
			source: source.
		(node statements size = 1 and: [ node temporaries isEmpty ])
			ifTrue: [ node statements first ]
			ifFalse: [ node ] ]
]

{ #category : #accessing }
PPSmalltalkParser >> startMethod [
	"Make sure the method node has the source code properly set."
	
	^ ([ :stream | stream collection ] asParser and , super startMethod)
		map: [ :source :node | node source: source ]
]

{ #category : #'grammar-literals' }
PPSmalltalkParser >> stringLiteral [
	^ super stringLiteral ==> [ :token | RBLiteralValueNode literalToken: (RBLiteralToken value: (self buildString: token value) start: token start stop: token stop) ]
]

{ #category : #'grammar-literals' }
PPSmalltalkParser >> symbolLiteral [
	^ super symbolLiteral ==> [ :token | RBLiteralValueNode literalToken: (RBLiteralToken value: (self buildString: token value) start: token start stop: token stop) ]
]

{ #category : #'grammar-literals' }
PPSmalltalkParser >> symbolLiteralArray [
	^ super symbolLiteralArray ==> [ :token | RBLiteralValueNode literalToken: (RBLiteralToken value: (self buildString: token value) asSymbol start: token start stop: token stop) ]
]

{ #category : #'grammar-literals' }
PPSmalltalkParser >> trueLiteral [
	^ super trueLiteral ==> [ :token | RBLiteralValueNode literalToken: (RBLiteralToken value: true start: token start stop: token stop) ]
]

{ #category : #'grammar-messages' }
PPSmalltalkParser >> unaryExpression [
	^ super unaryExpression map: [ :receiverNode :messageNodes | self build: receiverNode messages: messageNodes ]
]

{ #category : #grammar }
PPSmalltalkParser >> variable [
	^ super variable ==> [ :token | RBVariableNode identifierToken: token ]
]
