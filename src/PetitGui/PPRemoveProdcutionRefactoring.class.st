Class {
	#name : #PPRemoveProdcutionRefactoring,
	#superclass : #RBRefactoring,
	#instVars : [
		'production',
		'class'
	],
	#category : #'PetitGui-Refactoring'
}

{ #category : #'instance creation' }
PPRemoveProdcutionRefactoring class >> onClass: aClass production: aSelector [
	^ self new
		setClass: aClass;
		setProduction: aSelector;
		yourself
]

{ #category : #preconditions }
PPRemoveProdcutionRefactoring >> preconditions [
	^ (self checkCompositeParser: class)
		& (RBCondition definesSelector: production asSymbol in: class)
		& (RBCondition definesInstanceVariable: production asString in: class)
]

{ #category : #initialization }
PPRemoveProdcutionRefactoring >> setClass: aClass [
	class := self classObjectFor: aClass
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
