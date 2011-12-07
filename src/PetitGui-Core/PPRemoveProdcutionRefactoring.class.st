Class {
	#name : #PPRemoveProdcutionRefactoring,
	#superclass : #PPGrammarRefactoring,
	#instVars : [
		'production'
	],
	#category : #'PetitGui-Refactoring'
}

{ #category : #preconditions }
PPRemoveProdcutionRefactoring >> preconditions [
	^ super preconditions
		& (RBCondition definesSelector: production asSymbol in: class)
		& (RBCondition definesInstanceVariable: production asString in: class)
]

{ #category : #initialization }
PPRemoveProdcutionRefactoring >> setProduction: aSymbol [
	production := aSymbol
]

{ #category : #transforming }
PPRemoveProdcutionRefactoring >> transform [
	class removeMethod: production asSymbol.
	class removeInstanceVariable: production asString
]
