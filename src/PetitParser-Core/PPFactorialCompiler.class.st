Class {
	#name : #PPFactorialCompiler,
	#superclass : #PPFactorialParser,
	#category : #'PetitParser-Builder'
}

{ #category : #grammar }
PPFactorialCompiler >> apply [
	^ super apply ==> [ :node |
		RBMessageNode
			receiver: (RBVariableNode named: 'self')
			selector: (self
				selector: node second
				count: node third size) 
			arguments: node third ]
]

{ #category : #grammar }
PPFactorialCompiler >> binary [
	^ super binary ==> [ :node | 
		RBMessageNode
			receiver: node second
			selector: node third asSymbol
			arguments: (Array with: node fourth) ]
]

{ #category : #grammar }
PPFactorialCompiler >> condition [
	^ super condition ==> [ :node | 
		RBMessageNode 
			receiver: node second
			selector: #ifTrue:ifFalse:
			arguments: (Array 
				with: (RBBlockNode 
					arguments: #()
					body: (RBSequenceNode 
						statements: (Array with: node fourth)))
				with: (RBBlockNode 
					arguments: #()
					body: (RBSequenceNode 
						statements: (Array with: node sixth)))) ]
]

{ #category : #grammar }
PPFactorialCompiler >> function [
	^ super function ==> [ :node |
		RBMethodNode
			selector: (self
				selector: node first
				count: node second size)
			arguments: node second
			body: ((RBSequenceNode statements: (Array
				with: node fourth))
				addReturn;
				yourself) ]
]

{ #category : #grammar }
PPFactorialCompiler >> literal [
	^ super literal ==> [ :node | RBLiteralNode value: node asNumber ]
]

{ #category : #grammar }
PPFactorialCompiler >> operation [
	^ super operation ==> [ :node |
		node asString = '=='
			ifTrue: [ #= ]
			ifFalse: [ node asSymbol ] ]
]

{ #category : #private }
PPFactorialCompiler >> selector: aString count: anInteger [
	| stream |
	stream := WriteStream on: String new.
	stream nextPutAll: aString.
	1 to: anInteger do: [ :index |
		index > 1
			ifTrue: [ stream nextPutAll: 'with' ].
		stream nextPut: $: ].
	^ stream contents asSymbol
]

{ #category : #grammar }
PPFactorialCompiler >> variable [
	^ super variable ==> [ :node | RBVariableNode named: node ]
]
