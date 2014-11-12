Class {
	#name : #PPAlignedParserTest,
	#superclass : #PPAbstractParserTest,
	#instVars : [
		'parser',
		'input',
		'result'
	],
	#category : #'PetitIndent-Tests'
}

{ #category : #'as yet unclassified' }
PPAlignedParserTest >> assert: aParser parse: aCollection to: aTargetObject end: anInteger [
	^ result := super assert: aParser parse: aCollection to: aTargetObject end: anInteger
]

{ #category : #'as yet unclassified' }
PPAlignedParserTest >> testAlignedPlus [
	| foo |
	
	foo := 'foo' asParser.
	parser := foo plus aligned trim.
	
	input := 
'
	foo
	foo
'.
	
	self assert: parser parse: input to: #('foo' 'foo').
]

{ #category : #'as yet unclassified' }
PPAlignedParserTest >> testAlignedPlus2 [
	| foo |
	
	foo := 'foo' asParser.
	parser := foo plus aligned trim.
	
	input := 
'
	foo
'.
	
	self assert: parser parse: input to: #('foo').
]

{ #category : #'as yet unclassified' }
PPAlignedParserTest >> testAlignedPlus3 [
	| foo |
	
	foo := 'foo' asParser.
	parser := foo plus aligned trim.
	
	input := 
'
  foo
  foo
  foo 
'.
	
	self assert: parser parse: input to: #('foo' 'foo' 'foo').
]

{ #category : #'as yet unclassified' }
PPAlignedParserTest >> testAlignedPlus4 [
	| foo |
	
	foo := 'foo' asParser.
	parser := #space asParser star, foo plus aligned ==> #second.
	
	input := 
'
  foo
  foo
   foo 
'.
	
	self assert: parser parse: input to: #('foo' 'foo') end: 12.
]

{ #category : #'as yet unclassified' }
PPAlignedParserTest >> testAlignedPlus5 [
	| foo |
	
	foo := 'foo' asParser.
	parser := foo plus aligned trim.
	
	input := 
'

'.
	
	self assert: parser fail: input.
]

{ #category : #'as yet unclassified' }
PPAlignedParserTest >> testAlignedStar [
	| foo |
	
	foo := 'foo' asParser.
	parser := foo star aligned trim.
	
	input := 
'
	foo
	foo
'.
	
	self assert: parser parse: input to: #('foo' 'foo').
]

{ #category : #'as yet unclassified' }
PPAlignedParserTest >> testAlignedStar2 [
	| foo |
	
	foo := 'foo' asParser.
	parser := foo star aligned trim.
	
	input := 
'

'.
	
	self assert: parser parse: input to: #().
]

{ #category : #'as yet unclassified' }
PPAlignedParserTest >> testAlignedStar3 [
	| foo |
	
	foo := 'foo' asParser.
	parser := foo star aligned trim.
	
	input := 
'
  foo
  foo
  foo 
'.
	
	self assert: parser parse: input to: #('foo' 'foo' 'foo').
]

{ #category : #'as yet unclassified' }
PPAlignedParserTest >> testAlignedToIndent [
	| foo |
	
	foo := 'foo' asParser.
	parser := #indent asParser, foo aligned, #dedent asParser.
	
	input := 
' 
	foo
'.
	
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPAlignedParserTest >> testAlignedToIndent2 [
	| foo |
	
	foo := 'foo' asParser.
	parser := #indent asParser, foo aligned, #space asParser star, foo aligned, #dedent asParser.
	
	input := 
' 
	foo
	foo
'.
	
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPAlignedParserTest >> testAlignedToIndent3 [
	| foo |
	
	foo := 'foo' asParser.
	parser := #indent asParser, foo aligned, #space asParser star, foo aligned, #dedent asParser.
	
	input := 
' 
	foo
	 foo
'.
	
	self assert: parser fail: input.
]

{ #category : #'as yet unclassified' }
PPAlignedParserTest >> testAlignedToSelf1 [
	| foo |
	
	foo := 'foo' asParser.
	parser := foo rememberColumn trim, foo selfAligned.
	
	input := 
' 
  foo 
  foo'.
	
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPAlignedParserTest >> testAlignedToSelf2 [
	| foo |
	
	foo := 'foo' asParser.
	parser := foo rememberColumn trim, foo selfAligned.
	
	input := 
' 
  foo 
   foo'.
	
	self assert: parser fail: input.
]
