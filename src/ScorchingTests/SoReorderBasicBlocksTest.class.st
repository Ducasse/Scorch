Class {
	#name : #SoReorderBasicBlocksTest,
	#superclass : #TestCase,
	#category : #'ScorchingTests-NewUnit'
}

{ #category : #helpers }
SoReorderBasicBlocksTest >> reorder: aCompiledMethod [

	| soMethod |
	soMethod := self soMethodOf: aCompiledMethod.
	SoReorderBasicBlocks new runOn: soMethod.
	^ soMethod
]

{ #category : #helpers }
SoReorderBasicBlocksTest >> soMethodOf: aCompiledMethod [

	^ SoMethodDecompiler decompile: aCompiledMethod
	
]

{ #category : #'tests - no reordering' }
SoReorderBasicBlocksTest >> testBasicNoReorder [

	| reorderedMethod original |
	original := self soMethodOf: (SoExamples>> #iv2).
	reorderedMethod := self reorder: (SoExamples>> #iv2).
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
	reorderedMethod := self reorder: (SoExamples>> #iv2).
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
	reorderedMethod := self reorder: (SoExamples>> #exampleSafePeelUsedAfter).
	self assert: original basicBlocks size equals: reorderedMethod basicBlocks size.
	self assert: original basicBlocks size equals: 4.
	original basicBlocks with:  reorderedMethod basicBlocks do: 	
			[ :bb1 :bb2 |  self assert: (bb1 isEqualsTo: bb2) ]
]

{ #category : #'tests - reordering' }
SoReorderBasicBlocksTest >> testGetNastyCollection [

	| reorderedMethod original |
	self skip.
	original := self soMethodOf: (SoExamples>> #getNastyCollection).
	reorderedMethod := self reorder: (SoExamples>> #getNastyCollection).
	self assert: original basicBlocks size equals: reorderedMethod basicBlocks size.
	self assert: original basicBlocks size equals: 22.
	original basicBlocks with:  reorderedMethod basicBlocks do: 	
			[ :bb1 :bb2 |  self assert: (bb1 isEqualsTo: bb2) ]
	self halt.
]

{ #category : #'tests general' }
SoReorderBasicBlocksTest >> testReorderingDoesNotChangeBasicBlocksNumber [

	| reorderedMethod original |
	original := self soMethodOf: (SoExamples>> #getNastyCollection).
	reorderedMethod := self reorder: (SoExamples>> #getNastyCollection).
	self assert: original basicBlocks size equals: reorderedMethod basicBlocks size.
	self assert: original basicBlocks size equals: 22.
	
]

{ #category : #'tests - no reordering' }
SoReorderBasicBlocksTest >> testSimpleCollection [

	| reorderedMethod original |
	self skip.
	original := self soMethodOf: (SoExamples>> #simpleCollection).
	reorderedMethod := self reorder: (SoExamples>> #simpleCollection).

	original basicBlocks with: reorderedMethod basicBlocks do: 	
			[ :bb1 :bb2 |  self assert: (bb1 isEqualsTo: bb2) ].
	self halt.
]
