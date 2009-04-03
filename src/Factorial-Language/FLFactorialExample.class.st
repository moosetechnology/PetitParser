"
I implement the example given in ""factorial.txt"". The code can be edited directly in the Smalltalk code browser and is automatically parsed, transformed and eventually compiled down to Smalltalk bytecodes.
"
Class {
	#name : #FLFactorialExample,
	#superclass : #TestCase,
	#category : #'Factorial-Language'
}

{ #category : #accessing }
FLFactorialExample >> ack [
	^ 'ack m n = if (m == 0) then (n + 1) else if (n == 0) then (ack (m - 1) 1) else (ack (m - 1) (ack m (n - 1)))'
]

{ #category : #accessing }
FLFactorialExample >> fac [
	^ 'fac n = if (n == 0) then 1 else (mult n (fac (n - 1)))'
]

{ #category : #accessing }
FLFactorialExample >> fib [
	^ 'fib n = if (n == 0) then 0 else if (n == 1) then 1 else ((fib (n - 1)) + (fib (n - 2)))'
]

{ #category : #accessing }
FLFactorialExample >> mul [
	^ 'mult n m = if (n == 0) then 0 else (m + (mult (n - 1) m))'
]

{ #category : #testing }
FLFactorialExample >> testAck [
	self assert: (FLFactorialParser parse: self ack) = #('ack' #('m' 'n') '=' #('if' #('(' 'm' '==' '0' ')') 'then' #('(' 'n' '+' '1' ')') 'else' #('if' #('(' 'n' '==' '0' ')') 'then' #('(' 'ack' #(#('(' 'm' '-' '1' ')') '1') ')') 'else' #('(' 'ack' #(#('(' 'm' '-' '1' ')') #('(' 'ack' #('m' #('(' 'n' '-' '1' ')')) ')')) ')')))).
	self assert: ((FLFactorialPrinter parse: self ack) = self ack).
	self assert: ((FLFactorialCompiler parse: self ack) isKindOf: RBProgramNode)
]

{ #category : #testing }
FLFactorialExample >> testFac [
	self assert: (FLFactorialParser parse: self fac) = #('fac' #('n') '=' #('if' #('(' 'n' '==' '0' ')') 'then' '1' 'else' #('(' 'mult' #('n' #('(' 'fac' #(#('(' 'n' '-' '1' ')')) ')')) ')'))).
	self assert: ((FLFactorialPrinter parse: self fac) = self fac).
	self assert: ((FLFactorialCompiler parse: self fac) isKindOf: RBProgramNode)
]

{ #category : #testing }
FLFactorialExample >> testFib [
	self assert: (FLFactorialParser parse: self fib) = #('fib' #('n') '=' #('if' #('(' 'n' '==' '0' ')') 'then' '0' 'else' #('if' #('(' 'n' '==' '1' ')') 'then' '1' 'else' #('(' #('(' 'fib' #(#('(' 'n' '-' '1' ')')) ')') '+' #('(' 'fib' #(#('(' 'n' '-' '2' ')')) ')') ')')))).
	self assert: ((FLFactorialPrinter parse: self fib) = self fib).
	self assert: ((FLFactorialCompiler parse: self fib) isKindOf: RBProgramNode)
]

{ #category : #testing }
FLFactorialExample >> testMul [
	self assert: (FLFactorialParser parse: self mul) = #('mult' #('n' 'm') '=' #('if' #('(' 'n' '==' '0' ')') 'then' '0' 'else' #('(' 'm' '+' #('(' 'mult' #(#('(' 'n' '-' '1' ')') 'm') ')') ')'))).
	self assert: ((FLFactorialPrinter parse: self mul) = self mul).
	self assert: ((FLFactorialCompiler parse: self mul) isKindOf: RBProgramNode)
]
