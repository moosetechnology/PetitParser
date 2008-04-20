Class {
	#name : #PPSmalltalkParser,
	#superclass : #PPCompositeParser,
	#category : #'PetitParser-Builder'
}

{ #category : #scanner }
PPSmalltalkParser >> comment [
	"<comment>:			\"" [^\""]* \"" ;"
				
	$" , $" not star , $"
]

{ #category : #'scanner-number' }
PPSmalltalkParser >> decimalNumber [
	"<decimalNumber>:	[0-9]+ (\. [0-9]+)? ;"
	
	#digit plus , ($. , #digit plus) optional
]

{ #category : #'scanner-number' }
PPSmalltalkParser >> exponentNumber [
	"<exponentNumber>:	(<decimalNumber> | <radixNumber>) e \-? [0-9]+ ;"

	(decimalNumber | radixNumber) , $e , $- optional , #digit plus
]

{ #category : #scanner }
PPSmalltalkParser >> identifier [
	#letter , #word star
]

{ #category : #scanner }
PPSmalltalkParser >> keyword [
	"<keyword>:			<name> \: ;"
				
	name , $:
]

{ #category : #scanner }
PPSmalltalkParser >> multikeyword [
	"<multikeyword>:		<name> \: (<name> \: )+ ;"
				
	name , $: , (name , $:) plus
]

{ #category : #scanner }
PPSmalltalkParser >> name [
	"<name>:				[a-zA-Z] [a-zA-Z0-9]* ;"
					
	#letter , #word star
]

{ #category : #'scanner-number' }
PPSmalltalkParser >> negativeNumber [
	"<negativeNumber>:	\- <number> ;"

	$- , number
]

{ #category : #scanner }
PPSmalltalkParser >> number [
	"<number>:			<decimalNumber> | <radixNumber> | <exponentNumber> | <scaledNumber> ;"
				
	scaledNumber | exponentNumber | radixNumber | decimalNumber
]

{ #category : #'scanner-number' }
PPSmalltalkParser >> radixNumber [
	"<radixNumber>:		[0-9]+ r [0-9A-Z]+ (\. [0-9A-Z]+)? ;"
	
	#digit plus , $r , (#digit | #uppercase) plus , ($. , (#digit | #uppercase) plus) optional
]

{ #category : #'scanner-number' }
PPSmalltalkParser >> scaledNumber [
	"<scaledNumber>:		<decimalNumber> s [0-9]+ ;"

	decimalNumber , $s , #digit plus
]

{ #category : #scanner }
PPSmalltalkParser >> string [
	"<string>:				\'  [^\']* \' (\' [^\']* \')* ;"
					
	$' , $' not star , $' , ($' , $' not star , $' ) star
]

{ #category : #scanner }
PPSmalltalkParser >> whitespace [
	"<whitespace>:			\s* ;"
				
	#space star
]
