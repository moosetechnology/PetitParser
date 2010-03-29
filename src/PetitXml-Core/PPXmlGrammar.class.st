Class {
	#name : #PPXmlGrammar,
	#superclass : #PPCompositeParser,
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
		'qualified',
		'elementEmpty',
		'elementContent'
	],
	#category : #'PetitXml-Core'
}

{ #category : #grammar }
PPXmlGrammar >> attribute [
	"[41] 	Attribute	   ::=   	 Name Eq AttValue"

	^ qualified , whitespace optional , $= asParser , whitespace optional , attributeValue
		==> [ :nodes | Array with: nodes first with: nodes fifth ]
]

{ #category : #grammar }
PPXmlGrammar >> attributeValue [
	"[10]   	AttValue	   ::=   	'""' ([^<&""] | Reference)* '""' |  ""'"" ([^<&'] | Reference)* "

	^ ($" asParser , $" asParser negate star flatten , $" asParser) 
	/ ($' asParser , $' asParser negate star flatten , $' asParser) 
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
	
	^ $< asParser negate plus flatten ==> [ :nodes | PPXmlText data: nodes ]
]

{ #category : #grammar }
PPXmlGrammar >> comment [
	"[15]   	Comment	   ::=   	'<!--' ((Char - '-') | ('-' (Char - '-')))* '-->'"

	^ '<!--' asParser ,  '-->' asParser negate star flatten , '-->' asParser ==> #second
]

{ #category : #grammar }
PPXmlGrammar >> content [
	"[43]   	content	   ::=   	 CharData? ((element | Reference | CDSect | PI | Comment) CharData?)*"
				
	^ characterData optional , ((element / processing / comment) , characterData optional) star ==> [ :nodes |
		| result |
		result := OrderedCollection new.
		nodes first isNil
			ifFalse: [ result addLast: nodes first ].
		nodes second do:  [ :each |
			result addLast: each first.
			each second isNil
				ifFalse: [ result addLast: each second ] ].
		result asArray ]
]

{ #category : #grammar }
PPXmlGrammar >> doctype [
	"[28]   	doctypedecl	   ::=   	'<!DOCTYPE' S Name (S ExternalID)? S? ('[' intSubset ']' S?)? '>'"

	^ $[ asParser negate star , ($[ asParser , $] asParser negate star , $] asParser) flatten , whitespace optional , $> asParser ==> #second
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
	
	^ elementEmpty / elementContent
]

{ #category : #grammar }
PPXmlGrammar >> elementContent [
	^ $< asParser , qualified , attributes , whitespace optional , $> asParser , content , [ :stream | stream position ] asParser , '</' asParser , qualified , whitespace optional , $> asParser ==> [ :nodes |
		nodes second = nodes ninth
			ifTrue: [ Array with: nodes second with: nodes third with: nodes sixth ]
			ifFalse: [ PPFailure reason: 'Expected </' , nodes second qualifiedName , '> but got </' , nodes ninth qualifiedName , '>' at: nodes seventh ] ]
]

{ #category : #grammar }
PPXmlGrammar >> elementEmpty [
	^ $< asParser , qualified , attributes , whitespace optional , '/>' asParser
		==> [ :nodes | Array with: nodes second with: nodes third with: #() ]
]

{ #category : #'grammar-character' }
PPXmlGrammar >> misc [
	"[27]   	Misc	   ::=   	 Comment | PI | S"

	^ (whitespace / comment / processing) star
]

{ #category : #'token-characters' }
PPXmlGrammar >> nameChar [
	"[4a]   	NameChar	   ::=   	 NameStartChar | ""-"" | ""."" | [0-9] | #xB7 | [#x0300-#x036F] | [#x203F-#x2040]"

	^ PPPredicateParser on: [ :char | char = $- or: [ char = $. or: [ char = $: or: [ char = $_ or: [ char isAlphaNumeric ] ] ] ] ] message: 'name expected'
]

{ #category : #'token-characters' }
PPXmlGrammar >> nameStartChar [
	"[4]   	NameStartChar	   ::=   	"":"" | [A-Z] | ""_"" | [a-z] | [#xC0-#xD6] | [#xD8-#xF6] | [#xF8-#x2FF] | [#x370-#x37D] | [#x37F-#x1FFF] | [#x200C-#x200D] | [#x2070-#x218F] | [#x2C00-#x2FEF] | [#x3001-#xD7FF] | [#xF900-#xFDCF] | [#xFDF0-#xFFFD] | [#x10000-#xEFFFF]"

	^ PPPredicateParser on: [ :char | char = $: or: [ char = $_ or: [ char isLetter ] ] ] message: 'name expected'
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

	^ '<?' asParser , nameToken , (whitespace , '?>' asParser negate star token) optional flatten, '?>' asParser
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

	^ #space asParser plus
]
