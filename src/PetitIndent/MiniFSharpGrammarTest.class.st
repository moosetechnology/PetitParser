Class {
	#name : #MiniFSharpGrammarTest,
	#superclass : #PPCompositeParserTest,
	#instVars : [
		'aPPContext',
		'debugResult'
	],
	#category : #'PetitIndent-Examples'
}

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> parserClass [
	^ MiniFSharpGrammar
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testConst [
	self parse: '1' rule: #const.
	self assert: result = 1.
	self parse: '123' rule: #const.	
	self assert: result = 123.
	self parse: '"Hi"' rule: #const.
	self assert: result = 'Hi'.	

]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testExpr1 [
	self parse: '1;2' rule: #expr.
	self assert: result size = 2.
	self assert: result first = 1.
	self assert: result second = 2.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testExpr2 [
	self parse: 'a+b' rule: #expr.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testExpr3 [
	self parse: 'printf "hi"' rule: #expr.
	self assert: result size = 1.
	self assert: result first first = #printf.
	self assert: result first second = 'hi'.
	
	self parse: 'printf a' rule: #expr.	
	self assert: result size = 1.
	self assert: result first first = #printf.
	self assert: result first second = 'a'.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testExprArithmetics [
	self parse: '1+2' rule: #expr.
	self assert: result size = 2.
	self assert: result first = 1.
	self assert: result second = 2.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testExprArithmetics2 [
	self parse: '1+2+3' rule: #expr.
	self assert: result size = 3.
	self assert: result first = 1.
	self assert: result second = 2.
	self assert: result third = 3.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testExprArithmetics3 [
	self parse: 
' 
   1+2+3' rule: #seqBlock.

	self assert: result size = 3.
	self assert: result first = 1.
	self assert: result second = 2.
	self assert: result third = 3.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testExprArithmetics4 [
	self parse: 
' 
   1
   -2
   *3' rule: #seqBlock.

	self assert: result size = 3.
	self assert: result first = 1.
	self assert: result second = 2.
	self assert: result third = 3.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testExprArithmetics5 [
	self parse: 
' 
   1
  +2
 - 3' rule: #seqBlock.

	self assert: result size = 3.
	self assert: result first = 1.
	self assert: result second = 2.
	self assert: result third = 3.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testExprSeq1 [
	self parse: '
	printf 1;
	printf 2;
	printf 3' rule: #seqBlock.

self assert: result size = 3.
self assert: result first first = #printf.
self assert: result first second = 1.
self assert: result third first = #printf.
self assert: result third second = 3.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testExprSeq2 [	
	
self parse: '
	printf 1;
	printf 2;
	
	printf 3' rule: #seqBlock.

self assert: result size = 3.
self assert: result first first = #printf.
self assert: result first second = 1.
self assert: result third first = #printf.
self assert: result third second = 3.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testExprSeq3 [	
	
self fail: '
   printf 1;
  printf 2;	
   printf 3' rule: #seqBlock.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testExprSeq4 [
	
self parse: '
	printf 1;
	 printf 2;
	printf 3' rule: #seqBlock.

self assert: result size = 3.
self assert: result first first = #printf.
self assert: result first second = 1.
self assert: result third first = #printf.
self assert: result third second = 3.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testExprSeqLightweight1 [	

self parse: '
   printf 1
   printf 2
   printf 3'
rule: #seqBlock.

self assert: result size = 3.
self assert: result first first = #printf.
self assert: result first second = 1.
self assert: result third first = #printf.
self assert: result third second = 3.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testExprSeqLightweight2 [

self parse: '
   printf 1
   printf 2

   printf 3'
rule: #seqBlock.

self assert: result size = 3.
self assert: result first first = #printf.
self assert: result first second = 1.
self assert: result third first = #printf.
self assert: result third second = 3.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testExprSeqLightweight3 [

parser := self parserInstanceFor: #seqBlock.
	
self fail: '
   printf 1
  printf 2
   printf 3'
rule: #seqBlock.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testExprSeqLightweight4 [

parser := self parserInstanceFor: #seqBlock.
	
self fail: '
   printf 1
   printf 2
    printf 3'
rule: #seqBlock.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testExprSeqLightweight5 [

parser := self parserInstanceFor: #seqBlock.
	
self fail: '
   printf 1
   printf 2
    printf 3'
rule: #seqBlock.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testFor [
	self parse: 'for a = 1 to 10 do printf a done' rule: #for.
	self assert: result size = 8.
	self assert: result eighth size = 1.
	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testFor2 [
	self parse: 
'for a = 1 to 10 do 
	printf a;
	printf b;
	printf c;
done' rule: #for.

	self assert: result size = 8.
	self assert: result eighth size = 4.
	self assert: result eighth first first = #printf.
	self assert: result eighth first second = 'a'.
	self assert: result eighth second first = #printf.
	self assert: result eighth second second = 'b'.
	self assert: result eighth third first = #printf.	
	self assert: result eighth third second = 'c'.	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testFor3 [
	self fail: 
'for a = 1 to 10 do 
   printf a;
  printf b;
   printf c;
done' rule: #for.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testFor4 [
	self parse: 
'for a = 1 to 10 do 
   printf a
   ;printf b;
done' rule: #for.

	self assert: result size = 8.
	self assert: result eighth size = 3.
	self assert: result eighth first first = #printf.
	self assert: result eighth first second = 'a'.
	self assert: result eighth second first = #printf.
	self assert: result eighth second second = 'b'.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testForLightweight1 [
	self parse: 
'for a = 1 to 10 do 
	printf a
	printf b
	printf c
done' rule: #for.
	
	self assert: result size = 8.
	self assert: result eighth size = 3.
	self assert: result eighth first first = #printf.
	self assert: result eighth first second = 'a'.
	self assert: result eighth second first = #printf.
	self assert: result eighth second second = 'b'.
	self assert: result eighth third first = #printf.	
	self assert: result eighth third second = 'c'.	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testForLightweight10 [
	self parse: 
'for a = 1 to 10 do 
	printf a
	printf b
	
	printf c' rule: #for.

	self assert: result size = 8.
	self assert: result eighth size = 3.
	self assert: result eighth first first = #printf.
	self assert: result eighth first second = 'a'.
	self assert: result eighth second first = #printf.
	self assert: result eighth second second = 'b'.
	self assert: result eighth third first = #printf.	
	self assert: result eighth third second = 'c'.	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testForLightweight11 [
	self fail: 
'for a = 1 to 11 do 
    printf a
   printf b' rule: #for.
	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testForLightweight2 [
	self parse: 
'for a = 1 to 10 do 
	printf a
	printf b
	
	printf c
done' rule: #for.
	
	self assert: result size = 8.
	self assert: result eighth size = 3.
	self assert: result eighth first first = #printf.
	self assert: result eighth first second = 'a'.
	self assert: result eighth second first = #printf.
	self assert: result eighth second second = 'b'.
	self assert: result eighth third first = #printf.	
	self assert: result eighth third second = 'c'.	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testForLightweight3 [
	self fail: 
'for a = 1 to 10 do 
   printf a
  printf b
   printf c
done' rule: #for.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testForLightweight4 [
	self parse: 
'for a = 1 to 10 do 
	printf a
	printf b
	
	printf c
' rule: #for.
	
	self assert: result size = 8.
	self assert: result eighth size = 3.
	self assert: result eighth first first = #printf.
	self assert: result eighth first second = 'a'.
	self assert: result eighth second first = #printf.
	self assert: result eighth second second = 'b'.
	self assert: result eighth third first = #printf.	
	self assert: result eighth third second = 'c'.	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testForLightweight5 [
	self parse: 
'
  for a = 1 to 10 do 
	printf a
	printf b
	printf c
  done' rule: #for.
	
	self assert: result size = 8.
	self assert: result eighth size = 3.
	self assert: result eighth first first = #printf.
	self assert: result eighth first second = 'a'.
	self assert: result eighth second first = #printf.
	self assert: result eighth second second = 'b'.
	self assert: result eighth third first = #printf.	
	self assert: result eighth third second = 'c'.	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testForLightweight6 [
	self parse: 
'
  for a = 1 to 10 do 
    printf a
    printf b
    printf c
   done' rule: #for.
	
	self assert: result size = 8.
	self assert: result eighth size = 3.
	self assert: result eighth first first = #printf.
	self assert: result eighth first second = 'a'.
	self assert: result eighth second first = #printf.
	self assert: result eighth second second = 'b'.
	self assert: result eighth third first = #printf.	
	self assert: result eighth third second = 'c'.	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testForLightweight7 [
	self parse: 
'
  for a = 1 to 10 do 
	printf a
	printf b
	printf c
 done' rule: #for.

	self assert: result size = 8.
	self assert: result eighth size = 3.
	self assert: result eighth first first = #printf.
	self assert: result eighth first second = 'a'.
	self assert: result eighth second first = #printf.
	self assert: result eighth second second = 'b'.
	self assert: result eighth third first = #printf.	
	self assert: result eighth third second = 'c'.	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testForLightweight8 [
	self parse: 
'
  for a = 1 to 10 do 
 printf a
 printf b
 printf c
  done' rule: #for.
	
	self assert: result size = 8.
	self assert: result eighth size = 3.
	self assert: result eighth first first = #printf.
	self assert: result eighth first second = 'a'.
	self assert: result eighth second first = #printf.
	self assert: result eighth second second = 'b'.
	self assert: result eighth third first = #printf.	
	self assert: result eighth third second = 'c'.	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testForLightweight9 [
	self parse: 
'for a = 1 to 10 do 
	printf a
	printf b
	
	printf c
    ' rule: #for.
	
	self assert: result size = 8.
	self assert: result eighth size = 3.
	self assert: result eighth first first = #printf.
	self assert: result eighth first second = 'a'.
	self assert: result eighth second first = #printf.
	self assert: result eighth second second = 'b'.
	self assert: result eighth third first = #printf.	
	self assert: result eighth third second = 'c'.	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testForMixed1 [
	self parse: 
'for a = 1 to 10 do 
	printf a
	printf b;
	
	printf c
    ' rule: #for.
	
	self assert: result size = 8.
	self assert: result eighth size = 3.
	self assert: result eighth first first = #printf.
	self assert: result eighth first second = 'a'.
	self assert: result eighth second first = #printf.
	self assert: result eighth second second = 'b'.
	self assert: result eighth third first = #printf.	
	self assert: result eighth third second = 'c'.	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testForMixed2 [

	self parse: 
'for a = 1 to 10 do 
	printf a
	printf b;
	 printf c
' rule: #for.
	
	self assert: result size = 8.
	self assert: result eighth size = 3.
	self assert: result eighth first first = #printf.
	self assert: result eighth first second = 'a'.
	self assert: result eighth second first = #printf.
	self assert: result eighth second second = 'b'.
	self assert: result eighth third first = #printf.	
	self assert: result eighth third second = 'c'.	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testForMixed3 [

	self fail: 
'for a = 1 to 10 do 
	printf a
	 printf b;
	 printf c
' rule: #for.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testLet [
	self parse: 'let a = 1 in a' rule: #let.
	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testLet2 [
	self parse: 
'let a = 1 in 
 let b = 2 in 
    a + b' rule: #let.
	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testLet3 [
	self parse: 
'  let a = 1 in 
a' rule: #let.
	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testLetLightweight1 [
	self parse: 
'let a = 1
a' 
   rule: #let.
	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testLetLightweight2 [
	self fail: 
'let a = 1
   a' 
   rule: #let.
	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testLetLightweight3 [
	self parse: 
'let a = 3  
let b = 1 in
 a + b' 
   rule: #let.
	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testLetLightweight4 [

	self parse: 
'let a = 3  
let b = 1
a + b' 
   rule: #let.
	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testLetLightweight5 [
	self fail: 
'let a = 3  
let b = 1
 a + b' 
   rule: #let.
	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testLetLightweight6 [
	self fail: 
'let a = 1 in
 let b = 2
  a + b' 
   rule: #let.
	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testLetLightweight7 [
	
	self parse: 
'
  let a = 3  
  let b = 1 in
 a + b' 
   rule: #let.
	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testLetLightweight8 [
	
	self parse: 
'
  let a = 3  
  let b = 1
  a + b' 
   rule: #let.
	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testLetLightweight9 [
	
	self fail: 
'
  let a = 3  
  let b = 1
   a + b' 
   rule: #let.
	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testMixed [
	
	self parse: 
'
   let a = 3
          +1  
   let b = 1
   a + b' 
   rule: #let.

	self assert: result size = 2.
	self assert: result first first = 'a'.
	self assert: result first second first = 3.
	self assert: result first second second = 1.
	
	self assert: result second first first first = 'b'.
	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testMixed2 [
	
	self parse: 
'
   let a = 3
         + 1 in  
    let b = 1
    a + b' 
   rule: #let.

	self assert: result size = 2.
	self assert: result first first = 'a'.
	self assert: result first second first = 3.
	self assert: result first second second = 1.
	
	self assert: result second first first first = 'b'.
	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testMixed3 [
	
	self fail: 
'
   let a = 3
         + 1 in  
    let b = 1
     a + b' 
   rule: #let.
	
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testMixed4 [
	
	self parse: 
'
    let foo =
       let tick = printf "tick"
       let tack = printf "tock"
       let choose =
         x
       for i = 1 to 10 do
         choose
    printf "done"    
'.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testNumber [
	self parse: '1' rule: #number.
	self assert: result = 1.
	
	self parse: '123' rule: #const.	
	self assert: result = 123.
]

{ #category : #'as yet unclassified' }
MiniFSharpGrammarTest >> testValueDefinition [
	self parse: 'a = 123' rule: #valueDefinition.
	self parse: 'abc = 1' rule: #valueDefinition.	
]
