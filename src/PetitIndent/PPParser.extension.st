Extension { #name : #PPParser }

{ #category : #'*PetitIndent' }
PPParser >> aligned [
	^ PPAlignedParser on: self
]

{ #category : #'*PetitIndent' }
PPParser >> alignedTo: aPPParser [
	^ PPAlignedParser on: self	ref: aPPParser.
]

{ #category : #'*PetitIndent' }
PPParser >> cut [
	^ PPSmartTrimmingParser on: self
]

{ #category : #'*PetitIndent' }
PPParser >> deepStrictlyOnside [
	^ self deepStrictlyOnsideTo: self indentationLevel
]

{ #category : #'*PetitIndent' }
PPParser >> deepStrictlyOnsideTo: aPPParser [
	"
		Still not sure if HACK or not
		Either or so, it works like this:
			- wait till runtime
			- than transform its children so that the terminals are not allowed offside
			- return the result (and forget about the transformation)
	"
	^ self >=> [ :cntx :continuation |
		(self transform: [ :each |		
			each isTerminal ifTrue: [ 
				PPStrictlyOnsideParser on: each ref: aPPParser
			] ifFalse: [ 
				each
			]
		]) parseOn: cntx
	]
]

{ #category : #'*PetitIndent' }
PPParser >> forgetColumn [
	^ self pop
]

{ #category : #'*PetitIndent' }
PPParser >> indentationLevel [
	^ PPIndentationLevel instance
]

{ #category : #'*PetitIndent' }
PPParser >> isIndentationParser [
	^ false
]

{ #category : #'*PetitIndent' }
PPParser >> next: context [
	^ PPChoiceParser withAll: (self nextSet: context)
]

{ #category : #'*PetitIndent' }
PPParser >> nextSet: aPPContext [
	^ aPPContext root nextSets at: self.
]

{ #category : #'*PetitIndent' }
PPParser >> offside [
	^ PPOffsideParser on: self
]

{ #category : #'*PetitIndent' }
PPParser >> offsideTo: aPPParser [
	^ PPOffsideParser on: self ref: aPPParser.
]

{ #category : #'*PetitIndent' }
PPParser >> onside [
	^ PPOnsideParser on: self.
]

{ #category : #'*PetitIndent' }
PPParser >> onsideTo: aPPParser [
	^ PPOnsideParser on: self ref: aPPParser.
]

{ #category : #'*PetitIndent' }
PPParser >> onsideTo: aPPParser tolerance: tolerance [
	^ (PPTolerantOnsideParser on: self ref: aPPParser)
		tolerance: tolerance;
		yourself
]

{ #category : #'*PetitIndent' }
PPParser >> onsideTolerance: tolerance [
	^ (PPTolerantOnsideParser on: self)
		tolerance: tolerance;
		yourself
]

{ #category : #'*PetitIndent' }
PPParser >> pop [
	^ PPPopParser new
		ref: self;
		yourself.
]

{ #category : #'*PetitIndent' }
PPParser >> pop: ref [
	^ (self, (PPPopParser new
				ref: ref;
				yourself)) ==> #first
]

{ #category : #'*PetitIndent' }
PPParser >> push [
	^ PPPushParser new
		ref: self;
		yourself.
]

{ #category : #'*PetitIndent' }
PPParser >> rememberColumn [
	^ (self push, self) ==> #second
]

{ #category : #'*PetitIndent' }
PPParser >> removeIndentationLevel [
	^ self indentationLevel pop
]

{ #category : #'*PetitIndent' }
PPParser >> selfAligned [
	^ PPAlignedParser on: self ref: self
]

{ #category : #'*PetitIndent' }
PPParser >> setIndentationLevel [
	^ (self indentationLevel push, self) ==> #second
]

{ #category : #'*PetitIndent' }
PPParser >> strictlyOnside [
	^ PPStrictlyOnsideParser on: self
]

{ #category : #'*PetitIndent' }
PPParser >> strictlyOnsideTo: aPPParser [
	^ PPStrictlyOnsideParser on: self ref: aPPParser.
]

{ #category : #'*PetitIndent' }
PPParser >> trimWithIndents [
	^ PPIndentTrimmingParser on: self
	
"	^ (#indent asParser / #dedent asParser / #space asParser) star, 
	self, 
	(#indent asParser / #dedent asParser / #space asParser) star ==>  #second"
]

{ #category : #'*PetitIndent' }
PPParser >> trimWithoutIndents [
	^ PPNoIndentTrimmingParser on: self.
"	| il trimmer |
	il := PPIndentationLevel instance.
	trimmer := 
	     (#startOfLine asParser not, 
		#blank asParser star,
		""Make sure that logical line starts at level equal to indentation level""
	  	((#newline asParser, #blank asParser star) plus, (nil asParser alignedTo: il)) optional
	     )
	/
	     (#startOfLine asParser,
		#blank asParser star,
		(#newline asParser, #blank asParser star) star,
		(nil asParser alignedTo: il)
	     )
	/
		nil asParser.
	^ trimmer, self, trimmer ==> #second
"	
	
]

{ #category : #'*PetitIndent' }
PPParser >> under [
	^ PPUnderParser on: self.
]

{ #category : #'*PetitIndent' }
PPParser >> under: aPPParser [
	^ PPUnderParser on: self ref: aPPParser.
]
