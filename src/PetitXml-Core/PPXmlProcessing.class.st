Class {
	#name : #PPXmlProcessing,
	#superclass : #PPXmlData,
	#instVars : [
		'target'
	],
	#category : #'PetitXml-Core'
}

{ #category : #'instance creation' }
PPXmlProcessing class >> target: aTargetString data: aString [
	^ self new 
		target: aTargetString; 
		data: aString;
		yourself
]

{ #category : #printing }
PPXmlProcessing >> printXmlOn: aStream [
	aStream nextPutAll: '<?'; nextPutAll: target; nextPutAll: data; nextPutAll: '?>'
]

{ #category : #accessing }
PPXmlProcessing >> target [
	^ target
]

{ #category : #accessing }
PPXmlProcessing >> target: aString [
	target := aString
]
