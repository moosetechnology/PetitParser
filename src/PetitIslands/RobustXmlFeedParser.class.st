"
A RobustXmlFeedParser is XmlFeedParser, that can handle error within an xml Item element

"
Class {
	#name : #RobustXmlFeedParser,
	#superclass : #XmlFeedParser,
	#category : #'PetitIslands-Examples'
}

{ #category : #'as yet unclassified' }
RobustXmlFeedParser >> itemContent [
	^ ((simpleElement island ==> #second) star) ==> self elementsToDictionaryBlock
]
