Class {
	#name : #SoReorderBasicBlocksTest,
	#superclass : #TestCase,
	#category : #'ScorchingTests-NewUnit'
}

{ #category : #tests }
SoReorderBasicBlocksTest >> reorder: aCompiledMethod [

	| soMethod |
	soMethod := self soMethodOf: aCompiledMethod.
	SoReorderBasicBlocks new runOn: soMethod.
	^ soMethod
]

{ #category : #tests }
SoReorderBasicBlocksTest >> soMethodOf: aCompiledMethod [

	^ SoMethodDecompiler decompile: aCompiledMethod
	
]

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
SoReorderBasicBlocksTest >> testExampleSafePeelUsedAfter [

	| reorderedMethod original |
	original := self soMethodOf: (SoExamples>> #exampleSafePeelUsedAfter).
	reorderedMethod := self reorder: (SoExamples>> #exampleSafePeelUsedAfter).
	self assert: original basicBlocks size equals: reorderedMethod basicBlocks size.
	self assert: original basicBlocks size equals: 4.
	original basicBlocks with:  reorderedMethod basicBlocks do: 	
			[ :bb1 :bb2 |  self assert: (bb1 isEqualsTo: bb2) ]
]

{ #category : #tests }
SoReorderBasicBlocksTest >> testGetNastyCollection [

	| reorderedMethod original |
	original := self soMethodOf: (SoExamples>> #getNastyCollection).
	reorderedMethod := self reorder: (SoExamples>> #getNastyCollection).
	self assert: original basicBlocks size equals: reorderedMethod basicBlocks size.
	self assert: original basicBlocks size equals: 22.
	original basicBlocks with:  reorderedMethod basicBlocks do: 	
			[ :bb1 :bb2 |  self assert: (bb1 isEqualsTo: bb2) ]
	self halt.
]

{ #category : #tests }
SoReorderBasicBlocksTest >> testReorderingDoesNotChangeBasicBlocksNumber [

	| reorderedMethod original |
	original := self soMethodOf: (SoExamples>> #getNastyCollection).
	reorderedMethod := self reorder: (SoExamples>> #getNastyCollection).
	self assert: original basicBlocks size equals: reorderedMethod basicBlocks size.
	self assert: original basicBlocks size equals: 22.
	
]

{ #category : #tests }
SoReorderBasicBlocksTest >> testSimpleCollection [

	| reorderedMethod original |
	original := self soMethodOf: (SoExamples>> #simpleCollection).
	reorderedMethod := self reorder: (SoExamples>> #simpleCollection).
	self assert: original basicBlocks size equals: reorderedMethod basicBlocks size.
	self assert: original basicBlocks size equals: 7.
	original basicBlocks with:  reorderedMethod basicBlocks do: 	
			[ :bb1 :bb2 |  self assert: (bb1 isEqualsTo: bb2) ].
	self halt.
]
