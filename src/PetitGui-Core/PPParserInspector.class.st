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
	| input |
	composite list
		title: 'Debugger';
		format: [ :each | (String new: 2 * each fourth withAll: $ ) asText , each first, ' - ', each last printString ];
		display: [ :result :sample :parser |
			| depth trace |
			depth := -1.
			trace := OrderedCollection new.
			(parser end transform: [ :each |
				each name notNil 
					ifTrue: [ 
						each >=> [ :s :cc |
							| t r |
							depth := depth + 1. 
							trace addLast: (t := Array with: each name with: s position + 1 with: s position with: depth with: Object new with: nil).
							r := cc value.
							t at: t size put: r.
							t at: 3 put: s position.
							r isPetitFailure
								ifFalse: [ t at: 1 put: (t at: 1) asText allBold ].
							depth := depth - 1.
							r ] ]
					ifFalse: [ each ] ])
				parse: sample.
			trace ].
]

{ #category : #'private building' }
PPParserInspector >> inspectorsIn: composite [
	self resultIn: composite.
	self debuggerIn: composite.
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
	^ (composite text)
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
