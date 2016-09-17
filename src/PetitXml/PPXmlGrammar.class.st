Class {
	#name : #PPXmlGrammar,
	#superclass : #PPCompositeParserBridge,
	#instVars : [
		'comment',
		'whitespace',
		'processing',
		'nameStartChar',
		'nameChar',
		'nameToken',
		'misc',
		'document',
		'element',
		'attributes',
		'content',
		'characterData',
		'attribute',
		'doctype',
		'attributeValue',
		'qualified'
	],
	#category : #'PetitXml-Core'
}

{ #category : #grammar }
PPXmlGrammar >> attribute [
	"[41] 	Attribute	   ::=   	 Name Eq AttValue"

	^ qualified , whitespace optional , $= asParser2 , whitespace optional , attributeValue
		==> [ :nodes | Array with: nodes first with: nodes fifth ]
]

{ #category : #grammar }
PPXmlGrammar >> attributeValue [
	"[10]   	AttValue	   ::=   	'""' ([^<&""] | Reference)* '""' |  ""'"" ([^<&'] | Reference)* "

	^ ($" asParser2 , $" asParser2 negate star flatten , $" asParser2) 
	/ ($' asParser2 , $' asParser2 negate star flatten , $' asParser2) 
		==> #second
]

{ #category : #grammar }
PPXmlGrammar >> attributes [
	"[40]   	STag	   ::=   	'<' Name (S Attribute)* S? '>'	"

	^ ((whitespace , attribute) ==> #second) star
]

{ #category : #'grammar-character' }
PPXmlGrammar >> characterData [
	"[14]   	CharData	   ::=   	[^<&]* - ([^<&]* ']]>' [^<&]*)"
	
	^ $< asParser2 negate plus flatten
]

{ #category : #grammar }
PPXmlGrammar >> comment [
	"[15]   	Comment	   ::=   	'<!--' ((Char - '-') | ('-' (Char - '-')))* '-->'"

	^ '<!--' asParser2 ,  '-->' asParser2 negate star flatten , '-->' asParser2 ==> #second
]

{ #category : #grammar }
PPXmlGrammar >> content [
	"[43]   	content	   ::=   	 CharData? ((element | Reference | CDSect | PI | Comment) CharData?)*"
				
	^ (characterData / element / processing / comment) star
]

{ #category : #grammar }
PPXmlGrammar >> doctype [
	"[28]   	doctypedecl	   ::=   	'<!DOCTYPE' S Name (S ExternalID)? S? ('[' intSubset ']' S?)? '>'"

	^ '<!DOCTYPE' asParser2 , whitespace optional , ($[ asParser2 negate star , $[ asParser2 , $] asParser2 negate star , $] asParser2) flatten , whitespace optional , $> asParser2 ==> #third
]

{ #category : #grammar }
PPXmlGrammar >> document [
	"[1]   	document	   ::=   	 prolog element Misc*"
	"[22]   	prolog	   ::=   	 XMLDecl? Misc* (doctypedecl Misc*)?"

	^ processing optional , misc , doctype optional , misc , element , misc
		==> [ :nodes | Array with: nodes first with: nodes third with: nodes fifth ]
]

{ #category : #grammar }
PPXmlGrammar >> element [
	"[39]   	element	   ::=   	 EmptyElemTag | STag content ETag"
	
	^ $< asParser2 , qualified , attributes , whitespace optional , ('/>' asParser2 / ($> asParser2 , content , [ :stream | stream position ] asParser2 , '</' asParser2 , qualified , whitespace optional , $> asParser2)) ==> [ :nodes | 
		nodes fifth = '/>'
			ifTrue: [ Array with: nodes second with: nodes third with: #() ]
			ifFalse: [
				nodes second = nodes fifth fifth
					ifTrue: [ Array with: nodes second with: nodes third with: nodes fifth second ]
					ifFalse: [ PP2Failure message: 'Expected </' , nodes second qualifiedName , '>' context: nil at: nodes fifth third ] ] ]
]

{ #category : #'grammar-character' }
PPXmlGrammar >> misc [
	"[27]   	Misc	   ::=   	 Comment | PI | S"

	^ (whitespace / comment / processing) star
]

{ #category : #'token-characters' }
PPXmlGrammar >> nameChar [
	"[4a]   	NameChar	   ::=   	 NameStartChar | ""-"" | ""."" | [0-9] | #xB7 | [#x0300-#x036F] | [#x203F-#x2040]"

	^ PP2PredicateObjectNode new
		predicate: (PP2CharSetPredicate on: [ :char | 
			char = $- or: [ 
			char = $. or: [ 
			char = $: or: [ 
			char = $_ or: [ 
			char isAlphaNumeric ] ] ] ] ]);
		predicateMessage: 'name expected'
]

{ #category : #'token-characters' }
PPXmlGrammar >> nameStartChar [
	"[4]   	NameStartChar	   ::=   	"":"" | [A-Z] | ""_"" | [a-z] | [#xC0-#xD6] | [#xD8-#xF6] | [#xF8-#x2FF] | [#x370-#x37D] | [#x37F-#x1FFF] | [#x200C-#x200D] | [#x2070-#x218F] | [#x2C00-#x2FEF] | [#x3001-#xD7FF] | [#xF900-#xFDCF] | [#xFDF0-#xFFFD] | [#x10000-#xEFFFF]"

	^ PP2PredicateObjectNode new
		predicate: (PP2CharSetPredicate on: [ :char | 
			char = $: or: [ 
			char = $_ or: [ 
			char isLetter ] ] ]); 
		predicateMessage: 'name expected'
]

{ #category : #token }
PPXmlGrammar >> nameToken [
	"[5]   	Name	   ::=   	NameStartChar (NameChar)*"

	^ (nameStartChar , nameChar star) flatten
]

{ #category : #grammar }
PPXmlGrammar >> processing [
	"[16]   	PI	   ::=   	'<?' PITarget (S (Char* - (Char* '?>' Char*)))? '?>'
	[17]   	PITarget	   ::=   	 Name - (('X' | 'x') ('M' | 'm') ('L' | 'l'))"

	^ '<?' asParser2 , nameToken , (whitespace , '?>' asParser2 negate star) optional flatten, '?>' asParser2
		==> [ :nodes | Array with: nodes second with: nodes third ]
]

{ #category : #grammar }
PPXmlGrammar >> qualified [
	^ nameToken
]

{ #category : #accessing }
PPXmlGrammar >> start [
	^ document end
]

{ #category : #'grammar-character' }
PPXmlGrammar >> whitespace [
	"[3]   	S	   ::=   	(#x20 | #x9 | #xD | #xA)+"

	^ #space asParser2 plus
]
