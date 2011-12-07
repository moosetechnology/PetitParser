Class {
	#name : #PPGrammarRefactoring,
	#superclass : #AnObsoleteRefactoring,
	#instVars : [
		'class'
	],
	#category : #'PetitGui-Refactoring'
}

{ #category : #preconditions }
PPGrammarRefactoring >> preconditions [
	^ (RBCondition isMetaclass: class) not & (RBCondition isSubclass: class of: self rootClass)
]

{ #category : #utilities }
PPGrammarRefactoring >> rootClass [
	^ self classObjectFor: #PPCompositeParser
]

{ #category : #initialization }
PPGrammarRefactoring >> setClass: aClass [
	class := self classObjectFor: aClass
]
