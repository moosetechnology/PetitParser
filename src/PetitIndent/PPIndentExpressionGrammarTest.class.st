Class {
	#name : #PPIndentExpressionGrammarTest,
	#superclass : #PPCompositeParserTest,
	#category : #'PetitIndent-Examples'
}

{ #category : #accessing }
PPIndentExpressionGrammarTest >> parserClass [
	^ PPIndentExpressionGrammar
]

{ #category : #testing }
PPIndentExpressionGrammarTest >> testAdd [
	result := self parse: '1+2' rule: #add.
	self assert: result isArray.
	self assert: result first = 1.
	self assert: result second inputValue = '+'.
	self assert: result third = 2.
]

{ #category : #testing }
PPIndentExpressionGrammarTest >> testMul [
	result := self parse: '1 * 2' rule: #mul.
	self assert: result isArray.
	self assert: result first = 1.
	self assert: result second inputValue = '*'.
	self assert: result third = 2.
]

{ #category : #testing }
PPIndentExpressionGrammarTest >> testNumber [
	result := self parse: '1' rule: #number.
	self assert: result = 1.
]

{ #category : #testing }
PPIndentExpressionGrammarTest >> testParens [
	result := self parse: ' 1
' rule: #parens.
	self assert: result size = 3.
	self assert: result first = #indent.
	self assert: result second = 1.
	self assert: result third = #dedent.
	
]

{ #category : #testing }
PPIndentExpressionGrammarTest >> testPrim [
	result := self parse: '1' rule: #prim.
	self assert: result = 1.
]

{ #category : #testing }
PPIndentExpressionGrammarTest >> testPrim2 [
	result := self parse: '
	1
' rule: #prim.
	self assert: result size = 3.
	self assert: result second = 1.
]

{ #category : #testing }
PPIndentExpressionGrammarTest >> testProd [
	result := self parse: '1' rule: #prod.
	self assert: result = 1.
]

{ #category : #testing }
PPIndentExpressionGrammarTest >> testTerm [
	result := self parse: '1' rule: #term.
	self assert: result = 1.
	
]

{ #category : #testing }
PPIndentExpressionGrammarTest >> testTerm11 [
	result := self parse: '1 + 2' rule: #term.
	self assert: result size = 3.
	self assert: result first = 1.
	self assert: result second inputValue = '+'.
	self assert: result third = 2.
	
]

{ #category : #testing }
PPIndentExpressionGrammarTest >> testTerm12 [
	result := self parse: '1 + 2 * 3' rule: #term.
	self assert: result size = 3.
	self assert: result second inputValue = '+'.
	self assert: result first = 1.
	self assert: result third isArray.
	self assert: result third first = 2.
	self assert: result third second inputValue = '*'.
	self assert: result third third = 3.
]

{ #category : #testing }
PPIndentExpressionGrammarTest >> testTerm13 [
	result := self parse: '1 * 2 + 3' rule: #term.
	self assert: result size = 3.
	self assert: result first isArray.
	self assert: result first first = 1.
	self assert: result first second inputValue = '*'.
	self assert: result first third = 2.	
	self assert: result second inputValue = '+'.
	self assert: result third = 3.
]

{ #category : #testing }
PPIndentExpressionGrammarTest >> testTermIS [
	result := self parse: '1 * 
	2 + 3
' rule: #term.

	self assert: result size = 3.
	self assert: result first = 1.
	self assert: result second inputValue = '*'.
	self assert: result third first = #indent.
	self assert: result third second first = 2.
	self assert: result third second second inputValue = '+'.
	self assert: result third second third = 3.		
	self assert: result third third = #dedent.
		
]
