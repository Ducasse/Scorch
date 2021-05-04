Class {
	#name : #SoFindDominatorsTest,
	#superclass : #SoPassTest,
	#instVars : [
		'builder',
		'b1',
		'b2',
		'b3',
		'b4',
		'b5',
		'b6',
		'b7',
		'b8',
		'b9',
		'passClass',
		'passClasses'
	],
	#category : #'ScorchingTests-NewUnit'
}

{ #category : #'building suites' }
SoFindDominatorsTest class >> testParameters [

	^ ParametrizedTestMatrix new
		addCase: { #passClasses -> {SoSimpleFindDominators} };
		addCase: { #passClasses -> {SoRobustFindDominators} };
		yourself
]

{ #category : #running }
SoFindDominatorsTest >> pass [ 

	^ passes first  
]

{ #category : #running }
SoFindDominatorsTest >> passClasses [

	^ passClasses
]

{ #category : #running }
SoFindDominatorsTest >> passClasses: aPassClasses [

	passClasses := aPassClasses
]

{ #category : #running }
SoFindDominatorsTest >> setUp [

	"Set up a complex CFG to test dominator computation, using the example of the book Engineering a Compiler at page 531"

	| trueConstant branchB3B6Instr branchB5B2Instruction branchB7B9Instr |
	super setUp.

	"Blocks B0 and B4 are the initial and final blocks, created automatically by the builder"	
	builder := SoBuilder on: SoMethod.
	trueConstant := SoConstant constant: true.
	
	b1 := builder currentBasicBlock.
	
	b2 := SoBasicBlock new.
	builder switchToBasicBlock: b2.
	branchB3B6Instr := builder branch: trueConstant.
	
	b3 := SoBasicBlock new.
	builder switchToBasicBlock: b3.
	branchB3B6Instr trueBasicBlock: b3. 
	
	b4 := SoBasicBlock new.
	builder switchToBasicBlock: b4.
	branchB5B2Instruction := builder branch: trueConstant.
	branchB5B2Instruction falseBasicBlock: b2.
	
	b5 := builder returnBasicBlock.
	builder switchToBasicBlock: b5.
	branchB5B2Instruction trueBasicBlock: b5.
	
	b6 := SoBasicBlock new.
	builder switchToBasicBlock: b6.
	branchB3B6Instr falseBasicBlock: b6.
	branchB7B9Instr := builder branch: trueConstant.
	
	b7 := SoBasicBlock new.
	builder switchToBasicBlock: b7.
	branchB7B9Instr trueBasicBlock: b7.

	b8 := SoBasicBlock new.
	builder switchToBasicBlock: b8.
	builder jump: b4.
	
	b9 := SoBasicBlock new.
	builder switchToBasicBlock: b9.
	branchB7B9Instr falseBasicBlock: b9.
	builder jump: b8.
]

{ #category : #running }
SoFindDominatorsTest >> testDominator [

	self pass numberBasicBlocks: builder codeNode basicBlocks.
	self pass computeDominators: builder codeNode basicBlocks.
	
	self assertCollection: (self pass dominatorsOf: b1) hasSameElements: { b1 }.
	self assertCollection: (self pass dominatorsOf: b2) hasSameElements: { b1 . b2 }.
	self assertCollection: (self pass dominatorsOf: b3) hasSameElements: { b1 . b2 . b3 }.
	self assertCollection: (self pass dominatorsOf: b4) hasSameElements: { b1 . b2 . b4 }.
	self assertCollection: (self pass dominatorsOf: b5) hasSameElements: { b1 . b2 . b4 . b5 }.
	self assertCollection: (self pass dominatorsOf: b6) hasSameElements: { b1 . b2 . b6 }.
	self assertCollection: (self pass dominatorsOf: b7) hasSameElements: { b1 . b2 . b6 . b7 }.
	self assertCollection: (self pass dominatorsOf: b8) hasSameElements: { b1 . b2 . b6 . b8 }.
	self assertCollection: (self pass dominatorsOf: b9) hasSameElements: { b1 . b2 . b6 . b9 }.
]

{ #category : #running }
SoFindDominatorsTest >> testImmediateDominator [

	self runOnSoMethod: builder codeNode.
	
	self assert: b1 dominator isNil.
	self assert: b2 dominator equals: b1.
	self assert: b3 dominator equals: b2.
	self assert: b4 dominator equals: b2.
	self assert: b5 dominator equals: b4.
	self assert: b6 dominator equals: b2.
	self assert: b7 dominator equals: b6.
	self assert: b8 dominator equals: b6.
	self assert: b9 dominator equals: b6.
]

{ #category : #running }
SoFindDominatorsTest >> testImmediateDominatorShufflingOrder [

	self pass supportsRandomBlockOrder ifFalse: [ ^ self skip ].

	builder codeNode basicBlocks shuffle.
	self runOnSoMethod: builder codeNode.
	
	self assert: b1 dominator isNil.
	self assert: b2 dominator equals: b1.
	self assert: b3 dominator equals: b2.
	self assert: b4 dominator equals: b2.
	self assert: b5 dominator equals: b4.
	self assert: b6 dominator equals: b2.
	self assert: b7 dominator equals: b6.
	self assert: b8 dominator equals: b6.
	self assert: b9 dominator equals: b6.
]

{ #category : #running }
SoFindDominatorsTest >> testSimpleCollection [

	| reorderedMethod basicBlocks |

"Preds: #(). 
[1.1] Gbl:OrderedCollection.
[1.2] (S)  [1.1] new.
[1.3] (S)  100 atRandom.
[1.4] (S)  loopHead.
[1.5] goTo: 2.

Preds: #(1 5). 
[2.1] phi: [1.2]'1 [5.1]'5 .
[2.2] phi: [1.3]'1 [5.2]'5 .
[2.3] phi: 1'1 [5.4]'5 .
[2.4] (S)  [2.3] <= [2.2].
[2.5] (S)  [2.4] ifTrue: 3 ifFalse: 7.

Preds: #(2). 
[3.1] (S)  [2.3] \\ 11.
[3.2] (S)  [3.1] = 0.
[3.3] (S)  [3.2] ifTrue: 4 ifFalse: 6.

Preds: #(3). 
[4.1] (S)  [2.3] asFloat.
[4.2] (S)  [2.3] asFloat.
[4.3] {[4.1] . [4.2]}.
[4.4] (S)  [2.1] add: [4.3].
[4.5] goTo: 5.

Preds: #(4 6). 
[5.1] phi: [2.1]'6 [2.1]'4 .
[5.2] phi: [2.2]'6 [2.2]'4 .
[5.3] phi: [2.3]'6 [2.3]'4 .
[5.4] (S)  [5.3] + 1.
[5.5] (S)  backTo: 2.

Preds: #(3). 
[6.1] goTo: 5.

Preds: #(2). 
[7.1] ^ [2.1].
"
	
"        1   
			|
			2 _____ 7 
			|   
			3    
		/		\  
		4		6   
		 \    /   
		   \ 	/   
			   5
			
			"	

	reorderedMethod := self runFor: (SoExamples>> #simpleCollection).
	basicBlocks := reorderedMethod basicBlocks.
	self assert: basicBlocks first dominator isNil.
	
	self assert: basicBlocks second dominator bbNumber equals: 1.
	self assert: basicBlocks third dominator bbNumber equals: 2.
	self assert: basicBlocks fourth dominator bbNumber equals: 3.
	self assert: basicBlocks sixth dominator bbNumber equals: 3.
	self assert: basicBlocks fifth dominator bbNumber equals: 3.
	self assert: basicBlocks seventh dominator bbNumber equals: 2.



]
