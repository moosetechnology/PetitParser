Class {
	#name : #PPParserDebuggerResultTest,
	#superclass : #TestCase,
	#category : #'PetitGui-Core'
}

{ #category : #tests }
PPParserDebuggerResultTest >> testArithmetic [
	| parser result |
	parser := PPArithmeticParser new.
	result := PPParserDebuggerResult parse: '1 + 2' with: parser.
	self assert: result children size = 1.
	self assert: result children first result = 3
]

{ #category : #tests }
PPParserDebuggerResultTest >> testSimple [ 
	| parser result |
	parser := nil asParser.
	result := PPParserDebuggerResult parse: '' with: parser.
	self assert: result children isEmpty
]
