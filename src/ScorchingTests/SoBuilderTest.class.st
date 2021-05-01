Class {
	#name : #SoBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'builder'
	],
	#category : #'ScorchingTests-NewUnit'
}

{ #category : #running }
SoBuilderTest >> setUp [

	super setUp.

	"Blocks B0 and B4 are the initial and final blocks, created automatically by the builder"	
	builder := SoBuilder on: SoMethod.
	
]

{ #category : #running }
SoBuilderTest >> test [

	"Set up a complex CFG to test dominator computation, using the example of the book Engineering a Compiler at page 531"

	| trueConstant branchB3B6Instr branchB5B2Instruction branchB7B9Instr b1 b2 b3 b4 b5 b6 b7 b8 b9 |
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
SoBuilderTest >> testInitialAndFinalBlocksAreAutomaticallyCreated [


	| b1 |
	builder := SoBuilder on: SoMethod.
	b1 := builder currentBasicBlock.
	self deny: b1 hasPredecessors.
	self deny: b1 hasInstructions  
	
	
]

{ #category : #running }
SoBuilderTest >> testSmoke [

	"Set up a complex CFG to test dominator computation, using the example of the book Engineering a Compiler at page 531"

	| trueConstant branchB3B6Instr branchB5B2Instruction branchB7B9Instr b1 b2 b3 b4 b5 b6 b7 b8 b9 |
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
