Class {
	#name : #PPExpressionParser,
	#superclass : #PPCompositeParser,
	#category : #'PetitParser-Builder'
}

{ #category : #productions }
PPExpressionParser >> expr [
		(term , $+ token , expr ==> [ :node | node first + node third ]) 
	|	(term , $- token , expr ==> [ :node | node first - node third ])
	|	(term)
]

{ #category : #productions }
PPExpressionParser >> fact [
		($( token , expr , $) token ==> [ :node | node second ]) 
	| 	(num)
]

{ #category : #productions }
PPExpressionParser >> num [
	($- optional , #digit plus , ($. , #digit plus) optional) token
		==> [ :node | Number readFrom: node copy ]
]

{ #category : #accessing }
PPExpressionParser >> startProduction [
	expr end
]

{ #category : #productions }
PPExpressionParser >> term [
		(fact , $* token , term ==> [ :node | node first * node third ]) 
	|	(fact , $/ token , term ==> [ :node | node first / node third ])
	|	(fact)
]
