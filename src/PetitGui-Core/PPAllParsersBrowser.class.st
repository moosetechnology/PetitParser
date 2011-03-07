"
self open
"
Class {
	#name : #PPAllParsersBrowser,
	#superclass : #GLMGlobalBrowserTemplate,
	#category : #'PetitGui-Core'
}

{ #category : #building }
PPAllParsersBrowser >> buildBrowser [
	"self open"
	browser := GLMTabulator new.
	browser 
		row: #parser;
		row: #classes size: 25.
	browser transmit to: #classes; andShow: [:a | 
		self classesIn: a ]. 
	browser transmit to: #parser; from: #classes; andShow: [:a | 
		self custom: PPParserBrowser new ].
	^ browser
]

{ #category : #'private building' }
PPAllParsersBrowser >> classesIn: composite [
	composite dropDownList 
			display: [ :class | self subclassesOf: class ]
]

{ #category : #opening }
PPAllParsersBrowser >> entity [
	^ PPCompositeParser
]

{ #category : #querying }
PPAllParsersBrowser >> subclassesOf: aBehavior [
	^ aBehavior allSubclasses asSortedCollection: [ :a :b | a name < b name ]
]
