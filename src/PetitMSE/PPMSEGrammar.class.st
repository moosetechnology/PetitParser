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
	^ ('true' asParser2 / 'false' asParser2) flatten token trim
]

{ #category : #basic }
PPMSEGrammar >> close [
	^ $) asParser2 trim
]

{ #category : #basic }
PPMSEGrammar >> e [
	^ ($e asParser2 / $E asParser2) , ($- asParser2 / $+ asParser2) optional , natural
]

{ #category : #grammar }
PPMSEGrammar >> element [
	^ (open , elementName , id optional , attribute star , close) trim
]

{ #category : #basic }
PPMSEGrammar >> elementName [
	^ (#word asParser2 star flatten , 
		( $. asParser2 , #word asParser2 star flatten ) optional) token trim
]

{ #category : #grammar }
PPMSEGrammar >> elements [
	^ open , element star , close
]

{ #category : #grammar }
PPMSEGrammar >> id [
	^ open , 'id:' asParser2 , #digit asParser2 star token trim , close
]

{ #category : #grammar }
PPMSEGrammar >> integerReference [ 
	^ (open , 'ref:' asParser2 , natural trim , close) token trim
]

{ #category : #grammar }
PPMSEGrammar >> nameReference [ 
	^ open , 'ref:' asParser2 , elementName trim , close
]

{ #category : #basic }
PPMSEGrammar >> natural [
	^ #digit asParser2 plus flatten trim
]

{ #category : #basic }
PPMSEGrammar >> number [
	^ ($- asParser2 optional , natural , ($. asParser2 , natural , e optional) optional) flatten token trim
]

{ #category : #basic }
PPMSEGrammar >> open [
	^ $( asParser2 trim
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
	^ #word asParser2 star flatten token trim
]

{ #category : #accessing }
PPMSEGrammar >> start [ 
	^ elements end
]

{ #category : #basic }
PPMSEGrammar >> string [
	^ ($' asParser2 , stringText , $' asParser2) trim
]

{ #category : #basic }
PPMSEGrammar >> stringText [
	^ ('''''' asParser2 / $' asParser2 negate) star flatten token
]
