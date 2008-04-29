Class {
	#name : #PPLambdaParser,
	#superclass : #PPCompositeParser,
	#category : #'PetitParser-Builder'
}

{ #category : #productions }
PPLambdaParser >> abstraction [
	$\ , variable , $. , expression
]

{ #category : #productions }
PPLambdaParser >> application [
	$( token , expression , expression , $) token
]

{ #category : #productions }
PPLambdaParser >> expression [
	variable | abstraction | application
]

{ #category : #accessing }
PPLambdaParser >> startProduction [
	expression end
]

{ #category : #productions }
PPLambdaParser >> variable [
	#letter plus token
]
