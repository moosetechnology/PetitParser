Class {
	#name : #MiniPythonGrammar,
	#superclass : #PPCompositeParser,
	#instVars : [
		'suite',
		'statement',
		'expression',
		'ifStmt',
		'identifier',
		'printStmt',
		'whileStmt',
		'targetList',
		'expressionList',
		'target',
		'forStmt',
		'withStmt',
		'tryStmt',
		'try1Stmt',
		'try2Stmt',
		'compoundStmt',
		'assignmentStmt',
		'exprOperator',
		'number'
	],
	#category : #'PetitIndent-Examples'
}

{ #category : #'as yet unclassified' }
MiniPythonGrammar >> assignmentStmt [
	^ identifier, $= asParser trimBlanks, expression
]

{ #category : #'as yet unclassified' }
MiniPythonGrammar >> compoundStmt [
	^ ifStmt
         / whileStmt
         / forStmt
         / tryStmt
         / withStmt
         / assignmentStmt
]

{ #category : #'as yet unclassified' }
MiniPythonGrammar >> exprOperator [
	^ $+ asParser /
	   $< asParser /
	   '==' asParser
]

{ #category : #'as yet unclassified' }
MiniPythonGrammar >> expression [
	^ 
	(identifier, (exprOperator trimBlanks, expression) star)
	/
	($( asParser, expression trim, $) asParser)
	
	
	==> [ :tokens | #expr ] 
]

{ #category : #'as yet unclassified' }
MiniPythonGrammar >> expressionList [          
	^  (expression trim , ( ',' asParser trim , expression trim ) star , (',' asParser trim optional)) ==> [ :tokens | #exprList ]
]

{ #category : #'as yet unclassified' }
MiniPythonGrammar >> forStmt [
	^ 'for' asParser trimBlanks, targetList , 'in' asParser trim, expressionList , ':' asParser, 
		suite trimWithoutIndents,
		(( 'else' asParser,  ':' asParser trimBlanks, suite trimWithoutIndents) ==> #third ) optional 
	==> [ :tokens | Array with:tokens second with:tokens sixth with:tokens seventh ]
]

{ #category : #'as yet unclassified' }
MiniPythonGrammar >> identifier [
	| letter digit |
	letter := #letter asParser.
	digit := #digit asParser.
	^ letter, ( letter / digit / '_' asParser )  star 
]

{ #category : #'as yet unclassified' }
MiniPythonGrammar >> ifStmt [
	^ 'if' asParser, expression trimBlanks , ':' asParser, suite trimWithoutIndents,
       ( ('else' asParser,  ':' asParser trimBlanks, suite trimWithoutIndents) ==> #third ) optional 
==> [ :tokens | Array with:tokens second with: tokens fourth with:tokens fifth]
]

{ #category : #'as yet unclassified' }
MiniPythonGrammar >> number [
	^ #digit asParser plus
]

{ #category : #'as yet unclassified' }
MiniPythonGrammar >> printStmt [
	^ 'print' asParser, (identifier / number) trimBlanks ==> [ :tokens | #print ]
]

{ #category : #'as yet unclassified' }
MiniPythonGrammar >> start [
	^ statement trimWithoutIndents star
]

{ #category : #'as yet unclassified' }
MiniPythonGrammar >> statement [
	^ printStmt   /  compoundStmt 
]

{ #category : #'as yet unclassified' }
MiniPythonGrammar >> suite [
	^  #indent asParser, statement trimWithoutIndents plus, #dedent asParser
	==> [ :tokens | (OrderedCollection with: tokens second)]
]

{ #category : #'as yet unclassified' }
MiniPythonGrammar >> target [
	^ ( identifier) trim
                / ('(' asParser trim , targetList trim, ')' asParser )trim
                / ('[' asParser trim , targetList trim, ']' asParser )trim
	==> [ :tokens | #target ]
                
]

{ #category : #'as yet unclassified' }
MiniPythonGrammar >> targetList [
	^  (target trim , (',' asParser  trim, target trim) star ,( ',' asParser trim optional))
	==> [ :tokens | #targetList ]
         
]

{ #category : #'as yet unclassified' }
MiniPythonGrammar >> try1Stmt [
	^ 'try' asParser, ':' asParser trimBlanks, suite trimWithoutIndents,
		(('except' asParser, ( expression trim , ( ',' asParser trim , target ) optional ) optional ,':' asParser trimBlanks, suite trimWithoutIndents) ==> #fourth )plus ,
		(('else' asParser, ':' asParser trimBlanks, suite trimWithoutIndents) ==> #third) optional ,
		(('finally' asParser, ':' asParser trimBlanks, suite trimWithoutIndents) ==> #third) optional 
==> [ :tokens | Array with:tokens third with: tokens fourth with: tokens fifth with:tokens sixth]             
]

{ #category : #'as yet unclassified' }
MiniPythonGrammar >> try2Stmt [
	^ 'try' asParser, ':' asParser trimBlanks, suite ,
		('finally' asParser, ':' asParser trimBlanks, suite  ==> #third)
==> [ :tokens | Array with:tokens third with:tokens fourth]                
]

{ #category : #'as yet unclassified' }
MiniPythonGrammar >> tryStmt [
	^ try1Stmt / try2Stmt
]

{ #category : #'as yet unclassified' }
MiniPythonGrammar >> whileStmt [
	^ 'while' asParser , expression trimBlanks , ':' asParser trimBlanks, suite trimWithoutIndents 
       ,( ('else' asParser,  ':' asParser trimBlanks, suite trimWithoutIndents) ==> #third ) optional
	==> [ :tokens | Array with:tokens second with: tokens fourth with: tokens fifth ] 
]

{ #category : #'as yet unclassified' }
MiniPythonGrammar >> withStmt [
	^ 'with' asParser, expression trim, ( 'as' asParser trim, target ) trim optional ,':' asParser trimBlanks, 
		suite trimWithoutIndents
	==> [ :tokens | Array with:tokens second with: tokens fifth ]
              
]
