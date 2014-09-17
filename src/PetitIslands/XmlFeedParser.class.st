"
A XmlFeedParser is Parser of a fake shop feed. Shop feed is a XML file with information about shop products. Shop feed can be malformed (for any reason) the parser will recover from malformed item and will continue on the next valid item.

Instance Variables
	closeItem:		<Object>
	closeName:		<Object>
	closeShoplist:		<Object>
	item:		<Object>
	itemContent:		<Object>
	name:		<Object>
	nameContent:		<Object>
	openItem:		<Object>
	openName:		<Object>
	openShoplist:		<Object>
	shoplist:		<Object>
	shoplistContent:		<Object>
	simpleElement:		<Object>
	stringValue:		<Object>

closeItem
	- xxxxx

closeName
	- xxxxx

closeShoplist
	- xxxxx

item
	- xxxxx

itemContent
	- xxxxx

name
	- xxxxx

nameContent
	- xxxxx

openItem
	- xxxxx

openName
	- xxxxx

openShoplist
	- xxxxx

shoplist
	- xxxxx

shoplistContent
	- xxxxx

simpleElement
	- xxxxx

stringValue
	- xxxxx

"
Class {
	#name : #XmlFeedParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'item',
		'openItem',
		'itemContent',
		'closeItem',
		'openShoplist',
		'shoplistContent',
		'closeShoplist',
		'shoplist',
		'simpleElement',
		'stringValue'
	],
	#category : #'PetitIslands-Examples'
}

{ #category : #tags }
XmlFeedParser >> closeItem [
	^ '</' asParser, 'item' asParser trim, '>' asParser
]

{ #category : #tags }
XmlFeedParser >> closeShoplist [
	^ '</' asParser, 'shoplist' asParser trim, '>' asParser
]

{ #category : #xmlSupport }
XmlFeedParser >> elementsToDictionaryBlock [
 	^ [ :elements | | d | 
		d := Dictionary new.
		elements do: [ :e | d at: e first asSymbol put: e second ].
		d
	]
]

{ #category : #grammar }
XmlFeedParser >> item [
	^ (openItem, itemContent trim, closeItem) trim ==> #second
]

{ #category : #grammar }
XmlFeedParser >> itemContent [
	^ (simpleElement trim star) ==> self elementsToDictionaryBlock
]

{ #category : #tags }
XmlFeedParser >> openItem [
	^ '<' asParser, 'item' asParser trim, '>' asParser
]

{ #category : #tags }
XmlFeedParser >> openShoplist [
	^ '<' asParser, 'shoplist' asParser trim, '>' asParser
]

{ #category : #grammar }
XmlFeedParser >> shoplist [
	^ (openShoplist, shoplistContent, closeShoplist) trim ==> #second
]

{ #category : #grammar }
XmlFeedParser >> shoplistContent [
	^ (item island ==> #second) star
]

{ #category : #xmlSupport }
XmlFeedParser >> simpleElement [
	^ (
		(('<' asParser, stringValue trim, '>' asParser) ==> #second),
		stringValue,
		(('</' asParser, stringValue trim, '>' asParser) ==> #second)
	) ==> [ :elements |
		(elements first = elements third) 
		ifTrue: [ Array with: elements first with: elements second ]
		ifFalse: [ PPFailure message: 'malformed element' context: nil at: 'todo' ]
 	]
]

{ #category : #grammar }
XmlFeedParser >> start [
	^ shoplist
]

{ #category : #grammar }
XmlFeedParser >> stringValue [
	^ (#letter asParser / #digit asParser) star flatten trim
]
