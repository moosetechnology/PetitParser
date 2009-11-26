Class {
	#name : #PPAnalyzerTest,
	#superclass : #PPAbstractParseTest,
	#category : #'PetitAnalyzer-Tests'
}

{ #category : #accessing }
PPAnalyzerTest class >> packageNamesUnderTest [
	^ #('PetitAnalyzer')
]

{ #category : #utilities }
PPAnalyzerTest >> assert: aCollection includes: aString epsilon: aBoolean [
	| parsers checker stream |
	parsers := aCollection
		collect: [ :each | each end ].
	checker := [ :string |
		parsers anySatisfy: [ :parser |
			(parser parse: string asParserStream)
				isFailure not ] ].
	stream := WriteStream on: String new.
	32 to: 127 do: [ :index |
		(checker value: (String with: (Character value: index)))
			ifTrue: [ stream nextPut: (Character value: index) ] ].
	self
		assert: stream contents = aString
		description: 'Expected ' , aString printString , ', but got ' , stream contents printString.
	self
		assert: (checker value: '') = aBoolean
		description: 'Expected epsilon to ' , (aBoolean ifTrue: [ 'be' ] ifFalse: [ 'not be' ]) , '  included'
]

{ #category : #accessing }
PPAnalyzerTest >> grammarA [
	"Güting, Erwig, Übersetzerbau, Springer (p.63)"

	| grammar |
	grammar := Dictionary new.
	
	" terminals "
	grammar at: #a put: $a asParser.
	grammar at: #b put: $b asParser.
	grammar at: #c put: $c asParser.
	grammar at: #d put: $d asParser.
	grammar at: #e put: nil asParser.
	
	" non terminals "
	grammar at: #B put: (grammar at: #b) / (grammar at: #e).
	grammar at: #A put: (grammar at: #a) / (grammar at: #B).
	grammar at: #S put: (grammar at: #A) , (grammar at: #B) , (grammar at: #c) , (grammar at: #d).
	
	^ grammar	
]

{ #category : #accessing }
PPAnalyzerTest >> grammarB [
	"The canonical grammar to exercise first- and follow-set calculation, probably originally from the dragon-book."

	| grammar |
	grammar := Dictionary new.
	#(E Ep T Tp F) 		do: [ :each | grammar at: each put: (PPUnresolvedParser named: each) ].
		
	(grammar at: #E)		def: (grammar at: #T) , (grammar at: #Ep).
	(grammar at: #Ep)	def: ($+ asParser , (grammar at: #T) , (grammar at: #Ep)) optional.
	
	(grammar at: #T)		def: (grammar at: #F) , (grammar at: #Tp).
	(grammar at: #Tp)	def: ($* asParser , (grammar at: #F) , (grammar at: #Tp)) optional.
	
	(grammar at: #F)		def: ($( asParser , (grammar at: #E) , $) asParser) / $i asParser.
			
	#(E Ep T Tp F) 		do: [ :each | (grammar at: each) name: each ].
	
	^ grammar
]

{ #category : #accessing }
PPAnalyzerTest >> grammarC [
	"A highly recrusive grammar."

	| grammar |
	grammar := PPUnresolvedParser new.
	grammar def: (grammar , $+ asParser , grammar) / $1 asParser.
	^ grammar
]

{ #category : #accessing }
PPAnalyzerTest >> grammarD [
	"A highly ambiguous grammar from: Saichaitanya Jampana. Exploring the problem of ambiguity in context-free grammars. Master?s thesis, Oklahoma State University, July 2005."

	| grammar |
	grammar := Dictionary new.
	#(S A a B b)			do: [ :each | grammar at: each put: (PPUnresolvedParser named: each) ].
	
	(grammar at: #a)		def: $a asParser.
	(grammar at: #b)		def: $b asParser.
		
	(grammar at: #S)		def: (grammar at: #A) , (grammar at: #B) / (grammar at: #a).
	(grammar at: #A)		def: (grammar at: #S) , (grammar at: #B) / (grammar at: #b).
	(grammar at: #B)		def: (grammar at: #B) , (grammar at: #A) / (grammar at: #a).
		
	^ grammar
]

{ #category : #accessing }
PPAnalyzerTest >> grammarE [
	"The most stupid parser, it just references itself and never consumes anything. All algorithms should survive such an attack."

	| parser |
	parser := PPDelegateParser new.
	parser setParser: parser.
	^ parser
]

{ #category : #testing }
PPAnalyzerTest >> testAllLeafNodes [
	| p1 p2 p3 |
	p1 := #lowercase asParser.
	p2 := p1 ==> #asUppercase.
	p3 := PPUnresolvedParser new.
	p3 def: p2 / p3.
	self assert: p1 allLeafNodes size = 1.
	self assert: p2 allLeafNodes size = 1.
	self assert: p3 allLeafNodes size = 1
]

{ #category : #testing }
PPAnalyzerTest >> testAllNodes [
	| p1 p2 p3 |
	p1 := #lowercase asParser.
	p2 := p1 ==> #asUppercase.
	p3 := PPUnresolvedParser new.
	p3 def: p2 / p3.
	self assert: p1 allNodes size = 1.
	self assert: p2 allNodes size = 2.
	self assert: p3 allNodes size = 3
]

{ #category : #'testing-cycleset' }
PPAnalyzerTest >> testCycleSetGrammarA [
	self grammarA do: [ :each | self assert: each cycleSet isEmpty ]
]

{ #category : #'testing-cycleset' }
PPAnalyzerTest >> testCycleSetGrammarB [
	self grammarB do: [ :each | self assert: each cycleSet isEmpty ]
]

{ #category : #'testing-cycleset' }
PPAnalyzerTest >> testCycleSetGrammarC [
	| grammar cycleSet |
	grammar := self grammarC.
	cycleSet := grammar cycleSet.
	self assert: (cycleSet size = 2).
	self assert: (cycleSet includes: grammar)
]

{ #category : #'testing-cycleset' }
PPAnalyzerTest >> testCycleSetGrammarD [
	| grammar cycleSet |
	grammar := self grammarD.
	
	cycleSet := (grammar at: #S) cycleSet.
	self assert: (cycleSet size = 4).
	self assert: (cycleSet includes: (grammar at: #A)).
	self assert: (cycleSet includes: (grammar at: #S)).
	
	cycleSet := (grammar at: #A) cycleSet.
	self assert: (cycleSet size = 4).
	self assert: (cycleSet includes: (grammar at: #A)).
	self assert: (cycleSet includes: (grammar at: #S)).

	cycleSet := (grammar at: #B) cycleSet.
	self assert: (cycleSet size = 2).
	self assert: (cycleSet includes: (grammar at: #B))
]

{ #category : #'testing-cycleset' }
PPAnalyzerTest >> testCycleSetGrammarE [
	| grammar cycleSet |
	grammar := self grammarE.
	cycleSet := grammar cycleSet.
	self assert: (cycleSet size = 1).
	self assert: (cycleSet includes: grammar)
]

{ #category : #'testing-cycleset' }
PPAnalyzerTest >> testCycleSetInChoice [
	| parser cycleSet |
	parser := PPUnresolvedParser new.
	parser def: parser / $a asParser.
	cycleSet := parser cycleSet.
	self assert: (cycleSet size = 1).
	self assert: (cycleSet includes: parser).
	
	parser := PPUnresolvedParser new.
	parser def: $a asParser / parser.
	cycleSet := parser cycleSet.
	self assert: (cycleSet size = 1).
	self assert: (cycleSet includes: parser).
]

{ #category : #'testing-cycleset' }
PPAnalyzerTest >> testCycleSetInSequence [
	| parser cycleSet |
	parser := PPUnresolvedParser new.
	parser def: parser , $a asParser.
	cycleSet := parser cycleSet.
	self assert: (cycleSet size = 1).
	self assert: (cycleSet includes: parser).
	
	parser := PPUnresolvedParser new.
	parser def: nil asParser , parser.
	cycleSet := parser cycleSet.
	self assert: (cycleSet size = 1).
	self assert: (cycleSet includes: parser).
	
	parser := PPUnresolvedParser new.
	parser def: $a asParser , parser.
	cycleSet := parser cycleSet.
	self assert: cycleSet isEmpty
]

{ #category : #'testing-firstset' }
PPAnalyzerTest >> testFirstSetExpression [
	| grammar |
	grammar := PPArithmeticParser new.
	self assert: grammar start firstSet includes: '(-0123456789' epsilon: false.
	self assert: grammar addition firstSet includes: '(-0123456789' epsilon: false.
	self assert: grammar factors firstSet includes:  '(-0123456789' epsilon: false.
	self assert: grammar multiplication firstSet includes:  '(-0123456789' epsilon: false.
	self assert: grammar number firstSet includes: '-0123456789' epsilon: false.
	self assert: grammar parentheses firstSet includes: '(' epsilon: false.
	self assert: grammar power firstSet includes: '(-0123456789' epsilon: false.
	self assert: grammar primary firstSet includes: '(-0123456789' epsilon: false.
	self assert: grammar terms firstSet includes: '(-0123456789' epsilon: false
]

{ #category : #'testing-firstset' }
PPAnalyzerTest >> testFirstSetGrammarA [
	| grammar |
	grammar := self grammarA.
	self assert: (grammar at: #a) firstSet includes: 'a' epsilon: false.
	self assert: (grammar at: #b) firstSet includes: 'b' epsilon: false.
	self assert: (grammar at: #c) firstSet includes: 'c' epsilon: false.
	self assert: (grammar at: #d) firstSet includes: 'd' epsilon: false.
	self assert: (grammar at: #e) firstSet includes: '' epsilon: true.
	self assert: (grammar at: #S) firstSet includes: 'abc' epsilon: false.
	self assert: (grammar at: #A) firstSet includes: 'ab' epsilon: true.
	self assert: (grammar at: #B) firstSet includes: 'b' epsilon: true
]

{ #category : #'testing-firstset' }
PPAnalyzerTest >> testFirstSetGrammarB [
	| grammar |
	grammar := self grammarB.
	self assert: (grammar at: #E) firstSet includes: '(i' epsilon: false.
	self assert: (grammar at: #Ep) firstSet includes: '+' epsilon: true.
	self assert: (grammar at: #T) firstSet includes: '(i' epsilon: false.
	self assert: (grammar at: #Tp) firstSet includes: '*' epsilon: true.
	self assert: (grammar at: #F) firstSet includes: '(i' epsilon: false
]

{ #category : #'testing-firstset' }
PPAnalyzerTest >> testFirstSetGrammarC [
	| grammar |
	grammar := self grammarC.
	self assert: grammar firstSet includes: '1' epsilon: false
]

{ #category : #'testing-firstset' }
PPAnalyzerTest >> testFirstSetGrammarD [
	| grammar |
	grammar := self grammarD.
	self assert: (grammar at: #S) firstSet includes: 'ab' epsilon: false.
	self assert: (grammar at: #A) firstSet includes: 'ab' epsilon: false.
	self assert: (grammar at: #B) firstSet includes: 'a' epsilon: false.
	self assert: (grammar at: #a) firstSet includes: 'a' epsilon: false.
	self assert: (grammar at: #b) firstSet includes: 'b' epsilon: false
]

{ #category : #'testing-firstset' }
PPAnalyzerTest >> testFirstSetGrammarE [
	self assert: self grammarE firstSet includes: '' epsilon: false
]

{ #category : #'testing-firstset' }
PPAnalyzerTest >> testFirstSetLambda [
	| grammar |
	grammar := PPLambdaParser new.
	self assert: grammar start firstSet includes: '(ABCDEFGHIJKLMNOPQRSTUVWXYZ\abcdefghijklmnopqrstuvwxyz' epsilon: false.
	self assert: grammar abstraction firstSet includes: '\' epsilon: false.
	self assert: grammar application firstSet includes: '(' epsilon: false.
	self assert: grammar expression firstSet includes: '(ABCDEFGHIJKLMNOPQRSTUVWXYZ\abcdefghijklmnopqrstuvwxyz' epsilon: false.
	self assert: grammar variable firstSet includes: 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' epsilon: false
]

{ #category : #'testing-followset' }
PPAnalyzerTest >> testFollowSetExampleA [
	| grammar followSets |
	grammar := self grammarA.
	followSets := (grammar at: #S) followSets.
	self assert: (followSets at: (grammar at: #a)) includes: 'bc' epsilon: false.
	self assert: (followSets at: (grammar at: #b)) includes: 'bc' epsilon: false.
	self assert: (followSets at: (grammar at: #c)) includes: 'd' epsilon: false.
	self assert: (followSets at: (grammar at: #d)) includes: '' epsilon: true.
	self assert: (followSets at: (grammar at: #e)) includes: 'bc' epsilon: false.
	self assert: (followSets at: (grammar at: #S)) includes: '' epsilon: true.
	self assert: (followSets at: (grammar at: #A)) includes: 'bc' epsilon: false.
	self assert: (followSets at: (grammar at: #B)) includes: 'bc' epsilon: false
]

{ #category : #'testing-followset' }
PPAnalyzerTest >> testFollowSetExampleB [
	| grammar followSets |
	grammar := self grammarB.
	followSets := (grammar at: #E) followSets.
	self assert: (followSets at: (grammar at: #E)) includes: ')' epsilon: true.
	self assert: (followSets at: (grammar at: #Ep)) includes: ')' epsilon: true.
	self assert: (followSets at: (grammar at: #T)) includes: ')+' epsilon: true.
	self assert: (followSets at: (grammar at: #Tp)) includes: ')+' epsilon: true.
	self assert: (followSets at: (grammar at: #F)) includes: ')*+' epsilon: true
]

{ #category : #'testing-followset' }
PPAnalyzerTest >> testFollowSetExampleC [
	self assert: self grammarC followSet includes: '+' epsilon: true
]

{ #category : #'testing-followset' }
PPAnalyzerTest >> testFollowSetExampleD [
	| grammar followSets |
	grammar := self grammarD.
	followSets := (grammar at: #S) followSets.
	self assert: (followSets at: (grammar at: #S)) includes: 'a' epsilon: true.
	self assert: (followSets at: (grammar at: #A)) includes: 'ab' epsilon: true.
	self assert: (followSets at: (grammar at: #B)) includes: 'ab' epsilon: true.
	self assert: (followSets at: (grammar at: #a)) includes: 'ab' epsilon: true.
	self assert: (followSets at: (grammar at: #b)) includes: 'ab' epsilon: true
]

{ #category : #'testing-followset' }
PPAnalyzerTest >> testFollowSetExampleE [
	self assert: self grammarE followSet includes: '' epsilon: true
]

{ #category : #testing }
PPAnalyzerTest >> testIsLeaf [
	self assert: PPEpsilonParser new isLeaf.
	self assert: PPFailingParser new isLeaf.
	self assert: PPPluggableParser new isLeaf.
	self assert: PPLiteralSequenceParser new isLeaf.
	self assert: PPLiteralObjectParser new isLeaf.
	self assert: PPPredicateParser new isLeaf.
	
	self deny: ($a asParser / $b asParser) isLeaf.
	self deny: ($a asParser , $b asParser) isLeaf.
	self deny: ($a asParser and) isLeaf.
	self deny: ($a asParser not) isLeaf
]

{ #category : #testing }
PPAnalyzerTest >> testIsNullable [
	self assert: $a asParser star isNullable.
	self assert: nil asParser isNullable.

	self deny: $a asParser plus isNullable.	
	self deny: PPLiteralSequenceParser new isNullable.
	self deny: PPLiteralObjectParser new isNullable.
	self deny: PPPredicateParser new isNullable.
	self deny: PPChoiceParser new isNullable.
	self deny: PPSequenceParser new isNullable.
	self deny: PPAndParser new isNullable.
	self deny: PPTokenParser new isNullable
]
