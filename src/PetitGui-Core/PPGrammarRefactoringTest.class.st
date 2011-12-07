Class {
	#name : #PPGrammarRefactoringTest,
	#superclass : #TestCase,
	#instVars : [
		'refactoring'
	],
	#category : #'PetitGui-Refactoring'
}

{ #category : #accessing }
PPGrammarRefactoringTest >> change [
	^ self refactoring changes
]

{ #category : #accessing }
PPGrammarRefactoringTest >> changes [
	^ self change changes
]

{ #category : #utilities }
PPGrammarRefactoringTest >> performRefactoring: aRefactoring [
	refactoring := aRefactoring.
	aRefactoring primitiveExecute
]

{ #category : #accessing }
PPGrammarRefactoringTest >> refactoring [
	^ refactoring
]

{ #category : #testing }
PPGrammarRefactoringTest >> testDefineProduction [
	self performRefactoring: (PPDefineProdcutionRefactoring
		onClass: PPArithmeticParser
		source: 'function ^ #any plus , $( , $) ==> [ :e | 0 ]'
		protocols: (Array with: #productions)).
	self assert: self changes size = 2.
	self assert: self changes first class = RBAddInstanceVariableChange.
	self assert: self changes first variable = 'function'.
	self assert: self changes last class = RBAddMethodChange.
	self assert: self changes last selector = #function
]

{ #category : #testing }
PPGrammarRefactoringTest >> testRemoveProduction [
	self performRefactoring: (PPRemoveProdcutionRefactoring
		onClass: PPArithmeticParser
		production: #addition).
	self assert: self changes size = 2.
	self assert: self changes first class = RBRemoveMethodChange.
	self assert: self changes first selector = #addition.
	self assert: self changes last class = RBRemoveInstanceVariableChange.
	self assert: self changes last variable = 'addition'
]

{ #category : #testing }
PPGrammarRefactoringTest >> testRenameProduction [
	self performRefactoring: (PPRenameProdcutionRefactoring
		onClass: PPArithmeticParser
		rename: #addition
		to: #add).
	self assert: self changes size = 3.
	self assert: self changes first class = RBRenameInstanceVariableChange.
	self assert: self changes first oldName = 'addition'.
	self assert: self changes first newName = 'add'.
	self assert: self changes second class = RBAddMethodChange.
	self assert: self changes second selector = #add.
	self assert: self changes last class = RBRemoveMethodChange.
	self assert: self changes last selector = #addition
]
