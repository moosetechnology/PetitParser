Class {
	#name : #PPJsonGrammar,
	#superclass : #PPCompositeParser,
	#instVars : [
		'members',
		'pair',
		'string',
		'value',
		'elements',
		'number',
		'object',
		'array',
		'trueToken',
		'falseToken',
		'nullToken',
		'char',
		'stringToken',
		'numberToken',
		'charEscape',
		'charNormal'
	],
	#category : #'PetitJson-Core'
}

{ #category : #grammar }
PPJsonGrammar >> array [
	^ $[ asParser token trim , elements optional , $] asParser token trim
]

{ #category : #primitives }
PPJsonGrammar >> char [
	^ charEscape / charNormal
]

{ #category : #primitives }
PPJsonGrammar >> charEscape [
	^ $\ asParser , #any asParser
]

{ #category : #primitives }
PPJsonGrammar >> charNormal [
	^ $" asParser negate
]

{ #category : #grammar }
PPJsonGrammar >> elements [
	^ value separatedBy: $, asParser token trim
]

{ #category : #tokens }
PPJsonGrammar >> falseToken [
	^ 'false' asParser token trim
]

{ #category : #grammar }
PPJsonGrammar >> members [
	^ pair separatedBy: $, asParser token trim
]

{ #category : #tokens }
PPJsonGrammar >> nullToken [
	^ 'null' asParser token trim
]

{ #category : #primitives }
PPJsonGrammar >> number [
	^ $- asParser optional , #digit asParser plus , ($. asParser , #digit asParser plus) optional , (($e asParser / $E asParser) , ($- asParser / $+ asParser) optional , #digit asParser plus) optional
]

{ #category : #tokens }
PPJsonGrammar >> numberToken [
	^ number token trim
]

{ #category : #grammar }
PPJsonGrammar >> object [
	^ ${ asParser token trim , members optional , $} asParser token trim
]

{ #category : #grammar }
PPJsonGrammar >> pair [
	^ stringToken , $: asParser token trim , value
]

{ #category : #accessing }
PPJsonGrammar >> start [
	^ value end
]

{ #category : #primitives }
PPJsonGrammar >> string [
	^ $" asParser , char star , $" asParser
]

{ #category : #tokens }
PPJsonGrammar >> stringToken [
	^ string token trim
]

{ #category : #tokens }
PPJsonGrammar >> trueToken [
	^ 'true' asParser token trim
]

{ #category : #grammar }
PPJsonGrammar >> value [
	^ stringToken / numberToken / object / array / trueToken / falseToken / nullToken
]
