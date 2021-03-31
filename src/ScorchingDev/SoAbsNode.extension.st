Extension { #name : #SoAbsNode }

{ #category : #'*ScorchingDev' }
SoAbsNode >> debugSchedulingChildren [
	^ #()
]

{ #category : #'*ScorchingDev' }
SoAbsNode >> debugUses [
	^ #()
]

{ #category : #'*ScorchingDev' }
SoAbsNode >> debugUsesNoDeopt [
	^ self debugUses
]

{ #category : #'*ScorchingDev' }
SoAbsNode >> doesNotUnderstand: aMessage [
	(aMessage selector beginsWith: 'is')
		ifFalse: [ ^ super doesNotUnderstand: aMessage ].
	SoIsGenerator genIsMethodFrom: aMessage in: SoAbsNode.
	(self respondsTo: aMessage selector)
		ifFalse: [ ^ super doesNotUnderstand: aMessage ].
	^ aMessage sentTo: self
]

{ #category : #'*ScorchingDev' }
SoAbsNode >> inspectionInstructions [
	<inspectorPresentationOrder: 6 title: 'Instructions'> 
	
	^ SpTablePresenter new
		items: (self codeNode basicBlocks flatCollect: [:bb | bb instructions , ' ']);	
		yourself
		


]

{ #category : #'*ScorchingDev' }
SoAbsNode >> inspectionSymbolic [
	<inspectorPresentationOrder: 6 title: 'Symb'> 

	^ SpTextPresenter new 
		text: (String streamContents: [:s | SoPrettyPrinter new printCodeNode: self codeNode on: s]);
		yourself
	
]

{ #category : #'*ScorchingDev' }
SoAbsNode >> shortPrintOn: s [
	| instr index |
	self basicBlock ifNil: [ ^ s << '?-?' ].
	s nextPut: $[.
	s << self basicBlock printingNumber.
	s nextPut: $. .
	instr := self basicBlock firstInstr.
	index := 1.
	[ instr == self or: [ instr isCFGInstr ] ] whileFalse: [ 
		index := index + 1.
		instr := instr nextInstr ].
	instr == self ifFalse: [ ^ s << '?]' ].
	index printOn: s.
	s nextPut: $].
		
]
