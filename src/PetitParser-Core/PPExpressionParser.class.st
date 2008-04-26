Class {
	#name : #PPExpressionParser,
	#superclass : #PPCompositeParser,
	#category : #'PetitParser-Builder'
}

{ #category : #productions }
PPExpressionParser >> expr [
		(expr , $+ token , term ==> [ :node | node first + node third ]) 
	|	(expr , $- token , term ==> [ :node | node first - node third ])
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
		(term , $* token , fact ==> [ :node | node first * node third ]) 
	|	(term , $/ token , fact ==> [ :node | node first / node third ])
	|	(fact)
]
