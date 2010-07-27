"
This defines a parser for the MSE format.

Instance Variables:
	elements	<BalloonBezierSimulation | BalloonLineSimulation | Character class | ECMenuMorph | FMSingleEdgeStrategy | GLMSelectedTextChanged | LineSegment | MABreadthFirstSearchPath | MADijkstra | PPParser | REPHudson | SHRange | Stopwatch | Timespan>
	element	<Heap | PPParser | RecordingControlsMorph>
	elementName	<ProtoObject | PseudoContext>
	elementId	<PPParser>
"
Class {
	#name : #PPMSEParser,
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
PPMSEParser >> attribute [
	^ $( asParser token , identifierName , attributeValue , $) asParser token
	
	==> [:token | Array with: (token at: 2) with: (token at: 3) ]
]

{ #category : #accessing }
PPMSEParser >> attributeValue [
	^ primitive / reference / element
]

{ #category : #values }
PPMSEParser >> boolean [ 
	^ ('true' asParser / 'false' asParser) trim
	
	==> [:token | token first = 'true' ifTrue: [true] ifFalse: [token first = 'false' ifTrue: [false] ifFalse: [nil]]] 
]

{ #category : #accessing }
PPMSEParser >> element [
	^ $( asParser token , identifierName , id optional , attribute star , $) asParser token
	
	==> [:token | Array with: (token at: 2) with: (token at: 3) with: (token at: 4) ]
]

{ #category : #accessing }
PPMSEParser >> elements [
	^ $( asParser trim , element trim star  , $) asParser trim
	
	==> [:token | token second ]
]

{ #category : #accessing }
PPMSEParser >> id [
	^ $( asParser trim , 'id:' asParser trim , #digit asParser star flatten trim , $) asParser trim
	
	==> [:token | Array with: 'id' with: (token at: 3) asNumber ]
]

{ #category : #accessing }
PPMSEParser >> identifierName [
	^ #word asParser star flatten trim , 
	( $. asParser flatten trim , 
	#word asParser star flatten trim 
	==> [:token | token first, token second]
	) optional trim
	
	==> [:token | 
		token second isNil 
			ifTrue: [ token first ] 
			ifFalse: [ token first, token second ] ]
]

{ #category : #values }
PPMSEParser >> number [
	^ #digit asParser star flatten
]

{ #category : #values }
PPMSEParser >> primitive [ 
	^ string / number / boolean" , unlimited"
]

{ #category : #values }
PPMSEParser >> reference [ 
	^ $( asParser trim , 'ref:' asParser trim , #digit asParser star flatten trim , $) asParser trim

	==> [:token | Array with: 'ref' with: (token at: 3) asNumber ]
]

{ #category : #accessing }
PPMSEParser >> start [ 
	^ elements end
]

{ #category : #values }
PPMSEParser >> string [ 
	^ $' asParser trim , ( $' asParser negate ) star flatten , $' asParser trim
	
	==> [:token | token second ]
]
