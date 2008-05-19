Class {
	#name : #PPLambdaParser,
	#superclass : #PPCompositeParser,
	#category : #'PetitParser-Builder'
}

{ #category : #productions }
PPLambdaParser >> abstraction [
	$\ flatten , variable , $. flatten , expression ==> [ :node | Array with: node second with: node fourth ]
]

{ #category : #productions }
PPLambdaParser >> application [
	$( flatten , expression , expression , $) flatten ==> [ :node | Array with: node second with: node third ]
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
	(#letter , #word star) flatten
]
