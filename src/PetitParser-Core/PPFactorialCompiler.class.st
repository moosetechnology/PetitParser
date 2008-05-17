Class {
	#name : #PPFactorialCompiler,
	#superclass : #PPFactorialParser,
	#category : #'PetitParser-Builder'
}

{ #category : #grammar }
PPFactorialCompiler >> apply [
	super apply ==> [ :node |
		RBMessageNode
			receiver: ``(self) 
			selector: (self
				selector: node second
				count: node third size) 
			arguments: node third ]
]

{ #category : #grammar }
PPFactorialCompiler >> binary [
	super binary ==> [ :node |
		``(`,(node second) ? `,(node fourth))
			selector: node third asSymbol;
			yourself ]
]

{ #category : #grammar }
PPFactorialCompiler >> condition [
	super condition ==> [ :node |
		``(`,(node second)
			ifTrue: [ `,(node fourth) ]
			ifFalse: [ `,(node sixth) ]) ]
]

{ #category : #grammar }
PPFactorialCompiler >> function [
	super function ==> [ :node |
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
	super literal ==> #lift
]

{ #category : #grammar }
PPFactorialCompiler >> operation [
	super operation ==> [ :node |
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
	super variable ==> [ :node | RBVariableNode named: node ]
]
