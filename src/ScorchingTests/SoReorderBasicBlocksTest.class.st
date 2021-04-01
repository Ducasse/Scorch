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
SoReorderBasicBlocksTest >> testBasicNoReorderIsEqualsTo [

	| reorderedMethod original |
	original := self soMethodOf: (SoExamples>> #iv2).
	reorderedMethod := self reorder: (SoExamples>> #iv2).
	self assert: original basicBlocks size equals: reorderedMethod basicBlocks size.
	self assert: original basicBlocks size equals: 1.
	self assert: original basicBlocks first predecessors equals: reorderedMethod basicBlocks first predecessors.
	self assert: original basicBlocks first predecessors asArray equals: #().
	self assert: (original basicBlocks first isEqualsTo: reorderedMethod basicBlocks first)
]
