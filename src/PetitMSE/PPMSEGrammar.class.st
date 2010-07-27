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
	#superclass : #PPCompositeParser,
	#instVars : [
		'elements',
		'element',
		'attributeValue',
		'attribute',
		'identifierName',
		'primitive',
		'reference',
		'id',
		'string',
		'number',
		'boolean'
	],
	#category : #PetitMSE
}

{ #category : #accessing }
PPMSEGrammar >> attribute [
	^ ($( asParser token , identifierName , attributeValue , $) asParser token) trim
]

{ #category : #accessing }
PPMSEGrammar >> attributeValue [
	^ primitive / reference / element
]

{ #category : #values }
PPMSEGrammar >> boolean [ 
	^ ('true' asParser / 'false' asParser) trim
]

{ #category : #accessing }
PPMSEGrammar >> element [
	^ $( asParser token , identifierName , id optional , attribute star , $) asParser token
]

{ #category : #accessing }
PPMSEGrammar >> elements [
	^ $( asParser trim , element trim star , $) asParser trim
]

{ #category : #accessing }
PPMSEGrammar >> id [
	^ $( asParser trim , 'id:' asParser trim , #digit asParser star flatten trim , $) asParser trim
]

{ #category : #accessing }
PPMSEGrammar >> identifierName [
	^ #word asParser star flatten trim , 
	( $. asParser flatten trim , 
	#word asParser star flatten trim 
	==> [:token | token first, token second]
	) optional trim
]

{ #category : #values }
PPMSEGrammar >> number [
	^ ($- asParser optional , #digit asParser plus , ($. asParser , #digit asParser plus) optional) token trim
]

{ #category : #values }
PPMSEGrammar >> primitive [ 
	^ string / number / boolean" , unlimited"
]

{ #category : #values }
PPMSEGrammar >> reference [ 
	^ $( asParser trim , 'ref:' asParser trim , #digit asParser star flatten trim , $) asParser trim
]

{ #category : #accessing }
PPMSEGrammar >> start [ 
	^ elements end
]

{ #category : #values }
PPMSEGrammar >> string [ 
	^ ($' asParser , ( $' asParser negate ) star flatten , $' asParser) trim
]
