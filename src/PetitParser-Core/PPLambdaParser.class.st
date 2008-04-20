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
	expression , expression => [ :foo :bar | Array with: foo with: bar ]
]

{ #category : #productions }
PPLambdaParser >> expression [
	variable | abstraction | application
]

{ #category : #productions }
PPLambdaParser >> variable [
	#letter plus
]
