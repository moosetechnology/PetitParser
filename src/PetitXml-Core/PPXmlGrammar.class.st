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
		'element',
		'attributes',
		'content',
		'characterData',
		'attribute',
		'doctype',
		'attributeValue'
	],
	#category : #'PetitXml-Core'
}

{ #category : #grammar }
PPXmlGrammar >> attribute [
	"[41] 	Attribute	   ::=   	 Name Eq AttValue"

	^ self parserForAttribute: nameToken value: attributeValue
]

{ #category : #grammar }
PPXmlGrammar >> attributeValue [
	^ $" asParser negate star flatten
]

{ #category : #grammar }
PPXmlGrammar >> attributes [
	"[40]   	STag	   ::=   	'<' Name (S Attribute)* S? '>'	"

	^ ((whitespace , attribute) ==> #second) star ==> [ :nodes | 
		nodes 
			inject: PPXmlAttributes new
			into: [ :dict :each | dict add: each; yourself ] ]
]

{ #category : #'grammar-character' }
PPXmlGrammar >> characterData [
	"[14]   	CharData	   ::=   	[^<&]* - ([^<&]* ']]>' [^<&]*)"
	
	^ $< asParser negate plus flatten ==> [ :nodes | PPXmlText data: nodes ]
]

{ #category : #'grammar-misc' }
PPXmlGrammar >> comment [
	"[15]   	Comment	   ::=   	'<!--' ((Char - '-') | ('-' (Char - '-')))* '-->'"

	^ '<!--' asParser ,  ('-->' asParser not , #any asParser) star flatten , '-->' asParser
		==> [ :nodes | PPXmlComment data: nodes second ]
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
		result ]
]

{ #category : #'grammar-misc' }
PPXmlGrammar >> doctype [
	"[28]   	doctypedecl	   ::=   	'<!DOCTYPE' S Name (S ExternalID)? S? ('[' intSubset ']' S?)? '>'"

	^ '<!DOCTYPE' asParser ,  ($[ asParser not , #any asParser) star , $[ asParser , ($] asParser not , #any asParser) star , $] asParser , whitespace optional , $> asParser
]

{ #category : #grammar }
PPXmlGrammar >> document [
	"[1]   	document	   ::=   	 prolog element Misc*"
	"[22]   	prolog	   ::=   	 XMLDecl? Misc* (doctypedecl Misc*)?"

	^ self parserForDocument: self parserForRootElement
]

{ #category : #grammar }
PPXmlGrammar >> element [
	"[39]   	element	   ::=   	 EmptyElemTag | STag content ETag"
	
	^ (self parserForTag: nameToken attributes: attributes) 
	/ (self parserForTag: nameToken attributes: attributes content: content)
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

	^ aNameParser asParser flatten , whitespace optional , $= asParser , whitespace optional , $" asParser , aValueParser asParser , $" asParser
		==> [ :nodes | nodes first -> nodes sixth ]
]

{ #category : #'parsers-tags' }
PPXmlGrammar >> parserForCloseTag: aNameParser [
	"Answer a parser that parses an XML element named aNameParser close-tag. This parser answers the name of the tag."

	^ '</' asParser , (PPXmlQualifiedParser local: aNameParser) , whitespace optional , $> asParser ==> #second
]

{ #category : #'parsers-tags' }
PPXmlGrammar >> parserForContentTag: aNameParser attributes: anAttributeParser content: aContentParser [
	"Answer a parser that parses an XML element named aNameParser with the attributes anAttributeParser (expected to answer a dictionary). This parser answers instances of PPXmlElement."

	^ (self parserForOpenTag: aNameParser attributes: anAttributeParser) , 
		(aContentParser asParser) , [ :stream | stream position ] asParser , 
		(self parserForCloseTag: aNameParser) ==> [ :nodes | 
			nodes first tag = nodes last
				ifTrue: [ nodes first setContents: nodes second ]
				ifFalse: [ PPFailure reason: 'Expected </' , nodes first tag , '> but got </' , nodes last , '>' at: nodes third ] ]
]

{ #category : #parsers }
PPXmlGrammar >> parserForDocument: anElementParser [
	"Answer a parser that can read an XML document."

	^ (self parserForProcessingInstruction: 'xml') , misc , (doctype flatten , misc) optional , anElementParser asParser , misc ==> [ :nodes |
		PPXmlDocument new
			setXmlDeclaration: nodes first;
			setDocumentType: (nodes third isNil
				ifFalse: [ nodes third first ]);
			setRootElement: nodes fourth;
			yourself ]
]

{ #category : #'parsers-tags' }
PPXmlGrammar >> parserForEmptyTag: aNameParser attributes: anAttributeParser [
	"Answer a parser that parses an XML element named aNameParser with the attributes anAttributeParser (expected to answer a dictionary). This parser answers instances of PPXmlElement."

	^ $< asParser , (PPXmlQualifiedParser local: aNameParser) , (anAttributeParser asParser) , whitespace optional , '/>' asParser
		==> [ :nodes | PPXmlElement tag: nodes second attributes: nodes third ]
]

{ #category : #'parsers-tags' }
PPXmlGrammar >> parserForOpenTag: aNameParser attributes: anAttributeParser [
	"Answer a parser that parses an XML element named aNameParser with the attributes anAttributeParser (expected to answer a dictionary). This parser answers instances of PPXmlElement."

	^ $< asParser , (PPXmlQualifiedParser local: aNameParser) , (anAttributeParser asParser) , whitespace optional , $> asParser
		==> [ :nodes | PPXmlElement tag: nodes second attributes: nodes third ]
]

{ #category : #parsers }
PPXmlGrammar >> parserForProcessingInstruction: aTargetParser [
	"Answer a parser that can read an XML processing instruction."
	
	^ '<?' asParser , aTargetParser asParser flatten , (whitespace , ('?>' asParser not , #any asParser) star token) optional flatten, '?>' asParser
		==> [ :nodes | PPXmlProcessing target: nodes second data: nodes third ]
]

{ #category : #parsers }
PPXmlGrammar >> parserForRootElement [
	^ element
]

{ #category : #'parsers-tags' }
PPXmlGrammar >> parserForTag: aNameParser attributes: anAttributeParser [
	"Answer a parser that reads an empty XML tag. This parser answers instances of PPXmlElement."

	^ self parserForTag: aNameParser attributes: anAttributeParser content: nil
]

{ #category : #'parsers-tags' }
PPXmlGrammar >> parserForTag: aNameParser attributes: anAttributeParser content: aContentParser [
	"Answer a parser that can read the XML tags."

	^ aContentParser isNil
		ifTrue: [ self parserForEmptyTag: aNameParser attributes: anAttributeParser ]
		ifFalse: [ self parserForContentTag: aNameParser attributes: anAttributeParser content: aContentParser ]
]

{ #category : #'grammar-misc' }
PPXmlGrammar >> processing [
	"[16]   	PI	   ::=   	'<?' PITarget (S (Char* - (Char* '?>' Char*)))? '?>'
	[17]   	PITarget	   ::=   	 Name - (('X' | 'x') ('M' | 'm') ('L' | 'l'))"

	^ self parserForProcessingInstruction: #letter asParser plus
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
