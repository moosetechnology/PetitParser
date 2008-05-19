Class {
	#name : #PPLambdaParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'expression',
		'abstraction',
		'application',
		'variable'
	],
	#category : #'PetitParser-Builder'
}

{ #category : #productions }
PPLambdaParser >> abstraction [
	^ $\ asParser flatten , variable , $. asParser flatten , expression ==> [ :node | Array with: node second with: node fourth ]
]

{ #category : #productions }
PPLambdaParser >> application [
	^ $( asParser flatten , expression , expression , $) asParser flatten ==> [ :node | Array with: node second with: node third ]
]

{ #category : #productions }
PPLambdaParser >> expression [
	^ variable | abstraction | application
]

{ #category : #accessing }
PPLambdaParser >> start [
	^ expression end
]

{ #category : #productions }
PPLambdaParser >> variable [
	^ (#letter asParser , #word asParser star) flatten
]
