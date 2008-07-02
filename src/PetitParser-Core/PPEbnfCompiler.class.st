Class {
	#name : #PPEbnfCompiler,
	#superclass : #PPEbnfParser,
	#category : #'PetitParser-Builder'
}

{ #category : #grammar }
PPEbnfCompiler >> expression [
	^ super expression ==> [ :nodes |
		nodes allButFirst
			inject: nodes first
			into: [ :result :each |
				(each isKindOf: RBProgramNode)
					ifTrue: [
						RBMessageNode
							receiver: result selector: #|
							arguments: (Array with: each) ]
					ifFalse: [ result ] ] ]
]

{ #category : #grammar }
PPEbnfCompiler >> grouping [
	^ super grouping ==> #second
]

{ #category : #grammar }
PPEbnfCompiler >> list [
	^ super list ==> [ :nodes | 
		nodes allButFirst
			inject: nodes first
			into: [ :result :each |
				RBMessageNode
					receiver: result selector: #,
					arguments: (Array with: each) ] ]
]

{ #category : #grammar }
PPEbnfCompiler >> nonterminal [
	^ super nonterminal ==> [ :token |
		RBMessageNode new
			receiver: (RBVariableNode named: 'self')
			selectorParts: (Array with: token)
			arguments: #() ]
]

{ #category : #grammar }
PPEbnfCompiler >> option [
	^ super option ==> [ :nodes | 
		RBMessageNode
			receiver: nodes second
			selector: #optional ]
]

{ #category : #grammar }
PPEbnfCompiler >> repetition [
	^ super repetition ==> [ :nodes | 
		RBMessageNode
			receiver: nodes second
			selector: #star ]
]

{ #category : #grammar }
PPEbnfCompiler >> rule [
	^ super rule ==> [ :nodes | 
		RBMethodNode new
			selectorParts: (Array with: nodes first)
			arguments: Array new;
			body: (RBSequenceNode new
				statements: (Array with: nodes third);
				addReturn;
				yourself);
			source: nodes second collection;
			yourself ]
]

{ #category : #accessing }
PPEbnfCompiler >> start [
	^ rule , [ :stream | self class parserClass parseDoIt: stream upToEnd ] asParser
]

{ #category : #grammar }
PPEbnfCompiler >> terminal [
	| cropped |
	^ super terminal ==> [ :token |
		cropped := token copyFrom: 2 to: token size - 1.
		RBMessageNode
			receiver: (cropped size = 1
				ifTrue: [ RBLiteralNode literalToken: cropped value: cropped value first ]
				ifFalse: [ RBLiteralNode literalToken: cropped ])
			selector: #asParser ]
]
