Class {
	#name : #PPGrammarRefactoring,
	#superclass : #RBRefactoring,
	#instVars : [
		'class'
	],
	#category : #'PetitGui-Refactoring'
}

{ #category : #'instance creation' }
PPGrammarRefactoring class >> onClass: aClass [
	^ self new
		setClass: aClass;
		yourself
]

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
