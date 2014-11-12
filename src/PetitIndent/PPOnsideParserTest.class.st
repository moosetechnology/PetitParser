Class {
	#name : #PPOnsideParserTest,
	#superclass : #PPAbstractParserTest,
	#instVars : [
		'input',
		'result'
	],
	#category : #'PetitIndent-Tests'
}

{ #category : #'as yet unclassified' }
PPOnsideParserTest >> assert: aParser parse: aCollection to: aTargetObject end: anInteger [
	^ result := super assert: aParser parse: aCollection to: aTargetObject end: anInteger
]

{ #category : #'as yet unclassified' }
PPOnsideParserTest >> testDeepOnside01 [
	| list word content p |
	
	list := 'list->' asParser.
	word := #word asParser plus.
	content := word trim star.	
	p := (list setIndentationLevel, 
			(content deepStrictlyOnside),
		  list removeIndentationLevel) ==> #second.
 	
	input := 
'
   list->
      lorem
      ipsum
'.
	
	self assert: (p trim end) parse: input.
	self assert: result size = 2.
	
]

{ #category : #'as yet unclassified' }
PPOnsideParserTest >> testDeepOnside02 [
	| list word content p |
	
	list := 'list->' asParser.
	word := #word asParser plus.
	content := word trim star.	
	p := (list setIndentationLevel, 
			(content deepStrictlyOnside),
		  list removeIndentationLevel) ==> #second.
 	
	input := 
'
   list->
      lorem
   ipsum
'.
	
	self assert: (p trim end) fail: input.
]

{ #category : #'as yet unclassified' }
PPOnsideParserTest >> testOnside1 [
	| foo |
	
	foo := 'foo' asParser.
	parser := foo setIndentationLevel trim, foo onside.
	
	input := 
' 
  foo 
   foo'.
	
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPOnsideParserTest >> testOnside2 [
	| foo |
	
	foo := 'foo' asParser.
	parser := foo setIndentationLevel trim, foo onside.
	
	input := 
' 
  foo 
  foo'.
	
	self assert: parser parse:  input.
]

{ #category : #'as yet unclassified' }
PPOnsideParserTest >> testOnside3 [
	| foo |
	
	foo := 'foo' asParser.
	parser := foo setIndentationLevel trim, foo onside.
	
	input := 
' 
  foo 
 foo'.
	
	
	self assert: parser fail: input.
]

{ #category : #'as yet unclassified' }
PPOnsideParserTest >> testStrictlyOnside1 [
	| foo |
	
	foo := 'foo' asParser.
	parser := foo setIndentationLevel trim, foo strictlyOnside.
	
	input := 
' 
  foo 
   foo'.
	
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPOnsideParserTest >> testStrictlyOnside2 [
	| foo |
	
	foo := 'foo' asParser.
	parser := foo setIndentationLevel trim, foo strictlyOnside.
	
	input := 
' 
  foo 
  foo'.
	
	self assert: parser fail: input.
]

{ #category : #'as yet unclassified' }
PPOnsideParserTest >> testStrictlyOnside3 [
	| foo |
	
	foo := 'foo' asParser.
	parser := foo setIndentationLevel trim, foo strictlyOnside.
	
	input := 
' 
  foo 
 foo'.
	
	
	self assert: parser fail: input.
]
