Class {
	#name : #PPLambdaCompiler,
	#superclass : #PPLambdaParser,
	#category : #'PetitParser-Builder'
}

{ #category : #'curch-booleans' }
PPLambdaCompiler class >> and [
	^ self parse: '\p.\q.((p q) p)'
]

{ #category : #'curch-booleans' }
PPLambdaCompiler class >> false [
	^ self parse: '\x.\y.y'
]

{ #category : #'curch-booleans' }
PPLambdaCompiler class >> ifthenelse [
	^ self parse: '\p.p'
]

{ #category : #'curch-booleans' }
PPLambdaCompiler class >> not [
	^ self parse: '\p.\a.\b.((p b) a)'
]

{ #category : #'curch-booleans' }
PPLambdaCompiler class >> or [
	^ self parse: '\p.\q.((p p) q)'
]

{ #category : #'curch-booleans' }
PPLambdaCompiler class >> true [
	^ self parse: '\x.\y.x'
]

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
