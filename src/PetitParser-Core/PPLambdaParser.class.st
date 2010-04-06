Class {
	#name : #PPLambdaParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'expression',
		'abstraction',
		'application',
		'variable'
	],
	#category : #'PetitParser-Tests'
}

{ #category : #'curch-booleans' }
PPLambdaParser class >> and [
	^ self parse: '\p.\q.((p q) p)'
]

{ #category : #'curch-booleans' }
PPLambdaParser class >> false [
	^ self parse: '\x.\y.y'
]

{ #category : #'curch-booleans' }
PPLambdaParser class >> ifthenelse [
	^ self parse: '\p.p'
]

{ #category : #'curch-booleans' }
PPLambdaParser class >> not [
	^ self parse: '\p.\a.\b.((p b) a)'
]

{ #category : #'curch-booleans' }
PPLambdaParser class >> or [
	^ self parse: '\p.\q.((p p) q)'
]

{ #category : #'curch-booleans' }
PPLambdaParser class >> true [
	^ self parse: '\x.\y.x'
]

{ #category : #productions }
PPLambdaParser >> abstraction [
	^ $\ asParser token trim , variable , $. asParser token trim , expression ==> [ :node | Array with: node second with: node fourth ]
]

{ #category : #productions }
PPLambdaParser >> application [
	^ $( asParser token trim , expression , expression , $) asParser token trim ==> [ :node | Array with: node second with: node third ]
]

{ #category : #productions }
PPLambdaParser >> expression [
	^ variable / abstraction / application
]

{ #category : #accessing }
PPLambdaParser >> start [
	^ expression end
]

{ #category : #productions }
PPLambdaParser >> variable [
	^ (#letter asParser , #word asParser star) token trim ==> [ :token | token value ]
]
