Class {
	#name : #PPFirstFollowTest,
	#superclass : #PPAbstractParseTest,
	#category : #'PetitParser-Tests'
}

{ #category : #utilities }
PPFirstFollowTest >> assert: aCollection includes: aString epsilon: aBoolean [
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
PPFirstFollowTest >> grammarA [
	"Güting, Erwig, Übersetzerbau, Springer (p.63)"

	| grammar |
	grammar := Dictionary new.
	
	" terminals "
	grammar at: #a put: $a asParser.
	grammar at: #b put: $b asParser.
	grammar at: #c put: $c asParser.
	grammar at: #d put: $d asParser.
	grammar at: #e put: PPEpsilonParser new.
	
	" non terminals "
	grammar at: #B put: (grammar at: #b) / (grammar at: #e).
	grammar at: #A put: (grammar at: #a) / (grammar at: #B).
	grammar at: #S put: (grammar at: #A) , (grammar at: #B) , (grammar at: #c) , (grammar at: #d).
	
	^ grammar	
]

{ #category : #accessing }
PPFirstFollowTest >> grammarB [
	"The canonical grammar to exercise first- and follow-set calculation, probably originally from the dragon-book."

	| grammar |
	grammar := Dictionary new.
	#(E Ep T Tp F) 		do: [ :each | grammar at: each put: PPUnresolvedParser new ].
		
	(grammar at: #E)		def: (grammar at: #T) , (grammar at: #Ep).
	(grammar at: #Ep)	def: ($+ asParser , (grammar at: #T) , (grammar at: #Ep)) optional.
	
	(grammar at: #T)		def: (grammar at: #F) , (grammar at: #Tp).
	(grammar at: #Tp)	def: ($* asParser , (grammar at: #F) , (grammar at: #Tp)) optional.
	
	(grammar at: #F)		def: ($( asParser , (grammar at: #E) , $) asParser) / $i asParser.
			
	#(E Ep T Tp F) 		do: [ :each | (grammar at: each) name: each ].
	
	^ grammar
]

{ #category : #accessing }
PPFirstFollowTest >> grammarC [
	"A highly recrusive grammar."

	| grammar |
	grammar := PPUnresolvedParser new.
	grammar def: (grammar , $+ asParser , grammar) / $1 asParser.
	^ grammar
]

{ #category : #'testing-firstset' }
PPFirstFollowTest >> testFirstSetExampleA [
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
PPFirstFollowTest >> testFirstSetExampleB [
	| grammar |
	grammar := self grammarB.
	self assert: (grammar at: #E) firstSet includes: '(i' epsilon: false.
	self assert: (grammar at: #Ep) firstSet includes: '+' epsilon: true.
	self assert: (grammar at: #T) firstSet includes: '(i' epsilon: false.
	self assert: (grammar at: #Tp) firstSet includes: '*' epsilon: true.
	self assert: (grammar at: #F) firstSet includes: '(i' epsilon: false
]

{ #category : #'testing-firstset' }
PPFirstFollowTest >> testFirstSetExampleC [
	| grammar |
	grammar := self grammarC.
	self assert: grammar firstSet includes: '1' epsilon: false
]

{ #category : #'testing-firstset' }
PPFirstFollowTest >> testFirstSetExpression [
	| grammar |
	grammar := PPExpressionParser new.
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
PPFirstFollowTest >> testFirstSetLambda [
	| grammar |
	grammar := PPLambdaParser new.
	self assert: grammar start firstSet includes: '(ABCDEFGHIJKLMNOPQRSTUVWXYZ\abcdefghijklmnopqrstuvwxyz' epsilon: false.
	self assert: grammar abstraction firstSet includes: '\' epsilon: false.
	self assert: grammar application firstSet includes: '(' epsilon: false.
	self assert: grammar expression firstSet includes: '(ABCDEFGHIJKLMNOPQRSTUVWXYZ\abcdefghijklmnopqrstuvwxyz' epsilon: false.
	self assert: grammar variable firstSet includes: 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' epsilon: false
]

{ #category : #'testing-followset' }
PPFirstFollowTest >> testFollowSetExampleA [
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
PPFirstFollowTest >> testFollowSetExampleB [
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
PPFirstFollowTest >> testFollowSetExampleC [
	self assert: self grammarC followSet includes: '+' epsilon: true
]

{ #category : #testing }
PPFirstFollowTest >> testIsNullable [
	self assert: $a asParser star isNullable.
	self assert: PPEpsilonParser new isNullable.

	self deny: $a asParser plus isNullable.	
	self deny: PPLiteralSequenceParser new isNullable.
	self deny: PPPredicateParser new isNullable.
	self deny: PPChoiceParser new isNullable.
	self deny: PPSequenceParser new isNullable.
	self deny: PPAndParser new isNullable.
	self deny: PPTokenParser new isNullable
]

{ #category : #testing }
PPFirstFollowTest >> testIsTerminal [
	self assert: PPEpsilonParser new isTerminal.
	self assert: PPFailingParser new isTerminal.
	self assert: PPPluggableParser new isTerminal.
	self assert: PPPredicateParser new isTerminal.
	self assert: PPLiteralObjectParser new isTerminal.
	self assert: PPLiteralSequenceParser new isTerminal.
	
	self deny: PPChoiceParser new isTerminal.
	self deny: PPSequenceParser new isTerminal.
	self deny: PPAndParser new isTerminal.
	self deny: PPTokenParser new isTerminal
]
