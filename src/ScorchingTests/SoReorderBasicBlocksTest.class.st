Class {
	#name : #SoReorderBasicBlocksTest,
	#superclass : #SoPassTest,
	#category : #'ScorchingTests-NewUnit'
}

{ #category : #helpers }
SoReorderBasicBlocksTest >> passClass [

	^ SoReorderBasicBlocks
]

{ #category : #'tests - no reordering' }
SoReorderBasicBlocksTest >> testBasicNoReorder [

	| reorderedMethod original |
	original := self soMethodOf: (SoExamples>> #iv2).
	reorderedMethod := self runFor: (SoExamples>> #iv2).
	self assert: original basicBlocks size equals: reorderedMethod basicBlocks size.
	self assert: original basicBlocks size equals: 1.
	self assert: original basicBlocks first predecessors equals: reorderedMethod basicBlocks first predecessors.
	self assert: original basicBlocks first predecessors asArray equals: #().
	self assert: original basicBlocks first firstInstr printString equals: reorderedMethod basicBlocks first firstInstr printString.
	self assert: original basicBlocks first lastInstr printString equals: reorderedMethod basicBlocks first lastInstr printString.
	self assert: original basicBlocks first tempData isNil.
	self assert: reorderedMethod basicBlocks first tempData isNil.
]

{ #category : #'tests - no reordering' }
SoReorderBasicBlocksTest >> testBasicNoReorderWithIsEqualsTo [

	| reorderedMethod original |
	original := self soMethodOf: (SoExamples>> #iv2).
	reorderedMethod := self runFor: (SoExamples>> #iv2).
	self assert: original basicBlocks size equals: reorderedMethod basicBlocks size.
	self assert: original basicBlocks size equals: 1.
	self assert: original basicBlocks first predecessors equals: reorderedMethod basicBlocks first predecessors.
	self assert: original basicBlocks first predecessors asArray equals: #().
	self assert: (original basicBlocks first isEqualsTo: reorderedMethod basicBlocks first)
]

{ #category : #'tests - no reordering' }
SoReorderBasicBlocksTest >> testExampleSafePeelUsedAfter [

	| reorderedMethod original |
	original := self soMethodOf: (SoExamples>> #exampleSafePeelUsedAfter).
	reorderedMethod := self runFor: (SoExamples>> #exampleSafePeelUsedAfter).
	self assert: original basicBlocks size equals: reorderedMethod basicBlocks size.
	self assert: original basicBlocks size equals: 4.
	original basicBlocks with:  reorderedMethod basicBlocks do: 	
			[ :bb1 :bb2 |  self assert: (bb1 isEqualsTo: bb2) ]
]

{ #category : #'tests - reordering' }
SoReorderBasicBlocksTest >> testGetNastyCollection [

	| reorderedMethod original |
	original := self soMethodOf: (SoExamples>> #getNastyCollection).
	reorderedMethod := self runFor: (SoExamples>> #getNastyCollection).
	self assert: original basicBlocks size equals: reorderedMethod basicBlocks size.
	self assert: original basicBlocks size equals: 22.

	"Not really satisfactory.
	But the algorithm has not been made to be tested. Probably a subclass could be a solution"
]

{ #category : #'tests general' }
SoReorderBasicBlocksTest >> testReorderingDoesNotChangeBasicBlocksNumber [

	| reorderedMethod original |
	original := self soMethodOf: (SoExamples>> #getNastyCollection).
	reorderedMethod := self runFor: (SoExamples>> #getNastyCollection).
	self assert: original basicBlocks size equals: reorderedMethod basicBlocks size.
	self assert: original basicBlocks size equals: 22.
	
]

{ #category : #'tests - no reordering' }
SoReorderBasicBlocksTest >> testSimpleCollection [

	| reorderedMethod original |
	original := self soMethodOf: (SoExamples>> #simpleCollection).
	reorderedMethod := self runFor: (SoExamples>> #simpleCollection).

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
	
	"should think how to test the specific part of the algo."
	self assert: ((original basicBlocks sixth) firstInstr isKindOf: SoJumpAhead).
	self assert: ((reorderedMethod basicBlocks fifth) firstInstr isKindOf: SoJumpAhead).
	
	reorderedMethod basicBlocks 	
			withIndexDo: [ :each :ind | self assert: each postOrder equals: ind ]




]
