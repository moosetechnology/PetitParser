Class {
	#name : #PPXmlXPathGrammar,
	#superclass : #PPCompositeParser,
	#instVars : [
		'locationPath',
		'relativeLocationPath',
		'absoluteLocationPath',
		'abbreviatedAbsoluteLocationPath',
		'step',
		'abbreviatedRelativeLocationPath',
		'axisSpecifier',
		'nodeTest',
		'predicate',
		'abbreviatedStep',
		'axisName',
		'abbreviatedAxisSpecifier',
		'nameTest',
		'nodeType',
		'literal',
		'predicateExpr',
		'expr',
		'orExpr',
		'variableReference',
		'number',
		'functionCall',
		'functionName',
		'argument',
		'pathExpr',
		'unionExpr',
		'filterExpr',
		'primaryExpr',
		'andExpr',
		'equalityExpr',
		'relationalExpr',
		'additiveExpr',
		'multiplicativeExpr',
		'unaryExpr',
		'operator',
		'digits',
		'identifier'
	],
	#category : #'PetitXml-Core'
}

{ #category : #grammar }
PPXmlXPathGrammar >> abbreviatedAbsoluteLocationPath [
	"[10] AbbreviatedAbsoluteLocationPath ::= '//' RelativeLocationPath"

	^ '//' asParser , relativeLocationPath
]

{ #category : #grammar }
PPXmlXPathGrammar >> abbreviatedAxisSpecifier [
	"[13] AbbreviatedAxisSpecifier ::= '@'?"

	^ $@ asParser optional
]

{ #category : #grammar }
PPXmlXPathGrammar >> abbreviatedRelativeLocationPath [
	"[11] AbbreviatedRelativeLocationPath ::= RelativeLocationPath '//' Step"

	^ relativeLocationPath , '//' asParser , step
]

{ #category : #grammar }
PPXmlXPathGrammar >> abbreviatedStep [
	"[12] AbbreviatedStep ::= '.' | '..'"

	^ $. asParser / '..' asParser
]

{ #category : #grammar }
PPXmlXPathGrammar >> absoluteLocationPath [
	"[2] AbsoluteLocationPath ::= '/' RelativeLocationPath?
                             | AbbreviatedAbsoluteLocationPath"

	^ ($/ asParser , relativeLocationPath optional) / abbreviatedAbsoluteLocationPath
]

{ #category : #grammar }
PPXmlXPathGrammar >> additiveExpr [
	"[25] AdditiveExpr ::= MultiplicativeExpr
                    | AdditiveExpr '+' MultiplicativeExpr
                    | AdditiveExpr '-' MultiplicativeExpr"

	^ multiplicativeExpr / (additiveExpr , $+ , multiplicativeExpr) / (additiveExpr , $- , multiplicativeExpr)
]

{ #category : #grammar }
PPXmlXPathGrammar >> andExpr [
	"[22] AndExpr ::= EqualityExpr | AndExpr 'and' EqualityExpr"

	^ equalityExpr / (andExpr , 'and' asParser , equalityExpr)
]

{ #category : #grammar }
PPXmlXPathGrammar >> argument [
	"[17] Argument ::= Expr"

	^ expr
]

{ #category : #grammar }
PPXmlXPathGrammar >> axisName [
	"[6] AxisName ::=
		'ancestor' |
		'ancestor-or-self' |
		'attribute' |
		'child' |
		'descendant' |
		'descendant-or-self' |
		'following' |
		'following-sibling' |
		'namespace' |
		'parent' |
		'preceding' |
		'preceding-sibling' |
		'self'"

	^ #( 'ancestor' 'ancestor-or-self' 'attribute' 'child' 'descendant' 'descendant-or-self' 'following' 'following-sibling' 'namespace' 'parent' 'preceding' 'preceding-sibling' 'self' ) asSet asParser
]

{ #category : #grammar }
PPXmlXPathGrammar >> axisSpecifier [
	"[5] AxisSpecifier ::= AxisName '::' | AbbreviatedAxisSpecifier"

	^ (axisName , '::' asParser) / abbreviatedAxisSpecifier
]

{ #category : #grammar }
PPXmlXPathGrammar >> digits [
	"[31] Digits ::= [0-9]+"
	
	^ #digit asParser plus
]

{ #category : #grammar }
PPXmlXPathGrammar >> equalityExpr [
	"[23] EqualityExpr ::= RelationalExpr | EqualityExpr '=' RelationalExpr
                    | EqualityExpr '!=' RelationalExpr"

	^ relationalExpr / (equalityExpr , $= asParser , relationalExpr) / (equalityExpr , '!=' asParser , relationalExpr)
]

{ #category : #grammar }
PPXmlXPathGrammar >> expr [
	"[14] Expr ::= OrExpr"

	^ orExpr
]

{ #category : #grammar }
PPXmlXPathGrammar >> exprToken [
	"[28] ExprToken ::= '(' | ')' | '[' | ']' | '.' | '..' | '@' | ',' | '::'
                    | NameTest | NodeType | Operator | FunctionName
                    | AxisName | Literal | Number | VariableReference"

	^ $( asParser / $) asParser / $[ asParser / $] asParser / $. asParser / '..' asParser / $@ asParser / $, asParser / '::' asParser / nameTest / nodeType / operator / functionName / axisName / literal / number / variableReference
]

{ #category : #grammar }
PPXmlXPathGrammar >> filterExpr [
	"[20] FilterExpr ::= PrimaryExpr | FilterExpr Predicate"

	^ primaryExpr / (filterExpr , predicate)
]

{ #category : #grammar }
PPXmlXPathGrammar >> functionCall [
	"[16] FunctionCall ::= FunctionName '(' ( Argument ( ',' Argument )* )? ')'"

	^ functionName , $( asParser , (argument separatedBy: $, asParser) optional , $) asParser
]

{ #category : #grammar }
PPXmlXPathGrammar >> functionName [
	"[35] FunctionName ::= QName - NodeType"
	
	^ identifier
]

{ #category : #grammar }
PPXmlXPathGrammar >> identifier [
	^ #word asParser plus
]

{ #category : #grammar }
PPXmlXPathGrammar >> literal [
	"[29] Literal ::= '""' [^""]* '""' | ""'"" [^']* ""'"""
	
	^ ($" asParser , #any starLazy: $" asParser , $" asParser)
	/ ($' asParser , #any starLazy: $' asParser , $' asParser)
]

{ #category : #grammar }
PPXmlXPathGrammar >> locationPath [
	"[1] LocationPath ::= RelativeLocationPath | AbsoluteLocationPath"

	^ relativeLocationPath / absoluteLocationPath
]

{ #category : #grammar }
PPXmlXPathGrammar >> multiplicativeExpr [
	"[26] MultiplicativeExpr ::= UnaryExpr
                    | MultiplicativeExpr MultiplyOperator UnaryExpr
                    | MultiplicativeExpr 'div' UnaryExpr
                    | MultiplicativeExpr 'mod' UnaryExpr"

	^ unaryExpr / (multiplicativeExpr , $* asParser , unaryExpr) / (multiplicativeExpr , 'div'asParser  , unaryExpr) / (multiplicativeExpr , 'mod' asParser , unaryExpr)
]

{ #category : #grammar }
PPXmlXPathGrammar >> nameTest [
	"[37] NameTest ::= '*' | NCName ':' '*' | QName"
	
	^ $* asParser / (identifier , $: asParser , $* asParser) / identifier
]

{ #category : #grammar }
PPXmlXPathGrammar >> nodeTest [
	"[7] NodeTest ::= NameTest | NodeType '(' ')'
                | 'processing-instruction' '(' Literal ')'"

	^ nameTest / (nodeType , $( asParser , $) asParser) / ('processing-instruction' asParser , $( asParser , literal , $))
]

{ #category : #grammar }
PPXmlXPathGrammar >> nodeType [
	"[38] NodeType ::= 'comment' | 'text' | 'processing-instruction' | 'node'"
	
	^ #( 'comment' 'text' 'processing-instruction' 'node' ) asSet asParser
]

{ #category : #grammar }
PPXmlXPathGrammar >> number [
	"[30] Number ::= Digits ('.' Digits?)? | '.' Digits"
	
	^ (digits , ($. asParser , digits optional) optional) / ($. asParser , digits)
]

{ #category : #grammar }
PPXmlXPathGrammar >> operator [
	"[32] Operator ::= OperatorName | MultiplyOperator | '/' | '//' | '|'
            | '+' | '-' | '=' | '!=' | '<' | '<=' | '>' | '>='"
	
	^ #('and' 'or' 'mod' 'div' '*' '/' '//' '|' '+' '-' '=' '!=' '<' '<=' '>' '>=') asSet asParser
]

{ #category : #grammar }
PPXmlXPathGrammar >> orExpr [
	"[21] OrExpr ::= AndExpr | OrExpr 'or' AndExpr"

	^ andExpr / (orExpr , 'or' asParser , andExpr)
]

{ #category : #grammar }
PPXmlXPathGrammar >> pathExpr [
	"[19] PathExpr ::= LocationPath | FilterExpr
                | FilterExpr '/' RelativeLocationPath
                | FilterExpr '//' RelativeLocationPath"

	^ locationPath / filterExpr / (filterExpr , $/ asParser , relativeLocationPath) / (filterExpr , '//' asParser , relativeLocationPath)
]

{ #category : #grammar }
PPXmlXPathGrammar >> predicate [
	"[8] Predicate ::= '[' PredicateExpr ']'"

	^ $[ asParser , predicateExpr , $] asParser
]

{ #category : #grammar }
PPXmlXPathGrammar >> predicateExpr [
	"[9] PredicateExpr ::= Expr"

	^ expr
]

{ #category : #grammar }
PPXmlXPathGrammar >> primaryExpr [
	"[15] PrimaryExpr ::= VariableReference | '(' Expr ')' | Literal
                     | Number | FunctionCall"

	^ variableReference / ($( asParser , expr , $) asParser) / literal / number / functionCall
]

{ #category : #grammar }
PPXmlXPathGrammar >> relationalExpr [
	"[24] RelationalExpr ::= AdditiveExpr
                      | RelationalExpr '<' AdditiveExpr
                      | RelationalExpr '>' AdditiveExpr
                      | RelationalExpr '<=' AdditiveExpr
                      | RelationalExpr '>=' AdditiveExpr"

	^ additiveExpr / (relationalExpr , $< asParser , additiveExpr) / (relationalExpr , $> asParser , additiveExpr) / (relationalExpr , '<=' asParser , additiveExpr) / (relationalExpr , '>=' asParser , additiveExpr)
]

{ #category : #grammar }
PPXmlXPathGrammar >> relativeLocationPath [
	"[3] RelativeLocationPath ::= Step | RelativeLocationPath '/' Step | AbbreviatedRelativeLocationPath"

	^ step / (relativeLocationPath , $/ , step) / abbreviatedRelativeLocationPath
]

{ #category : #'as yet unclassified' }
PPXmlXPathGrammar >> start [
	^ locationPath
]

{ #category : #grammar }
PPXmlXPathGrammar >> step [
	"[4] Step ::= AxisSpecifier NodeTest Predicate* | AbbreviatedStep"

	^ (axisSpecifier , nodeTest , predicate star) / abbreviatedStep
]

{ #category : #grammar }
PPXmlXPathGrammar >> unaryExpr [
	"[27] UnaryExpr ::= UnionExpr | '-' UnaryExpr"

	^ unionExpr / ($- asParser , unaryExpr)
]

{ #category : #grammar }
PPXmlXPathGrammar >> unionExpr [
	"[18] UnionExpr ::= PathExpr | UnionExpr '|' PathExpr"

	^ pathExpr / (unionExpr , $| asParser , pathExpr)
]

{ #category : #grammar }
PPXmlXPathGrammar >> variableReference [
	"[36] VariableReference ::= '$' QName"
	
	^ $$ asParser , identifier
]
