Class {
	#name : #MiniPythonGrammarTest,
	#superclass : #PPCompositeParserTest,
	#instVars : [
		'aPPContext',
		'debugResult'
	],
	#category : #'PetitIndent-Examples'
}

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> parserClass [
	^ MiniPythonGrammar
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testAssignmentStmt [

self parse: 'abc = def' rule: #assignmentStmt.
self parse: 'abc = a + b + c' rule: #assignmentStmt.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testExpression [

self parse: 'x < y' rule: #expression.
self parse: 'x == y' rule: #expression.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testExpression2 [

self parse: 'a + b + c' rule: #expression.
self parse: 'a + (b) + c' rule: #expression.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testExpressionList [

self parse: 'x < y , x == y' rule: #expressionList.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testForStmt [

self parse: 
'for w in words:
	print test
	print abc
	print def
' rule: #forStmt.

self assert: result size = 3.

self assert: result first = #targetList. 

self assert: result second asString = 'an OrderedCollection(#(#print #print #print))'.
self assert: result second first size = 3.
self assert: result second first first = #print.
self assert: result second first second = #print.
self assert: result second first third = #print.

self assert: result third = nil.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testForStmt2 [

self parse: 
'for ( w , x , y ) in words:
	print a
	print b
	print c
' rule: #forStmt.

self assert: result size = 3.

self assert: result first = #targetList. 

self assert: result second asString = 'an OrderedCollection(#(#print #print #print))'.
self assert: result second first size = 3.
self assert: result second first first = #print.
self assert: result second first second = #print.
self assert: result second first third = #print.


self assert: result third = nil.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testForStmt3 [

self parse: 
'for ( w , x , y ) in words:
	print a
	print b
	print c
else :
	print d
	print e
' rule: #forStmt.

self assert: result size = 3.

self assert: result first = #targetList. 

self assert: result second asString = 'an OrderedCollection(#(#print #print #print))'.
self assert: result second first size = 3.
self assert: result second first first = #print.
self assert: result second first second = #print.
self assert: result second first third = #print.


self assert: result third asString =  'an OrderedCollection(#(#print #print))'.
self assert: result third first size = 2.
self assert: result third first first= #print.
self assert: result third first second = #print.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testForStmt4 [

self parse: 
'for ( w , x , y ) in words:
	if  x== y :
		print a
		print b
	else :
		print c
else :
	print d
' rule: #forStmt.

self assert: result size = 3.

self assert: result first = #targetList. 

self assert: result second asString = 'an OrderedCollection(an Array(an Array(#expr an OrderedCollection(#(#print #print)) an OrderedCollection(#(#print)))))'.
self assert: result second first first size = 3.

self assert: result second first first first = #expr.

self assert: result second first first second asString = 'an OrderedCollection(#(#print #print))'.
self assert: result second first first second first size = 2.
self assert: result second first first second first first = #print.
self assert: result second first first second first second = #print.

self assert: result second first first third first size = 1.
self assert: result second first first third first first= #print.


self assert: result third asString =  'an OrderedCollection(#(#print))'.
self assert: result third first size = 1.
self assert: result third first first= #print.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testForStmt5 [

self parse: 
'for ( w , x , y ) in words:
	if  x== y :
		print a
		print b
else :
	print d
' rule: #forStmt.

self assert: result size = 3.

self assert: result first = #targetList. 

self assert: result second asString = 'an OrderedCollection(an Array(an Array(#expr an OrderedCollection(#(#print #print)) nil)))'.
self assert: result second first first size = 3.

self assert: result second first first first = #expr.

self assert: result second first first second asString = 'an OrderedCollection(#(#print #print))'.
self assert: result second first first second first size = 2.
self assert: result second first first second first first = #print.
self assert: result second first first second first second = #print.

self assert: result second first first third = nil.


self assert: result third asString =  'an OrderedCollection(#(#print))'.
self assert: result third first size = 1.
self assert: result third first first= #print.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testForStmt6 [

self fail: 
'for ( w , x , y ) in words:
	print a
	print b
	print c
 else :
	print d
	print e
' rule: #forStmt.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testIfStmt [

self parse: 
'if x < y :
	print x
	print y
	print z
' rule: #ifStmt.

self assert: result size = 3.

self assert: result first = #expr.

self assert: result second asString ='an OrderedCollection(#(#print #print #print))'.
self assert: result second first first = #print.
self assert: result second first second = #print.
self assert: result second first third = #print.
self assert: result second first size = 3.

self assert: result third = nil.





]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testIfStmt10 [

self fail: 
'if x:
   print x
   if x :
      print 2
   else :
      print 3
 else :
   print 1
' rule: #ifStmt.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testIfStmt2 [

self parse: 
'if x < y :
	print x
	print 2
else :
	print 1
' rule: #ifStmt.

self assert: result size = 3.

self assert: result first = #expr.

self assert: result second asString = 'an OrderedCollection(#(#print #print))'.
self assert: result second first first = #print.
self assert: result second first second = #print.
self assert: result second first size = 2.

self assert: result third asString = 'an OrderedCollection(#(#print))'.
self assert: result third first first= #print.
self assert: result third first size = 1.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testIfStmt3 [

self parse: 
'if x < y :
	if x== y :
		print 1
	else :
		print 2
else :
	print z
' rule: #ifStmt.

self assert: result size = 3.

self assert: result first = #expr. 

self assert: result second asString = 'an OrderedCollection(an Array(an Array(#expr an OrderedCollection(#(#print)) an OrderedCollection(#(#print)))))'.
self assert: result second first first size = 3 .
self assert: result second first first first= #expr.
self assert: result second first first second first first = #print.
self assert: result second first first third first first = #print.

self assert: result third asString  = 'an OrderedCollection(#(#print))'.
self assert: result third first first = #print.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testIfStmt4 [

self parse: 
'if x < y :
	print 1
	print 2
else :
	print 3
	print 4
' rule: #ifStmt.

self assert: result size = 3.

self assert: result first = #expr. 

self assert: result second asString = 'an OrderedCollection(#(#print #print))'.
self assert: result second first first = #print.
self assert: result second first second = #print.
self assert: result second first size = 2.

self assert: result third asString = 'an OrderedCollection(#(#print #print))'.
self assert: result third  first first= #print.
self assert: result third  first second= #print.
self assert: result third first size= 2.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testIfStmt5 [

self parse: 
'if x < y :
	if x== y :
		print 1
	else :
		print 2
' rule: #ifStmt.

self assert: result size = 3.

self assert: result first = #expr. 

self assert: result second asString = 'an OrderedCollection(an Array(an Array(#expr an OrderedCollection(#(#print)) an OrderedCollection(#(#print)))))'.
self assert: result second first first size = 3.
self assert: result second first first first = #expr.
self assert: result second first first second first first= #print.
self assert: result second first first third first first = #print.

self assert: result third = nil.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testIfStmt6 [

self parse: 
'if x < y :
	if x== y :
		print 1
else :
	print 2
' rule: #ifStmt.

self assert: result size = 3.

self assert: result first = #expr. 

self assert: result second asString = 'an OrderedCollection(an Array(an Array(#expr an OrderedCollection(#(#print)) nil)))'.
self assert: result second first first size = 3.
self assert: result second first first first = #expr.
self assert: result second first first second first first= #print.
self assert: result second first first third  = nil.

self assert: result third asString= 'an OrderedCollection(#(#print))'.
self assert: result third first first = #print.

]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testIfStmt7 [

self fail: 
'if x < y :
	print x
	print 2
 else :
	print 1
' rule: #ifStmt.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testIfStmt8 [

self fail: 
'if x < y :
   print x
   if x :
      print 2
    else :
      print 3
else :
   print 1
' rule: #ifStmt.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testIfStmt9 [

self fail: 
'if x:
   print x
   if x :
      print 2
  else :
      print 3
else :
   print 1
' rule: #ifStmt.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testPrintStmt [

self parse: 'print 1' rule: #printStmt.
self parse: 'print 12' rule: #printStmt.
self parse: 'print abc' rule: #printStmt.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testStatement [

self parse: 'print y' rule: #statement.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testSuite [

self parse: 
'
	print test
' rule: #suite.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testTry1Stmt [

self parse: 
'try :
	print x
except :
	print y
' rule: #try1Stmt.

self assert: result size = 4.

self assert: result first asString = 'an OrderedCollection(#(#print))'.
self assert: result first first size = 1.
self assert: result first first first = #print.

self assert: result second asString = 'an Array(an OrderedCollection(#(#print)))' .
self assert: result second first first size = 1.
self assert: result second first first first  = #print .

self assert: result third = nil.

self assert: result fourth = nil.





]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testTry1Stmt2 [

self parse: 
'try :
	print x
except :
	print y
else :
	print z
' rule: #try1Stmt.

self assert: result size = 4.

self assert: result first asString = 'an OrderedCollection(#(#print))'.
self assert: result first first size = 1.
self assert: result first first first = #print.

self assert: result second asString = 'an Array(an OrderedCollection(#(#print)))' .
self assert: result second first first size = 1.
self assert: result second first first first  = #print .

self assert: result third asString = 'an OrderedCollection(#(#print))'.
self assert: result third first size = 1.
self assert: result third first first = #print.

self assert: result fourth = nil.

]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testTry1Stmt3 [

self parse: 
'try :
	print x
except :
	print y
else :
	print z
finally :
	print t
' rule: #try1Stmt.

self assert: result size = 4.

self assert: result first asString = 'an OrderedCollection(#(#print))'.
self assert: result first first size = 1.
self assert: result first first first = #print.

self assert: result second asString = 'an Array(an OrderedCollection(#(#print)))' .
self assert: result second first first size = 1.
self assert: result second first first first  = #print .

self assert: result third asString = 'an OrderedCollection(#(#print))'.
self assert: result third first size = 1.
self assert: result third first first = #print.

self assert: result fourth asString = 'an OrderedCollection(#(#print))'.
self assert: result fourth first size = 1.
self assert: result fourth first first = #print.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testTry1Stmt4 [

self parse: 
'try :
	print x
except :
	print y
else :
	if x==y :
		print x
	else :
		print y
finally :
	print t
' rule: #try1Stmt.

self assert: result size = 4.

self assert: result first asString = 'an OrderedCollection(#(#print))'.
self assert: result first first size = 1.
self assert: result first first first = #print.

self assert: result second asString = 'an Array(an OrderedCollection(#(#print)))' .
self assert: result second first first size = 1.
self assert: result second first first first  = #print .

self assert: result third asString = 'an OrderedCollection(an Array(an Array(#expr an OrderedCollection(#(#print)) an OrderedCollection(#(#print)))))'.
self assert: result third first first size = 3.
self assert: result third first first first = #expr.
self assert: result third first first second first first = #print.
self assert: result third first first third first first = #print.

self assert: result fourth asString = 'an OrderedCollection(#(#print))'.
self assert: result fourth first size = 1.
self assert: result fourth first first = #print.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testTry1Stmt5 [

self parse: 
'try :
	print x
except :
	print y
else :
	if x==y :
		print x
finally :
	print t
' rule: #try1Stmt.

self assert: result size = 4.

self assert: result first asString = 'an OrderedCollection(#(#print))'.
self assert: result first first size = 1.
self assert: result first first first = #print.

self assert: result second asString = 'an Array(an OrderedCollection(#(#print)))' .
self assert: result second first first size = 1.
self assert: result second first first first  = #print .

self assert: result third asString = 'an OrderedCollection(an Array(an Array(#expr an OrderedCollection(#(#print)) nil)))'.
self assert: result third first first size = 3.
self assert: result third first first first = #expr.
self assert: result third first first second first first = #print.
self assert: result third first first third = nil.

self assert: result fourth asString = 'an OrderedCollection(#(#print))'.
self assert: result fourth first size = 1.
self assert: result fourth first first = #print.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testTry2Stmt [

self parse: 
'try :
	print x
finally :
	print y
' rule: #try2Stmt.

self assert: result size = 2.

self assert: result first asString = 'an OrderedCollection(#(#print))'.
self assert: result first first first = #print.

self assert: result second asString = 'an OrderedCollection(#(#print))'.
self assert: result second first first = #print.

]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testWhileStmt [

self parse: 
'while x < y :
	print x
	print y
else :
	print z
' rule: #whileStmt.

self assert: result size = 3.

self assert: result first = #expr .

self assert: result second asString  = 'an OrderedCollection(#(#print #print))'. 
self assert: result second first size = 2.
self assert: result second first first  = #print.
self assert: result second first second = #print.

self assert: result third asString = 'an OrderedCollection(#(#print))'.
self assert: result third first size = 1.
self assert: result third first first = #print.

]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testWhileStmt2 [

self parse: 
'while true :
	print x
	print y
' rule: #whileStmt.

self assert: result size = 3.

self assert: result first = #expr .

self assert: result second asString  = 'an OrderedCollection(#(#print #print))'. 
self assert: result second first size = 2.
self assert: result second first first  = #print.
self assert: result second first second = #print.

self assert: result third = nil.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testWhileStmt3 [

self parse: 
'while x < y :
	print x
	print y
else :
	if x==y :
		print z
	else :
		print v
' rule: #whileStmt.

self assert: result size = 3.

self assert: result first = #expr .

self assert: result second asString  = 'an OrderedCollection(#(#print #print))'. 
self assert: result second first size = 2.
self assert: result second first first  = #print.
self assert: result second first second = #print.

self assert: result third asString = 'an OrderedCollection(an Array(an Array(#expr an OrderedCollection(#(#print)) an OrderedCollection(#(#print)))))'.
self assert: result third first first size = 3.
self assert: result third first first first = #expr.

self assert: result third first first second asString = 'an OrderedCollection(#(#print))'.
self assert: result third first first second first first = #print .

self assert: result third first first third asString = 'an OrderedCollection(#(#print))'.
self assert: result third first first third first first = #print.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testWhileStmt4 [

self parse: 
'while x < y :
	x = a + (b) + c
' rule: #whileStmt.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testWhileStmt5 [

self fail: 
'while x < y :
x = a + (b) + c
' rule: #whileStmt.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testWhileStmt6 [

self fail: 
'while x < y :
	x = 
a + (b) + c
' rule: #whileStmt.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testWhileStmt7 [

self parse: 
'while x < y :
	x = a + (
b) + c
' rule: #whileStmt.
]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testWithStmt [

self parse: 
'with x < y as [test] :
	print x
' rule: #withStmt.

self assert: result size = 2.

self assert: result first = #expr.

self assert: result second asString = 'an OrderedCollection(#(#print))'.
self assert: result second first first = #print.



]

{ #category : #'as yet unclassified' }
MiniPythonGrammarTest >> testWithStmt2 [

self parse: 
'with x < y as [test] :
	if x==y :
		print x
	else :
		print z
' rule: #withStmt.

self assert: result size = 2.

self assert: result first = #expr.

self assert: result second asString = 'an OrderedCollection(an Array(an Array(#expr an OrderedCollection(#(#print)) an OrderedCollection(#(#print)))))'.
self assert: result second first first size = 3.
self assert: result second first first first = #expr.
self assert: result second first first second first first= #print.
self assert: result second first first third first first = #print.



]
