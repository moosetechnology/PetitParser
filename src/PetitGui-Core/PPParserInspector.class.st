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
		row: #results.
	(browser transmit)
		to: #sample;
		andShow: [ :a | self sampleIn: a ].
	(browser transmit)
		from: #sample;
		to: #results;
		andShow: [ :a | self resultsIn: a ].
	^ browser
]

{ #category : #'private building' }
PPParserInspector >> resultsIn: composite [
	composite 
		text
		title: 'Result';
		display: [:result | result ];
		act: [:text | text entity inspect ] 
			icon: GLMUIThemeExtraIcons glamorousInspect
			entitled: 'Inspect'.

]

{ #category : #'private building' }
PPParserInspector >> sampleIn: composite [
	^ (composite text)
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
				output ]
]
