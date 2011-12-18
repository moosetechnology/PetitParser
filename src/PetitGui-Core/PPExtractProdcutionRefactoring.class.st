Class {
	#name : #PPExtractProdcutionRefactoring,
	#superclass : #RBExtractMethodRefactoring,
	#instVars : [
		'targetProduction'
	],
	#category : #'PetitGui-Refactoring'
}

{ #category : #'instance creation' }
PPExtractProdcutionRefactoring class >> onClass: aClass production: aSelector interval: anInterval to: aTargetSelector [
	^ (self extract: anInterval from: aSelector in: aClass)
		setTargetProduction: aTargetSelector;
		yourself
]

{ #category : #transforming }
PPExtractProdcutionRefactoring >> existingSelector [
	^ nil
]

{ #category : #transforming }
PPExtractProdcutionRefactoring >> getNewMethodName [
	parameters isEmpty
		ifFalse: [ self refactoringError: 'Cannot extract production since it contains references.' ].
	targetProduction asSymbol isUnary
		ifFalse: [ self refactoringError: 'Invalid production name.' ].
	^ targetProduction asSymbol
]

{ #category : #transforming }
PPExtractProdcutionRefactoring >> nameNewMethod: aSymbol [ 
	class addInstanceVariable: aSymbol asString.
	extractedParseTree renameSelector: aSymbol andArguments: #().
	modifiedParseTree := RBParseTreeRewriter 
		replace: self methodDelimiter
		with: aSymbol asString
		in: modifiedParseTree
]

{ #category : #preconditions }
PPExtractProdcutionRefactoring >> preconditionIsSubclassOfCompositeParser [
	^ RBCondition new
			type: (Array with: #subclass with: self rootClass with: class)
			block: [class includesClass: self rootClass]
			errorString: class printString , ' is <1?:not >a subclass of ' , self rootClass printString
]

{ #category : #preconditions }
PPExtractProdcutionRefactoring >> preconditions [
	^ (RBCondition isMetaclass: class) not
		& self preconditionIsSubclassOfCompositeParser
		& super preconditions		
		& (RBCondition definesSelector: targetProduction asSymbol in: class) not
		& (RBCondition definesInstanceVariable: targetProduction asString in: class) not
]

{ #category : #utilities }
PPExtractProdcutionRefactoring >> rootClass [
	^ self classObjectFor: #PPCompositeParser
]

{ #category : #initialization }
PPExtractProdcutionRefactoring >> setTargetProduction: aSymbol [
	targetProduction := aSymbol
]

{ #category : #requests }
PPExtractProdcutionRefactoring >> shouldExtractAssignmentTo: aString [
	^ false
]
