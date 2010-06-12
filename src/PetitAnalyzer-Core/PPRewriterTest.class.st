Class {
	#name : #PPRewriterTest,
	#superclass : #PPAbstractParseTest,
	#instVars : [
		'rewriter'
	],
	#category : #'PetitAnalyzer-Tests'
}

{ #category : #running }
PPRewriterTest >> setUp [
	rewriter := PPRewriter new
]

{ #category : #testing }
PPRewriterTest >> testDuplicationRemoval [
	| duplicate before between after result |
	duplicate := PPPattern any.
	before := PPListPattern any.
	between := PPListPattern any.
	after := PPListPattern any.
	rewriter
		replace: before / duplicate / between / duplicate / after
		with: before / duplicate / between / after.
	
	result := rewriter execute: $a asParser / $a asParser.
	self assert: rewriter hasChanged.
	self assert: result children size = 1.
	self assert: result children first literal = $a.
	
	result := rewriter execute: $b asParser / $a asParser / $a asParser.
	self assert: rewriter hasChanged.
	self assert: result children size = 2.
	self assert: result children first literal = $b.
	self assert: result children last literal = $a.
	
	result := rewriter execute: $a asParser / $b asParser / $a asParser.
	self assert: rewriter hasChanged.
	self assert: result children size = 2.
	self assert: result children first literal = $a.
	self assert: result children last literal = $b.
	
	result := rewriter execute: $a asParser / $a asParser / $b asParser.
	self assert: rewriter hasChanged.
	self assert: result children size = 2.
	self assert: result children first literal = $a.
	self assert: result children last literal = $b	
]

{ #category : #testing }
PPRewriterTest >> testPatternRemoval [
	| pattern result |
	pattern := PPPattern kind: PPLiteralObjectParser.
	rewriter
		replace: pattern / pattern
		with: pattern.
	
	result := rewriter execute: $a asParser / $a asParser.
	self assert: rewriter hasChanged.
	self assert: result class = PPLiteralObjectParser.
	self assert: result literal = $a.
	
	result := rewriter execute: $a asParser / $a asParser / $a asParser.
	self deny: rewriter hasChanged.
	self assert: result class = PPChoiceParser.
	self assert: result children size = 3
]

{ #category : #testing }
PPRewriterTest >> testPatternReplacement [
	| pattern result |
	pattern := PPPattern kind: PPLiteralObjectParser.
	rewriter
		replace: pattern
		with: pattern , pattern.
	
	result := rewriter execute: $a asParser.
	self assert: rewriter hasChanged.
	self assert: result class = PPSequenceParser.
	self assert: result children first literal = $a.
	self assert: result children last literal = $a.
	
	result := rewriter execute: #any asParser.
	self deny: rewriter hasChanged.
	self assert: result class = PPPredicateObjectParser
]

{ #category : #testing }
PPRewriterTest >> testReplaceLiteral [
	| result |
	rewriter
		replace: $a asParser 
		with: $b asParser.
	
	result := rewriter execute: $a asParser.
	self assert: rewriter hasChanged.
	self assert: result literal = $b.
	
	result := rewriter execute: $c asParser.
	self deny: rewriter hasChanged.
	self assert: result literal = $c.
	
	result := rewriter execute: $a asParser , $b asParser , $c asParser.
	self assert: rewriter hasChanged.
	self assert: result children size = 3.
	self assert: result children first literal = $b.
	self assert: result children last literal = $c
]

{ #category : #testing }
PPRewriterTest >> testSwapTwoPattern [
	| first second result |
	first := PPPattern any.
	second := PPPattern any.
	rewriter
		replace: first , second
		with: second , first.
	
	result := rewriter execute: $a asParser , $b asParser.
	self assert: rewriter hasChanged.
	self assert: result children first literal = $b.
	self assert: result children last literal = $a.
	
	result := rewriter execute: $a asParser / $b asParser.
	self deny: rewriter hasChanged.
	self assert: result children first literal = $a.
	self assert: result children last literal = $b
]

{ #category : #testing }
PPRewriterTest >> testWrapLiteral [
	| result |
	rewriter
		replace: $a asParser
		withValueFrom: [ :parser | parser token ].
	
	result := rewriter execute: $a asParser.
	self assert: rewriter hasChanged.
	self assert: result class = PPTokenParser.
	self assert: result children first literal = $a.
	
	result := rewriter execute: $c asParser.
	self deny: rewriter hasChanged.
	self assert: result literal = $c.
	
	result := rewriter execute: $a asParser , $b asParser.
	self assert: rewriter hasChanged.
	self assert: result children first class = PPTokenParser.
	self assert: result children first children first literal = $a.
	self assert: result children last class = PPLiteralObjectParser.
	self assert: result children last literal = $b
]
