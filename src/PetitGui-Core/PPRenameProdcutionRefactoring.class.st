Class {
	#name : #PPRenameProdcutionRefactoring,
	#superclass : #PPGrammarRefactoring,
	#instVars : [
		'oldProduction',
		'newProduction'
	],
	#category : #'PetitGui-Refactoring'
}

{ #category : #initialization }
PPRenameProdcutionRefactoring >> setNewProduction: aSymbol [
	newProduction := aSymbol
]

{ #category : #initialization }
PPRenameProdcutionRefactoring >> setOldProduction: aSymbol [
	oldProduction := aSymbol
]

{ #category : #transforming }
PPRenameProdcutionRefactoring >> transform [
	| baseClass baseEnvironment |
	baseClass := class whoDefinesInstanceVariable: oldProduction asString.
	self performComponentRefactoring: (RBRenameInstanceVariableRefactoring
		model: model
		rename: oldProduction asString
		to: newProduction asString
		in: baseClass).
	baseEnvironment := model environment.
	model environment: (model environment
		forClasses: baseClass realClass withAllSubclasses).
	[ self performComponentRefactoring: (RBRenameMethodRefactoring
		model: model
		renameMethod: oldProduction asSymbol
		in: baseClass
		to: newProduction asSymbol 
		permutation: #()) ]
			ensure: [ model environment: baseEnvironment ]
]
