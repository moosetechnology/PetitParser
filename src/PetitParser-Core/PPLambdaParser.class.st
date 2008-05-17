Class {
	#name : #PPLambdaParser,
	#superclass : #PPCompositeParser,
	#category : #'PetitParser-Builder'
}

{ #category : #productions }
PPLambdaParser >> abstraction [
	$\ token , variable , $. token , expression ==> [ :node | Array with: node second with: node fourth ]
]

{ #category : #productions }
PPLambdaParser >> application [
	$( token , expression , expression , $) token ==> [ :node | Array with: node second with: node third ]
]

{ #category : #productions }
PPLambdaParser >> expression [
	variable | abstraction | application
]

{ #category : #accessing }
PPLambdaParser >> start [
	expression end
]

{ #category : #productions }
PPLambdaParser >> variable [
	(#letter , #word star) token
]
