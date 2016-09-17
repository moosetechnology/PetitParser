"
This defines a parser for the MSE format.

Instance Variables:
	elements	<BalloonBezierSimulation | BalloonLineSimulation | Character class | ECMenuMorph | FMSingleEdgeStrategy | GLMSelectedTextChanged | LineSegment | MABreadthFirstSearchPath | MADijkstra | PPParser | REPHudson | SHRange | Stopwatch | Timespan>
	element	<Heap | PPParser | RecordingControlsMorph>
	elementName	<ProtoObject | PseudoContext>
	elementId	<PPParser>
"
Class {
	#name : #PPMSEGrammar,
	#superclass : #PP2CompositeNode,
	#instVars : [
		'elements',
		'element',
		'attributeValue',
		'attribute',
		'elementName',
		'primitive',
		'reference',
		'id',
		'string',
		'number',
		'boolean',
		'integerReference',
		'nameReference',
		'open',
		'close',
		'simpleName',
		'natural',
		'e',
		'stringText'
	],
	#category : #PetitMSE
}

{ #category : #grammar }
PPMSEGrammar >> attribute [
	^ (open , simpleName , attributeValue , close) trim
]

{ #category : #grammar }
PPMSEGrammar >> attributeValue [
	^ (primitive / reference / element) star
]

{ #category : #basic }
PPMSEGrammar >> boolean [ 
	^ ('true' asPParser / 'false' asPParser) flatten token trim
]

{ #category : #basic }
PPMSEGrammar >> close [
	^ $) asPParser trim
]

{ #category : #basic }
PPMSEGrammar >> e [
	^ ($e asPParser / $E asPParser) , ($- asPParser / $+ asPParser) optional , natural
]

{ #category : #grammar }
PPMSEGrammar >> element [
	^ (open , elementName , id optional , attribute star , close) trim
]

{ #category : #basic }
PPMSEGrammar >> elementName [
	^ (#word asPParser star flatten , 
		( $. asPParser , #word asPParser star flatten ) optional) token trim
]

{ #category : #grammar }
PPMSEGrammar >> elements [
	^ open , element star , close
]

{ #category : #grammar }
PPMSEGrammar >> id [
	^ open , 'id:' asPParser , #digit asPParser star token trim , close
]

{ #category : #grammar }
PPMSEGrammar >> integerReference [ 
	^ (open , 'ref:' asPParser , natural trim , close) token trim
]

{ #category : #grammar }
PPMSEGrammar >> nameReference [ 
	^ open , 'ref:' asPParser , elementName trim , close
]

{ #category : #basic }
PPMSEGrammar >> natural [
	^ #digit asPParser plus flatten trim
]

{ #category : #basic }
PPMSEGrammar >> number [
	^ ($- asPParser optional , natural , ($. asPParser , natural , e optional) optional) flatten token trim
]

{ #category : #basic }
PPMSEGrammar >> open [
	^ $( asPParser trim
]

{ #category : #basic }
PPMSEGrammar >> primitive [ 
	^ string / number / boolean" , unlimited"
]

{ #category : #grammar }
PPMSEGrammar >> reference [ 
	^ integerReference / nameReference
]

{ #category : #basic }
PPMSEGrammar >> simpleName [
	^ #word asPParser star flatten token trim
]

{ #category : #accessing }
PPMSEGrammar >> start [ 
	^ elements end
]

{ #category : #basic }
PPMSEGrammar >> string [
	^ ($' asPParser , stringText , $' asPParser) trim
]

{ #category : #basic }
PPMSEGrammar >> stringText [
	^ ('''''' asPParser / $' asPParser negate) star flatten token
]
