Class {
	#name : #PPGrammarRefactoringTest,
	#superclass : #TestCase,
	#instVars : [
		'refactoring'
	],
	#category : #'PetitGui-Tests'
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

{ #category : #'testing-parsers' }
PPGrammarRefactoringTest >> testAddParser [
	self performRefactoring: (PPAddParserRefactoring
		name: #PPMockParser
		category: #'PetitGui-Mock').
	self assert: self changes size = 2.
	self assert: self changes first class = RBAddClassChange.
	self assert: self changes first definitionClass = PPCompositeParser.
	self assert: self changes first changeClassName = #PPMockParser.
	self assert: self changes first category = #'PetitGui-Mock'.
	self assert: self changes last class = RBAddMethodChange.
	self assert: self changes last parseTree = (RBParser parseMethod: 'start ^ self shouldBeImplemented')
]

{ #category : #'testing-parsers' }
PPGrammarRefactoringTest >> testAddParserWithSuperclass [
	self performRefactoring: (PPAddParserRefactoring
		name: #PPMockParser
		category: #'PetitGui-Mock'
		superclass: PPArithmeticParser).
	self assert: self changes size = 2.
	self assert: self changes first class = RBAddClassChange.
	self assert: self changes first definitionClass = PPArithmeticParser.
	self assert: self changes first changeClassName = #PPMockParser.
	self assert: self changes first category = #'PetitGui-Mock'.
	self assert: self changes last class = RBAddMethodChange.
	self assert: self changes last parseTree = (RBParser parseMethod: 'start ^ self shouldBeImplemented')
]

{ #category : #'testing-productions' }
PPGrammarRefactoringTest >> testDefineProduction [
	self performRefactoring: (PPDefineProdcutionRefactoring
		onClass: PPArithmeticParser
		source: 'function ^ #any plus , $( , $) ==> [ :e | 0 ]'
		protocols: (Array with: #productions)).
	self assert: self changes size = 2.
	self assert: self changes first class = RBAddInstanceVariableChange.
	self assert: self changes first variable = 'function'.
	self assert: self changes last class = RBAddMethodChange.
	self assert: self changes last parseTree = (RBParser parseMethod: 'function ^ #any asParser plus , $( asParser , $) asParser ==> [ :e | 0 ]')
]

{ #category : #'testing-productions' }
PPGrammarRefactoringTest >> testExtractProduction [
	self performRefactoring: (PPExtractProdcutionRefactoring
		onClass: PPArithmeticParser
		production: #addition
		interval: (36 to: 60)
		to: #plusOrMinus).
	self assert: self changes size = 3.
	self assert: self changes first class = RBAddInstanceVariableChange.
	self assert: self changes first variable = 'plusOrMinus'.
	self assert: self changes second class = RBAddMethodChange.
	self assert: self changes second parseTree = (RBParser parseMethod: 'plusOrMinus ^ $+ asParser / $- asParser').
	self assert: self changes last class = RBAddMethodChange.
	self assert: self changes last parseTree = (RBParser parseMethod: 'addition ^ (factors separatedBy: plusOrMinus trim) foldLeft: [ :a :op :b | a perform: op asSymbol with: b ]')
]

{ #category : #'testing-parsers' }
PPGrammarRefactoringTest >> testRemoveParser [
	self performRefactoring: (PPRemoveParserRefactoring onClass: PPArithmeticParser).
	self assert: self changes size = 1.
	self assert: self changes first class =  RBRemoveClassChange.
	self assert: self changes first changeClassName = 'PPArithmeticParser'
]

{ #category : #'testing-productions' }
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

{ #category : #'testing-productions' }
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
	self assert: self changes second parseTree = (RBParser parseMethod: 'add ^ (factors separatedBy: ($+ asParser / $- asParser) trim) foldLeft: [ :a :op :b | a perform: op asSymbol with: b ]').
	self assert: self changes last class = RBRemoveMethodChange.
	self assert: self changes last selector = #addition
]
