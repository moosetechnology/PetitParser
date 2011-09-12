Class {
	#name : #PPParserInspector,
	#superclass : #GLMBrowserTemplate,
	#category : #'PetitGui-Core'
}

{ #category : #building }
PPParserInspector >> buildBrowser [
	"self openOn: PPArithmeticParser new"

	browser := GLMTabulator new.
	browser
		row: #sample;
		row: #inspectors.
	(browser transmit)
		to: #sample;
		andShowIfNone: [ :a | self sampleIn: a ].
	(browser transmit)
		from: #sample; "result"
		from: #sample port: #text; "sample text"
		fromOutside: #entity; "parser"  
		to: #inspectors;
		andShow: [ :a | self inspectorsIn: a ].
	^ browser
]

{ #category : #'private building' }
PPParserInspector >> debuggerIn: composite [
	composite tree
		title: 'Debugger';
		format: [:resultNode | resultNode formattedText ];
		display: [ :result :sample :parser | {PPParserDebuggerResult parse: sample with: parser } ];
		children: [:resultNode | resultNode children ].
]

{ #category : #'private building' }
PPParserInspector >> inspectorsIn: composite [
	self resultIn: composite.
	self debuggerIn: composite.
	"self tallyIn: composite  "
]

{ #category : #'private building' }
PPParserInspector >> progressChartIn: composite [
	composite morph 
		title: 'Progress';
		display: [ :stream |
			| morph |
			morph := ScrollPane new.
			morph color: Color white.
			morph scroller addMorph: stream asPositionMorph.
			morph ]
]

{ #category : #'private building' }
PPParserInspector >> resultIn: composite [
	(composite text)
		title: 'Result';
		display: [ :result :sample :parser | result ];
		act: [ :text | text entity inspect ] icon: GLMUIThemeExtraIcons glamorousInspect entitled: 'Inspect'
]

{ #category : #'private building' }
PPParserInspector >> sampleIn: composite [
	(composite text)
		title: 'Sample';
		display: '';
		selectionPopulate: #selection
			on: $s
			entitled: 'Parse (s)'
			with: [ :presentation :parser | 
				| stream output |
				stream := PPBrowserStream on: presentation text asString.
				output := parser parse: stream.
				output isPetitFailure
					ifTrue: [ presentation selectionInterval: (output position + 1 to: output position) ].
				(presentation pane port: #sample) value: presentation text.
				output ]
]

{ #category : #'private building' }
PPParserInspector >> tallyIn: composite [
	composite table 
		title: 'Tally';
		column: 'Parser' evaluated: [ :each | each first displayName ];
		column: 'Count' evaluated: [ :each | each second printString ];
		column: 'Percentage (%)' evaluated: [ :each | each third printString ];
		display: [:result :sample | (PPBrowserStream on: sample) asFrequencyTable ]
]
