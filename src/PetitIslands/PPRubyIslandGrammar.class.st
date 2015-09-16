"
I can recognize basic structure block in ruby code (almost precisely).

I use indentation to determine the scope of the block. I use island to skip the rest.

The following structures are recognized:
- modules
- classes
- methods
"
Class {
	#name : #PPRubyIslandGrammar,
	#superclass : #PPCompositeParser,
	#instVars : [
		'primary',
		'kClassIS',
		'cpath',
		'superclass',
		'identifier',
		'kSelf',
		'word',
		'fname',
		'classDef',
		'methodDef',
		'primaryElement',
		'water',
		'operator',
		'program',
		'kDefIS',
		'defEndIS',
		'line',
		'kModuleIS',
		'moduleDef',
		'eigenDef',
		'body',
		'kEndIS',
		'kEnd',
		'comment',
		'string',
		'aligns',
		'nl',
		'setIl',
		'onside',
		'restoreIl',
		'sol',
		'eol',
		'eof',
		'onsideLine'
	],
	#category : #'PetitIslands-Examples'
}

{ #category : #indentation }
PPRubyIslandGrammar >> aligns [
	^ [:context |
		(context column == (context indentStack topIfEmpty: -1)) ifTrue: [ 
			#aligns
		] ifFalse: [
			PPFailure message: 'no alignment' at: context position
		]
	] asParser
		"JK: this is a hack, it improves the speed of compiled parser"
		propertyAt: #changesContext put: false;
		yourself
]

{ #category : #grammar }
PPRubyIslandGrammar >> body [
	^	((((primaryElement) island: water) ==> #second) plus) 
			==> [ :args | args select: [ :e | e isEmpty not ]]
	/
		((nil asParser island: water) ==> [ :args | #() ])
]

{ #category : #'grammar - class' }
PPRubyIslandGrammar >> classDef [
	"Indentation Sensitive Class Definition"
	^ kClassIS, 
		cpath trim, 
		superclass optional, 
		body, 
		kEndIS
	
	
	map: [ :cl :cp :sup :content :end | 
		| retval |
		retval := OrderedCollection new.
		content do: [ :m |
			retval addAll: (m collect: [:e | '::', cp, e ]).
		].
		retval.
	]
]

{ #category : #whitespaces }
PPRubyIslandGrammar >> comment [
	^ $# asParser trimBlanks, (nl negate star), nl
]

{ #category : #grammar }
PPRubyIslandGrammar >> cpath [
	^ ('::' asParser optional , identifier, (('::' asParser , identifier) star)) flatten
]

{ #category : #'grammar - method' }
PPRubyIslandGrammar >> defEndIS [
	"End of Indentation Sensitive Feature"
	^ kEnd optional, restoreIl
]

{ #category : #grammar }
PPRubyIslandGrammar >> eigenDef [
	^ kClassIS , '<<' asParser trim , (identifier / kSelf) , 
		body, 
		kEndIS 
	
	map: [ :class :tmp :ref :content :end |
		| retval |
		retval := OrderedCollection new.
		content do: [ :m |
			retval addAll: (m collect: [:e | '.', ref, e ]).
		].
		retval.		
	]

]

{ #category : #whitespaces }
PPRubyIslandGrammar >> eof [
	^ #eof asParser
]

{ #category : #whitespaces }
PPRubyIslandGrammar >> eol [
	^ nl / eof
]

{ #category : #grammar }
PPRubyIslandGrammar >> fname [
	^ (operator / 
		'..' asParser / '|' asParser / 'ˆ' asParser / '&' asParser 
		/ '<=>' asParser / '==' asParser / 
		'===' asParser / '=~' asParser / '>'asParser / '>='asParser / '<' asParser / 
		'<=' asParser / '+' asParser / '-' asParser / 
		'*' asParser / '/' asParser /	'%' asParser / '**' asParser / '<<' asParser / 
		'>>' asParser / '~' asParser / '+@' asParser / 
		'-@' asParser / '[]' asParser / '[]=' asParser)

]

{ #category : #grammar }
PPRubyIslandGrammar >> identifier [
	^ (#letter asParser / $_ asParser, word star) flatten
]

{ #category : #keywords }
PPRubyIslandGrammar >> kClassIS [
	^ (($. asParser / word) previous not, setIl, 'class' asParser , ($. asParser / word) not) ==> #third
]

{ #category : #keywords }
PPRubyIslandGrammar >> kDefIS [
	^ (word previous not, setIl, 'def' asParser , word not) ==> #third
]

{ #category : #keywords }
PPRubyIslandGrammar >> kEnd [
	^ (word previous not, 'end' asParser , word not) ==> #second
]

{ #category : #keywords }
PPRubyIslandGrammar >> kEndIS [
	"End of Indentation Sensitive Feature"
	^ aligns, kEnd, restoreIl
]

{ #category : #keywords }
PPRubyIslandGrammar >> kModuleIS [
	^ (word previous not, setIl, 'module' asParser , word not) trim ==> #third
]

{ #category : #keywords }
PPRubyIslandGrammar >> kSelf [
	^ (($. asParser / word) previous not, 'self' asParser , ($. asParser / word) not) trim ==> #second
]

{ #category : #whitespaces }
PPRubyIslandGrammar >> line [
	^ (sol, nl negate star, eol) nonEmpty
]

{ #category : #'grammar - method' }
PPRubyIslandGrammar >> methodDef [
	^ kDefIS, 
		('self.' asParser / (identifier, $. asParser)) flatten trim optional ,
		fname trim, 
		primary,
	  	defEndIS 
	
	map: [ :def :static :name :content :end |
		| mName retval |
		mName := static isNil 	ifTrue: [ '.', name ]
										ifFalse: [ '.', static, name ].

		retval := OrderedCollection new.
		content do: [ :e | retval addAll: (e collect: [ :e2 | mName, e2 ]) ].
		retval add: mName.
		retval										
	]

]

{ #category : #grammar }
PPRubyIslandGrammar >> moduleDef [
	"Indentation Sensitive Class Definition"
	^ kModuleIS, 
		cpath trim, 
		body, 
		kEndIS
	
	
	map: [ :module :cp :prim :end | 
		| retval |
		retval := OrderedCollection new.
		prim do: [ :m |
			retval addAll: (m collect: [:e | '::', cp, e ]).
		].
		retval.
	]
]

{ #category : #whitespaces }
PPRubyIslandGrammar >> nl [
	^ #newline asParser
]

{ #category : #indentation }
PPRubyIslandGrammar >> onside [
	^ [:context |
		(context column >= (context indentStack topIfEmpty: -1)) ifTrue: [ 
			#onside
		] ifFalse: [
			PPFailure message: 'offside position, not onside :(' at: context position
		]
	] asParser
		"JK: this is a hack, it improves the speed of compiled parser"
		propertyAt: #changesContext put: false;
		yourself
]

{ #category : #whitespaces }
PPRubyIslandGrammar >> onsideLine [
	^ onside, #letter asParser, nl asParser negate star, eol
]

{ #category : #grammar }
PPRubyIslandGrammar >> operator [
	^ (identifier , ($? asParser / $! asParser / $= asParser) optional) flatten

]

{ #category : #grammar }
PPRubyIslandGrammar >> primary [
	^	((((primaryElement) island: water) ==> #second) plus) 
			==> [ :args | args select: [ :e | e isEmpty not ]]
	/
		((nil asParser island: water) ==> [ :args | #() ])
]

{ #category : #grammar }
PPRubyIslandGrammar >> primaryElement [
	^ onside, 
		(classDef /
		moduleDef /
		eigenDef /
		methodDef)
	==> #second
]

{ #category : #grammar }
PPRubyIslandGrammar >> program [
	^ primary ==> [ :res | 
		res flatten 
	]
]

{ #category : #indentation }
PPRubyIslandGrammar >> restoreIl [
	^ [ :context | context indentStack pop ] asParser
		"JK: this is a hack, it improves the speed of compiled parser"
		propertyAt: #indentPop put: true;
		yourself
]

{ #category : #indentation }
PPRubyIslandGrammar >> setIl [
	^ [:context |
		| level |
		level := context column.
		context indentStack push: level.
	] asParser
		"JK: this is a hack, it improves the speed of compiled parser"
		propertyAt: #indentPush put: true;
		yourself
]

{ #category : #whitespaces }
PPRubyIslandGrammar >> sol [
	^ #startOfLine asParser
]

{ #category : #accessing }
PPRubyIslandGrammar >> start [
	^ program
]

{ #category : #grammar }
PPRubyIslandGrammar >> string [
	| doubleQuotes singleQuotes slash doubleString singleString regexp |
	doubleQuotes := $" asParser.
	singleQuotes := $' asParser.
	slash := $/ asParser.
	
	doubleString := (doubleQuotes , 
		(($\ asParser , doubleQuotes) / #any asParser starLazy: doubleQuotes) , 
		doubleQuotes) flatten.
		
	singleString := (singleQuotes , 
		(($\ asParser , singleQuotes) / #any asParser starLazy: singleQuotes) , 
		singleQuotes) flatten.
		
	regexp := (slash ,
	  (('\\' asParser) / ($\ asParser , slash) / #any asParser starLazy: slash) ,
	  slash) flatten.
		
	^ (doubleString / singleString / regexp) ==> [ :nodes | #() ]
]

{ #category : #grammar }
PPRubyIslandGrammar >> superclass [
	^ (($< asParser trim , cpath) ==> #second)

]

{ #category : #whitespaces }
PPRubyIslandGrammar >> water [
	^ (#space asParser plus) /  onsideLine  / comment "/ string / line" /  identifier / #any asParser
]

{ #category : #grammar }
PPRubyIslandGrammar >> word [
	^ #word asParser / $_ asParser
]
