Class {
	#name : #PPLambdaCompiler,
	#superclass : #PPLambdaParser,
	#category : #'PetitParser-Builder'
}

{ #category : #productions }
PPLambdaCompiler >> abstraction [
	super abstraction ==> [ :node | ``[ :t | `,(node second) ] arguments: (Array with: node first) ]
]

{ #category : #productions }
PPLambdaCompiler >> application [
	super application ==> [ :node | ``(`,(node first) value: `,(node second)) ]
]

{ #category : #productions }
PPLambdaCompiler >> variable [
	super variable ==> [ :node | RBVariableNode named: node ]
]
