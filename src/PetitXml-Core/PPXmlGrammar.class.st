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
		'nmToken',
		'misc',
		'document',
		'prolog',
		'element',
		'attributes',
		'content',
		'characterData',
		'attribute'
	],
	#category : #'PetitXml-Core'
}

{ #category : #grammar }
PPXmlGrammar >> attribute [
	"[41] 	Attribute	   ::=   	 Name Eq AttValue"

	^ self parserForAttribute: nameToken value: $" asParser negate star token
]

{ #category : #grammar }
PPXmlGrammar >> attributes [
	"[40]   	STag	   ::=   	'<' Name (S Attribute)* S? '>'	"

	^ ((whitespace , attribute) ==> #second) star
]

{ #category : #'grammar-character' }
PPXmlGrammar >> characterData [
	"[14]   	CharData	   ::=   	[^<&]* - ([^<&]* ']]>' [^<&]*)"
	
	^ $< asParser negate plus token
]

{ #category : #'grammar-misc' }
PPXmlGrammar >> comment [
	"[15]   	Comment	   ::=   	'<!--' ((Char - '-') | ('-' (Char - '-')))* '-->'"

	^ '<!--' asParser ,  ('-->' asParser not , #any asParser) star , '-->' asParser
]

{ #category : #grammar }
PPXmlGrammar >> content [
	"[43]   	content	   ::=   	 CharData? ((element | Reference | CDSect | PI | Comment) CharData?)*"
				
	^ characterData optional , ((element / processing / comment) , characterData optional) star
]

{ #category : #grammar }
PPXmlGrammar >> document [
	"[1]   	document	   ::=   	 prolog element Misc*"

	^ self parserForDocument: prolog element: element
]

{ #category : #grammar }
PPXmlGrammar >> element [
	"[39]   	element	   ::=   	 EmptyElemTag | STag content ETag"
				
	^ (self parserForTag: nameToken attributes: attributes) / (self parserForTag: nameToken attributes: attributes content: content)
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

{ #category : #token }
PPXmlGrammar >> nameTokens [
	"[6]   	Names	   ::=   	Name (#x20 Name)*"

	^ (nameToken separatedBy: $ asParser) flatten
]

{ #category : #token }
PPXmlGrammar >> nmToken [
	"[7]   	Nmtoken	   ::=   	(NameChar)+"

	^ nameChar plus flatten
]

{ #category : #token }
PPXmlGrammar >> nmTokens [
	"[8]   	Nmtokens	   ::=   	Nmtoken (#x20 Nmtoken)*"

	^ (nmToken separatedBy: $ asParser) flatten
]

{ #category : #parsers }
PPXmlGrammar >> parserForAttribute: aNameParser value: aValueParser [
	"Answer a parser that can read an XML attribute."

	^ aNameParser asParser token , whitespace optional , $= asParser , whitespace optional , $" asParser , aValueParser asParser , $" asParser
		==> [ :nodes | Array with: nodes first with: nodes sixth ]
]

{ #category : #parsers }
PPXmlGrammar >> parserForDocument: aPrologParser element: anElementParser [
	"Answer a parser that can read an XML document."

	^ aPrologParser asParser , anElementParser asParser , misc
		==> [ :nodes | Array with: nodes first with: nodes second ]
]

{ #category : #parsers }
PPXmlGrammar >> parserForProcessingInstruction: aTargetParser [
	"Answer a parser that can read an XML processing instruction."
	
	^ '<?' asParser , aTargetParser asParser token , (whitespace , ('?>' asParser not , #any asParser) star token) optional , '?>' asParser
		==> [ :nodes | Array with: nodes second with: (nodes third ifNotNil: [ :inner | inner second ]) ]
]

{ #category : #parsers }
PPXmlGrammar >> parserForTag: aNameParser attributes: anAttributeParser [
	"Answer a parser that can read empty XML tags."

	^ self parserForTag: aNameParser attributes: anAttributeParser content: nil
]

{ #category : #parsers }
PPXmlGrammar >> parserForTag: aNameParser attributes: anAttributeParser content: aContentParser [
	"Answer a parser that can read the XML tags."

	^ aContentParser isNil
		ifTrue: [
			$< asParser , aNameParser asParser token , anAttributeParser asParser , whitespace optional , '/>' asParser 
				==> [ :nodes | Array with: nodes second with: nodes third with: nil ] ]
		ifFalse: [
			$< asParser , aNameParser asParser token , anAttributeParser asParser , whitespace optional , $> asParser , aContentParser asParser , 
			[ :stream | stream position ] asParser , '</' asParser , aNameParser asParser token , whitespace optional , $> asParser
				==> [ :nodes |
					nodes second = nodes ninth
						ifTrue: [ Array with: nodes second with: nodes third with: nodes sixth ]
						ifFalse: [ PPFailure reason: 'Expected </' , nodes second value , '> but got </' , nodes ninth value , '>' at: nodes seventh ] ] ]
]

{ #category : #'grammar-misc' }
PPXmlGrammar >> processing [
	"[16]   	PI	   ::=   	'<?' PITarget (S (Char* - (Char* '?>' Char*)))? '?>'
	[17]   	PITarget	   ::=   	 Name - (('X' | 'x') ('M' | 'm') ('L' | 'l'))"

	^ self parserForProcessingInstruction: #letter asParser plus
]

{ #category : #grammar }
PPXmlGrammar >> prolog [
	"[22]   	prolog	   ::=   	 XMLDecl? Misc* (doctypedecl Misc*)?"
				
	^ (self parserForProcessingInstruction: 'xml') optional , misc
		==> [ :nodes | nodes first ]
]

{ #category : #accessing }
PPXmlGrammar >> start [
	^ document end
]

{ #category : #accessing }
PPXmlGrammar >> tokenParser [
	^ PPXmlTokenParser
]

{ #category : #'grammar-misc' }
PPXmlGrammar >> whitespace [
	"[3]   	S	   ::=   	(#x20 | #x9 | #xD | #xA)+"

	^ #space asParser plus
]
