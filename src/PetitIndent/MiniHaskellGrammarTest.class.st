Class {
	#name : #MiniHaskellGrammarTest,
	#superclass : #PPCompositeParserTest,
	#instVars : [
		'debugResult'
	],
	#category : #'PetitIndent-Examples'
}

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> parse: aString rule: aSymbol [
	| production |
	production := self parserInstanceFor: aSymbol.
	debugResult := production end parse: aString.
	result := debugResult.
	self
		deny: result isPetitFailure
		description: 'Unable to parse ' , aString printString.
	^ result
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> parserClass [
	^ MiniHaskellGrammar
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testDo1 [
	| string |

	"
		Please note that ST editor does not have monospaced editor!
	"	
	string := 
'
do print 1
   print 2
   print 3'.

	self parse: string rule: #do.
	self assert: result size = 3.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testDo2 [
	| string |

	"
		Please note that ST editor does not have monospaced editor!
	"	
	string := 
'
do print 1
   print 2
   print 3

print 4
'.

	self parse: string rule: #start.
	self assert: result size = 2.
	self assert: result first size = 3.
	self assert: result second = #print.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testDo3 [
	| string |

	"
		Please note that ST editor does not have monospaced editor!
	"	
	string := 
'
do print 1
print 2
print 3

print 4'.

	self parse: string rule: #start.
	self assert: result size = 4.
	self assert: result first size = 1.
	self assert: result second = #print.
	self assert: result third  = #print.	
	self assert: result fourth = #print.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testDo4 [
	| string |

	"
		Please note that ST editor does not have monospaced editor!
	"	
	string := 
'
do print 1
   if foo
    then print 2
    else print 3
   print 4
'.

	self parse: string rule: #start.
	self assert: result first size = 3.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testDo5 [
	| string |

	"
		Please note that ST editor does not have monospaced editor!
	"	
	string := 
'
     do 
 print 1
 print 2'.

	self parse: string rule: #do.
	self assert: result size = 2.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testDo6 [
	| string |

	"
		Please note that ST editor does not have monospaced editor!
	"	
	string := 
'
     do 
print 1
print 2'.

	self parse: string rule: #do.
	self assert: result size = 2.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testIf [
	| string |

	string := 
'if foo then print 1 else print 2'.

	self parse: string rule: #if.
	self assert: result second size = 1.
	self assert: result second first = #print.
	self assert: result third size = 1.
	self assert: result third first = #print.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testIf10 [
	| string |

	"
		Please note that ST editor does not have monospaced editor!
	"

	string := 
'
if foo then print 1
       else print 2
'.

	self parse: string rule: #if.
	self assert: result size = 3.
	self assert: result first = 'foo'.
	self assert: result second first = #print.
	self assert: result third first = #print.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testIf11 [
	| string |

	"
		Please note that ST editor does not have monospaced editor!
	"

	string := 
'
if foo then print 1
'.

	self parse: string rule: #if.
	self assert: result size = 3.
	self assert: result first = 'foo'.
	self assert: result second first = #print.
	self assert: result third = nil.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testIf12 [
	| string |

	"
		Please note that ST editor does not have monospaced editor!
	"

	string := 
'
if foo then print 1
            print 2
'.

	self parse: string rule: #if.
	self assert: result size = 3.
	self assert: result first = 'foo'.
	self assert: result second first = #print.
	self assert: result second second = #print.
	self assert: result third = nil.	
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testIf2 [
	| string |

	"
		Please note that ST editor does not have monospaced editor!
	"	
	string := 
'
if foo 
	then print 1
	else print 2
'.

	self parse: string rule: #if.
	self assert: result second size = 1.
	self assert: result second first = #print.
	self assert: result third size = 1.
	self assert: result third first = #print.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testIf3 [
	| string |

	"
		Please note that ST editor does not have monospaced editor!
	"	
	string := 
'
if foo 
	then print 1 
else print 2'.

	self fail: string rule: #if.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testIf4 [
	| string |

	"
		Please note that ST editor does not have monospaced editor!
	"	
	string := 
'
if foo 
	then print 1
	     print 11      
	else print 2
	     print22
'.

	self parse: string rule: #if.
	self assert: result second size = 2.
	self assert: result third size = 2.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testIf5 [
	| string |

	"
		Please note that ST editor does not have monospaced editor!
	"	
	string := 
'
if foo 
	then print 1
	     print 11      
	else print 2

	print 42
'.

	self parse: string rule: #start.
	self assert: result size = 2.
	self assert: result first second size = 2.
	self assert: result first third size = 1.
	self assert: result second = #print.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testIf6 [
	| string |

	"
		Please note that ST editor does not have monospaced editor!
	"	
	string := 
'
if foo
then print 2
else print 3
'.

	self parse: string rule: #if.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testIf7 [
	| string |

	"
		Please note that ST editor does not have monospaced editor!
	"	
	string := 
'
if foo 
   then if bar
               then print 21
               else print 22   
                    print 23      
   else print 11
        print 12
        print 13
'.

	self parse: string rule: #if.
	self assert: result size = 3.
	self assert: result first = 'foo'.
	self assert: result second first first = 'bar'.
	self assert: result second first second size = 1.
	self assert: result second first third size = 2.
	self assert: result third size = 3.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testIf8 [
	| string |

	"
		Please note that ST editor does not have monospaced editor!
	"	
	string := 
'
if foo 
	then if bar
               then print 21
               else print 22 '.

	self parse: string rule: #if.
	self assert: result size = 3.
	self assert: result first = 'foo'.
	self assert: result second first first = 'bar'.
	self assert: result second first second size = 1.
	self assert: result second first second first = #print.
	self assert: result second first third size = 1.
	self assert: result second first third first = #print.
	self assert: result third isNil.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testIf9 [
	| string |

	"
		Please note that ST editor does not have monospaced editor!
	"

	string := 
'
if foo 
	then if bar
               then print 21
	else print 22   
'.

	self parse: string rule: #if.
	self assert: result size = 3.
	self assert: result first = 'foo'.
	self assert: result second first first = 'bar'.
	self assert: result second first second size = 1.
	self assert: result second first second first = #print.
	self assert: result second first third isNil.
	self assert: result third size = 1.
	self assert: result third first = #print.

]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testIfSingleline [
	| string |

	string := 
'if foo then print 1 else print 2'.

	self parse: string rule: #ifSingleline.
	self assert: result second size = 1.
	self assert: result second first = #print.
	self assert: result third size = 1.
	self assert: result third first = #print.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testIfSingleline2 [
	| string |
	"Remember, the usual font for editor is not monospaced!"
	string := 
'if foo then print1 
            print 2 else print 2'.

	self parse: string rule: #ifSingleline.
	self assert: result second size = 2.
	self assert: result second first = #print.
	self assert: result third size = 1.
	self assert: result third first = #print.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testLet1 [
	| string |

	"
	This looks weird, but b starts at position 4, the same position as a. 
	Yet the normal ST editor shows as if b is less indented than a :(
	"	
	string := 
'
let a = 1
    b = 2
'.

	self parse: string rule: #let.
	self assert: result size = 2.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testLet2 [
	| string |

	"
	This looks weird, but b starts at position 5, one more as a. 
	Yet the normal ST editor shows as if b is indented the same way as a :(
	"	
	string := 
'
let a = 1
     b = 2
'.

	self fail: string rule: #let.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testLet3 [
	| string |

	string := 
'
let 
	a = 1
	b = 2
'.

	self parse: string rule: #let.
	self assert: result size = 2.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testNestedDo1 [
	| string |

	"
		Please note that ST editor does not have monospaced editor!
	"	
	string := 
'
  do print 1
     print 2
     do print 3
        print 4'.

	self parse: string rule: #do.
	self assert: result size = 3.
	self assert: result third size = 2.
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammarTest >> testNestedDo2 [
	| string |

	"
		Please note that ST editor does not have monospaced editor!
	"	
	string := 
'
  do print 1
     print 2
     do print 3
        print 4
     print 5'.

	self parse: string rule: #do.
	self assert: result size = 4.
	self assert: result third size = 2.
]
