Class {
	#name : #SoDecompilerTest,
	#superclass : #TestCase,
	#category : #'ScorchingTests-NewUnit'
}

{ #category : #helpers }
SoDecompilerTest >> soMethodOf: aCompiledMethod [

	^ SoMethodDecompiler decompile: aCompiledMethod
	
]

{ #category : #'tests - basic blocks' }
SoDecompilerTest >> testDecompileInstanceVariableReturn [
	| soMethod |
	soMethod := SoMethodDecompiler decompile: (SoExamples >> #iv2).
	self assert: soMethod basicBlocks size equals: 1.
	self assert: soMethod basicBlocks first instructions size equals: 2.
	self assert: soMethod basicBlocks first instructions first class equals: SoInstVar.
	self assert: soMethod basicBlocks first instructions second class equals: SoReturn.
]

{ #category : #'tests - decompiler' }
SoDecompilerTest >> testDecompileReturnsASoMethod [ 
	| soMethod |
	soMethod := SoMethodDecompiler decompile: (Integer >> #slowFactorial).
	self assert: soMethod class equals: SoMethod.
]

{ #category : #'tests - instructions' }
SoDecompilerTest >> testGotoInstructionKnowsItsTargetBlock [
	| soMethod |
	soMethod := SoMethodDecompiler decompile: (SoExamples >> #exampleArrayAsArg).
	self assert: soMethod basicBlocks fourth firstInstr targetBasicBlock equals: soMethod basicBlocks third
]

{ #category : #'tests - instructions' }
SoDecompilerTest >> testInstructionRefersToTheirMethod [ 
	| soMethod |
	soMethod := SoMethodDecompiler decompile: (SoExamples >> #exampleArrayAsArg).
	soMethod basicBlocks do: 
		[:bb | bb instructionsDo: [ :instr | self assert: instr codeNode = soMethod ]]
]

{ #category : #'tests - basic blocks' }
SoDecompilerTest >> testPredecessors [ 

	| original basicBlocks |
	original := self soMethodOf: (SoExamples>> #simpleCollection).
	basicBlocks := original basicBlocks.
	
	"Preds: #(). Dom: None
[1.1] Gbl:OrderedCollection.
[1.2] (S)  [1.1] new.
[1.3] (S)  100 atRandom.
[1.4] (S)  loopHead.
[1.5] goTo: 2.

Preds: #(1 5). Dom: None
[2.1] phi: [1.2]'1 [5.1]'5 .
[2.2] phi: [1.3]'1 [5.2]'5 .
[2.3] phi: 1'1 [5.4]'5 .
[2.4] (S)  [2.3] <= [2.2].
[2.5] (S)  [2.4] ifTrue: 3 ifFalse: 7.

Preds: #(2). Dom: None
[3.1] (S)  [2.3] \\ 11.
[3.2] (S)  [3.1] = 0.
[3.3] (S)  [3.2] ifTrue: 4 ifFalse: 6.

Preds: #(3). Dom: None
[4.1] (S)  [2.3] asFloat.
[4.2] (S)  [2.3] asFloat.
[4.3] {[4.1] . [4.2]}.
[4.4] (S)  [2.1] add: [4.3].
[4.5] goTo: 5.

Preds: #(4 6). Dom: None
[5.1] phi: [2.1]'6 [2.1]'4 .
[5.2] phi: [2.2]'6 [2.2]'4 .
[5.3] phi: [2.3]'6 [2.3]'4 .
[5.4] (S)  [5.3] + 1.
[5.5] (S)  backTo: 2.

Preds: #(3). Dom: None
[6.1] goTo: 5.

Preds: #(2). Dom: None
[7.1] ^ [2.1].
"

	"There is only one backJump goto: to BB2: BB5"
	self assert: basicBlocks second backwardPredecessors size equals: 1.
	self assert: basicBlocks second hasBackwardPredecessor.
	self assert: basicBlocks second backwardPredecessors first bbNumber equals: 5.
	"[5.1] phi: [2.1]'6 [2.1]'4 .
	[5.2] phi: [2.2]'6 [2.2]'4 .
	[5.3] phi: [2.3]'6 [2.3]'4 .
	[5.4] (S)  [5.3] + 1.
	[5.5] (S)  backTo: 2."


	"But there is goto from one: hence BB2 has B1 and BB5 as predecessors"
	self assert: basicBlocks second predecessors size equals: 2.
	self assert: basicBlocks second predecessors first bbNumber equals: 1.
	self assert: basicBlocks second predecessors second bbNumber equals: 5.


	"BB2 branch to BB3. This is not a backJump just a branch."
	self deny: basicBlocks third hasBackwardPredecessor.
	self assert: basicBlocks third backwardPredecessors isEmpty.
	
	"BB2 branch to BB3."
	self assert: basicBlocks third predecessors size equals: 1. 
	self assert: basicBlocks third predecessors first bbNumber equals: 2.

	"Preds: #(1 5). Dom: None
	[2.1] phi: [1.2]'1 [5.1]'5 .
	[2.2] phi: [1.3]'1 [5.2]'5 .
	[2.3] phi: 1'1 [5.4]'5 .
	[2.4] (S)  [2.3] <= [2.2].
	[2.5] (S)  [2.4] ifTrue: 3 ifFalse: 7.

	Preds: #(2). Dom: None
	[3.1] (S)  [2.3] \\ 11.
	[3.2] (S)  [3.1] = 0.
	[3.3] (S)  [3.2] ifTrue: 4 ifFalse: 6.

	Preds: #(3). Dom: None
	[4.1] (S)  [2.3] asFloat.
	[4.2] (S)  [2.3] asFloat.
	[4.3] {[4.1] . [4.2]}.
	[4.4] (S)  [2.1] add: [4.3].
	[4.5] goTo: 5.
	"


]

{ #category : #'tests - basic blocks' }
SoDecompilerTest >> testSimpleBasicBlockDoesNotHavePredecessors [
	| soMethod |
	soMethod := SoMethodDecompiler decompile: (SoExamples >> #iv2).
	self assert: soMethod basicBlocks first predecessors isEmpty
]

{ #category : #'tests - basic blocks' }
SoDecompilerTest >> testSimpleCollection [

	| original firstBlock |
	original := self soMethodOf: (SoExamples>> #simpleCollection).
	
	"Preds: #(). Dom: None
[1.1] Gbl:OrderedCollection.
[1.2] (S)  [1.1] new.
[1.3] (S)  100 atRandom.
[1.4] (S)  loopHead.
[1.5] goTo: 2.

Preds: #(1 5). Dom: None
[2.1] phi: [1.2]'1 [5.1]'5 .
[2.2] phi: [1.3]'1 [5.2]'5 .
[2.3] phi: 1'1 [5.4]'5 .
[2.4] (S)  [2.3] <= [2.2].
[2.5] (S)  [2.4] ifTrue: 3 ifFalse: 7.

Preds: #(2). Dom: None
[3.1] (S)  [2.3] \\ 11.
[3.2] (S)  [3.1] = 0.
[3.3] (S)  [3.2] ifTrue: 4 ifFalse: 6.

Preds: #(3). Dom: None
[4.1] (S)  [2.3] asFloat.
[4.2] (S)  [2.3] asFloat.
[4.3] {[4.1] . [4.2]}.
[4.4] (S)  [2.1] add: [4.3].
[4.5] goTo: 5.

Preds: #(4 6). Dom: None
[5.1] phi: [2.1]'6 [2.1]'4 .
[5.2] phi: [2.2]'6 [2.2]'4 .
[5.3] phi: [2.3]'6 [2.3]'4 .
[5.4] (S)  [5.3] + 1.
[5.5] (S)  backTo: 2.

Preds: #(3). Dom: None
[6.1] goTo: 5.

Preds: #(2). Dom: None
[7.1] ^ [2.1].
"

	self assert: original basicBlocks size equals: 7.
	firstBlock := original basicBlocks first.
	self assert: firstBlock successors first equals:  original basicBlocks second.
	self assert: original basicBlocks last successors isEmpty.
	
	self halt.
	
]

{ #category : #'tests - basic blocks' }
SoDecompilerTest >> testSuccessors [

	| original firstBlock |
	original := self soMethodOf: (SoExamples>> #simpleCollection).
	
	"Preds: #(). Dom: None
[1.1] Gbl:OrderedCollection.
[1.2] (S)  [1.1] new.
[1.3] (S)  100 atRandom.
[1.4] (S)  loopHead.
[1.5] goTo: 2.

Preds: #(1 5). Dom: None
[2.1] phi: [1.2]'1 [5.1]'5 .
[2.2] phi: [1.3]'1 [5.2]'5 .
[2.3] phi: 1'1 [5.4]'5 .
[2.4] (S)  [2.3] <= [2.2].
[2.5] (S)  [2.4] ifTrue: 3 ifFalse: 7.

Preds: #(2). Dom: None
[3.1] (S)  [2.3] \\ 11.
[3.2] (S)  [3.1] = 0.
[3.3] (S)  [3.2] ifTrue: 4 ifFalse: 6.

Preds: #(3). Dom: None
[4.1] (S)  [2.3] asFloat.
[4.2] (S)  [2.3] asFloat.
[4.3] {[4.1] . [4.2]}.
[4.4] (S)  [2.1] add: [4.3].
[4.5] goTo: 5.

Preds: #(4 6). Dom: None
[5.1] phi: [2.1]'6 [2.1]'4 .
[5.2] phi: [2.2]'6 [2.2]'4 .
[5.3] phi: [2.3]'6 [2.3]'4 .
[5.4] (S)  [5.3] + 1.
[5.5] (S)  backTo: 2.

Preds: #(3). Dom: None
[6.1] goTo: 5.

Preds: #(2). Dom: None
[7.1] ^ [2.1].
"

	self assert: original basicBlocks size equals: 7.
	firstBlock := original basicBlocks first.
	self assert: firstBlock successors first equals:  original basicBlocks second.
	
	self assert: original basicBlocks last successors isEmpty.
	
	self assert: original basicBlocks second successors size equals: 2.
	
	self assert: original basicBlocks third successors size equals: 2.
	
	self assert: original basicBlocks fourth successors size equals: 1. 
	"just a goto."
	
	self halt.
	
]
