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
		'boolean',
		'attributeName'
	],
	#category : #PetitMSE
}

{ #category : #accessing }
PPMSEGrammar >> attribute [
	^ ($( asParser token , attributeName , attributeValue , $) asParser token) trim
]

{ #category : #accessing }
PPMSEGrammar >> attributeName [
	^ self identifierName
]

{ #category : #accessing }
PPMSEGrammar >> attributeValue [
	^ primitive / reference / element star
]

{ #category : #values }
PPMSEGrammar >> boolean [ 
	^ ('true' asParser / 'false' asParser) token trim
]

{ #category : #accessing }
PPMSEGrammar >> element [
	^ ($( asParser token , identifierName , id optional , attribute star , $) asParser token) trim
]

{ #category : #accessing }
PPMSEGrammar >> elements [
	^ $( asParser trim , element trim star , $) asParser trim
]

{ #category : #accessing }
PPMSEGrammar >> id [
	^ ($( asParser trim , 'id:' asParser trim , #digit asParser star token trim , $) asParser) trim
]

{ #category : #accessing }
PPMSEGrammar >> identifierName [
	^ (#word asParser star flatten , 
		( $. asParser flatten , #word asParser star flatten 
			==> [:token | token first, token second]
		) optional) token trim
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
	^ ($( asParser trim , 'ref:' asParser trim , #digit asParser star flatten trim , $) asParser) token trim
]

{ #category : #accessing }
PPMSEGrammar >> start [ 
	^ elements end
]

{ #category : #values }
PPMSEGrammar >> string [ 
	^ ( $' asParser , ( $' asParser negate ) star token , $' asParser ==> #second ) trim
]
