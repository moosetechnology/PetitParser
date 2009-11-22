Class {
	#name : #PPComposedTest,
	#superclass : #PPAbstractParseTest,
	#category : #'PetitParser-Tests'
}

{ #category : #testing }
PPComposedTest >> testDoubledString [
	| parser |
	parser := ($' asParser , (($' asParser , $' asParser) / $' asParser negate) star flatten , $' asParser) 
		==> [ :nodes | nodes second copyReplaceAll: '''''' with: '''' ].

	self assert: parser parse: '''''' to: ''.
	self assert: parser parse: '''a''' to: 'a'.
	self assert: parser parse: '''ab''' to: 'ab'.
	self assert: parser parse: '''a''''b''' to: 'a''b'.
	self assert: parser parse: '''a''''''''b''' to: 'a''''b'
]

{ #category : #testing }
PPComposedTest >> testIfThenElse [
	"S ::= if C then S else S | if C then S | X"
	
	| start if then else cond expr parser |
	start := PPUnresolvedParser new.
	if := 'if' asParser token.
	then := 'then' asParser token.
	else := 'else' asParser token.
	cond := 'C' asParser token.
	expr := 'X' asParser token.
	start def: (if , cond , then , start , else , start)
		/ (if , cond , then , start)
		/ (expr).
	parser := start end.
	
	self assert: parser parse: 'X'.
	self assert: parser parse: 'if C then X'.
	self assert: parser parse: 'if C then X else X'.
	
	self assert: parser parse: 'if C then if C then X'.
	self assert: parser parse: 'if C then if C then X else if C then X'.
	self assert: parser parse: 'if C then if C then X else X else if C then X'.
	self assert: parser parse: 'if C then if C then X else X else if C then X else X'.
	
	self assert: parser fail: 'if C'.
	self assert: parser fail: 'if C else X'.
	self assert: parser fail: 'if C then if C'
]

{ #category : #testing }
PPComposedTest >> testLeftRecursion [
	"S ::= S 'x' S / '1'"
	
	| parser |
	parser := PPUnresolvedParser new.
	parser def: ((parser , $x asParser , parser) / $1 asParser) memoized flatten.

	self assert: parser parse: '1' to: '1'.
	self assert: parser parse: '1x1' to: '1x1'.
	self assert: parser parse: '1x1x1' to: '1x1x1'.
	self assert: parser parse: '1x1x1x1' to: '1x1x1x1'.
	self assert: parser parse: '1x1x1x1x1' to: '1x1x1x1x1'.
	self assert: parser parse: '1x1x1x1x1x1' to: '1x1x1x1x1x1'
]

{ #category : #testing }
PPComposedTest >> testListOfIntegers [
	"S ::= S , number | number"
	
	| number list parser |
	number := #digit asParser plus token 
		==> [ :node | node value asInteger ].
	list := (number separatedBy: $, asParser token)
		==> [ :node | node select: [ :each | each isInteger ] ].
	parser := list end.

	self assert: parser parse: '1' to: (1 to: 1) asArray.
	self assert: parser parse: '1,2' to: (1 to: 2) asArray.
	self assert: parser parse: '1,2,3' to: (1 to: 3) asArray.
	self assert: parser parse: '1,2,3,4' to: (1 to: 4) asArray.
	self assert: parser parse: '1,2,3,4,5' to: (1 to: 5) asArray.

	self assert: parser parse: '1' to: (1 to: 1) asArray.
	self assert: parser parse: '1, 2' to: (1 to: 2) asArray.
	self assert: parser parse: '1, 2, 3' to: (1 to: 3) asArray.
	self assert: parser parse: '1, 2, 3, 4' to: (1 to: 4) asArray.
	self assert: parser parse: '1, 2, 3, 4, 5' to: (1 to: 5) asArray.

	self assert: parser parse: '1' to: (1 to: 1) asArray.
	self assert: parser parse: '1 ,2' to: (1 to: 2) asArray.
	self assert: parser parse: '1 ,2 ,3' to: (1 to: 3) asArray.
	self assert: parser parse: '1 ,2 ,3 ,4' to: (1 to: 4) asArray.
	self assert: parser parse: '1 ,2 ,3 ,4 ,5' to: (1 to: 5) asArray.
	
	self assert: parser fail: ''.
	self assert: parser fail: ','.
	self assert: parser fail: '1,'.
	self assert: parser fail: '1,,2'
]

{ #category : #testing }
PPComposedTest >> testNestedComments [
	"C ::= B I* E"
	"I ::= !E (C | T)"
	"B ::= /*"
	"E ::= */"
	"T ::= ."
	
	| begin end any inside parser |
	begin := '/*' asParser.
	end := '*/' asParser.
	any := #any asParser.
	
	parser := PPUnresolvedParser new.
	inside := end not , (parser / any).
	parser def: begin , inside star , end.
	
	self assert: parser parse: '/*ab*/cd' end: 6.
	self assert: parser parse: '/*a/*b*/c*/'.
	self assert: parser fail: '/*a/*b*/c'
]

{ #category : #testing }
PPComposedTest >> testPalindrome [
	"S0 ::= a S1 a | b S1 b | ...
	 S1 ::= S0 | epsilon"
	
	| s0 s1 parser |
	s0 := PPUnresolvedParser new.
	s1 := PPUnresolvedParser new.
	s0 def: ($a asParser , s1 , $a asParser)
		/ ($b asParser , s1 , $b asParser)
		/ ($c asParser , s1 , $c asParser).	
	s1 def: s0 / nil asParser.
	parser := s0 flatten end.

	self assert: parser parse: 'aa' to: 'aa'.
	self assert: parser parse: 'bb' to: 'bb'.
	self assert: parser parse: 'cc' to: 'cc'.
	
	self assert: parser parse: 'abba' to: 'abba'.
	self assert: parser parse: 'baab' to: 'baab'.

	self assert: parser parse: 'abccba' to: 'abccba'.
	self assert: parser parse: 'abaaba' to: 'abaaba'.
	self assert: parser parse: 'cbaabc' to: 'cbaabc'.

	self assert: parser fail: 'a'.
	self assert: parser fail: 'ab'.
	self assert: parser fail: 'aab'.
	self assert: parser fail: 'abccbb'
]

{ #category : #testing }
PPComposedTest >> testParseAaaBbb [
	"S0 ::= a S1 b
	 S1 ::= S0 | epsilon"
	
	| s0 s1 parser |
	s0 := PPUnresolvedParser new.
	s1 := PPUnresolvedParser new.
	s0 def: $a asParser , s1 , $b asParser.
	s1 def: s0 / nil asParser.
	parser := s0 flatten.

	self assert: parser parse: 'ab' to: 'ab'.
	self assert: parser parse: 'aabb' to: 'aabb'.
	self assert: parser parse: 'aaabbb' to: 'aaabbb'.
	self assert: parser parse: 'aaaabbbb' to: 'aaaabbbb'.

	self assert: parser parse: 'abb' to: 'ab' end: 2.
	self assert: parser parse: 'aabbb' to: 'aabb' end: 4.
	self assert: parser parse: 'aaabbbb' to: 'aaabbb' end: 6.
	self assert: parser parse: 'aaaabbbbb' to: 'aaaabbbb' end: 8.

	self assert: parser fail: 'a'.
	self assert: parser fail: 'b'.
	self assert: parser fail: 'aab'.
	self assert: parser fail: 'aaabb'
]

{ #category : #testing }
PPComposedTest >> testParseAaaaaa [
	"S ::= a a S | epsilon"
	
	| s0 s1 parser |
	s0 := PPUnresolvedParser new.
	s1 := $a asParser , $a asParser , s0.
	s0 def: s1 / nil asParser.
	parser := s0 flatten.

	self assert: parser parse: '' to: ''.
	self assert: parser parse: 'aa' to: 'aa'.
	self assert: parser parse: 'aaaa' to: 'aaaa'.
	self assert: parser parse: 'aaaaaa' to: 'aaaaaa'.

	self assert: parser parse: 'a' to: '' end: 0.
	self assert: parser parse: 'aaa' to: 'aa' end: 2.
	self assert: parser parse: 'aaaaa' to: 'aaaa' end: 4.
	self assert: parser parse: 'aaaaaaa' to: 'aaaaaa' end: 6
]

{ #category : #testing }
PPComposedTest >> testParseAbAbAb [
	"S ::= (A B)+"
	
	| parser |
	parser := ($a asParser , $b asParser) plus flatten.

	self assert: parser parse: 'ab' to: 'ab'.
	self assert: parser parse: 'abab' to: 'abab'.
	self assert: parser parse: 'ababab' to: 'ababab'.
	self assert: parser parse: 'abababab' to: 'abababab'.

	self assert: parser parse: 'abb' to: 'ab' end: 2.
	self assert: parser parse: 'ababa' to: 'abab' end: 4.
	self assert: parser parse: 'abababb' to: 'ababab' end: 6.
	self assert: parser parse: 'ababababa' to: 'abababab' end: 8.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'a'.
	self assert: parser fail: 'bab'
]

{ #category : #testing }
PPComposedTest >> testParseAbabbb [
	"S ::= (A | B)+"

	| parser |
	parser := ($a asParser / $b asParser) plus flatten.

	self assert: parser parse: 'a' to: 'a'.
	self assert: parser parse: 'b' to: 'b'.
	self assert: parser parse: 'ab' to: 'ab'.
	self assert: parser parse: 'ba' to: 'ba'.
	self assert: parser parse: 'aaa' to: 'aaa'.
	self assert: parser parse: 'aab' to: 'aab'.
	self assert: parser parse: 'aba' to: 'aba'.
	self assert: parser parse: 'baa' to: 'baa'.
	self assert: parser parse: 'abb' to: 'abb'.
	self assert: parser parse: 'bab' to: 'bab'.
	self assert: parser parse: 'bba' to: 'bba'.
	self assert: parser parse: 'bbb' to: 'bbb'.

	self assert: parser parse: 'ac' to: 'a' end: 1.
	self assert: parser parse: 'bc' to: 'b' end: 1.
	self assert: parser parse: 'abc' to: 'ab' end: 2.
	self assert: parser parse: 'bac' to: 'ba' end: 2.
	
	self assert: parser fail: ''.
	self assert: parser fail: 'c'
]
