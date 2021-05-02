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

{ #category : #tests }
SoBuilderTest >> test [

	"Set up a complex CFG to test dominator computation, using the example of the book Engineering a Compiler at page 531"

	| trueConstant branchB3B6Instr branchB5B2Instruction branchB7B9Instr b1 b2 b3 b4 b5 b6 b7 b8 b9 |

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

{ #category : #'tests - adding instructions' }
SoBuilderTest >> testAddInstruction [

	| newInstruction |
	builder := SoBuilder on: SoMethod.
	self deny: builder currentBasicBlock hasInstructions.
	
	newInstruction := (SoNewOp withReceiver: SoReceiver new).
	builder addInstruction: newInstruction.
	
	self assert: builder currentBasicBlock hasInstructions.
	self assert: builder currentInstruction equals: newInstruction

]

{ #category : #'tests - adding instructions' }
SoBuilderTest >> testAddInstructionChainInstruction [

	| instr1 instr2 bb1 |
	builder := SoBuilder on: SoMethod.
	self deny: builder currentBasicBlock hasInstructions.
	
	instr1 := (SoNewOp withReceiver: SoReceiver new).
	builder addInstruction: instr1.
	instr2 := (SoCreateTempVect new vectorSize: 3; yourself).
	builder addInstruction: instr2.
	self assert: instr1 nextInstruction equals: instr2.

	"we need to terminate with a control flow graph instructions 
	else instructions does not work."
	
	bb1 := SoBasicBlock new. 
	builder jump: bb1.
	self assert: instr2  nextInstruction equals: builder currentInstruction 
	
]

{ #category : #'tests - adding instructions' }
SoBuilderTest >> testAddInstructionInsertOneAfterTheOther [

	| instr1 instr2 bb1 |
	builder := SoBuilder on: SoMethod.
	self deny: builder currentBasicBlock hasInstructions.
	
	instr1 := (SoNewOp withReceiver: SoReceiver new).
	builder addInstruction: instr1.
	self assert: builder currentInstruction equals: instr1.

	instr2 := (SoCreateTempVect new vectorSize: 3; yourself).
	builder addInstruction: instr2.
	self assert: builder currentInstruction equals: instr2.

	"we need to terminate with a control flow graph instructions 
	else instructions does not work."
	
	bb1 := SoBasicBlock new. 
	builder jump: bb1.
	
	self assert: builder currentBasicBlock instructions size equals: 3. 
	self assert: builder currentBasicBlock hasInstructions.

]

{ #category : #'tests - creator helpers' }
SoBuilderTest >> testConstantDoesNotModifyTheBuilder [
	"Would be good to rename constant: to denote that it does not modify the builder contents"
	
	| trueConstant l |	
	builder := SoBuilder on: SoMethod.
	self deny: builder currentBasicBlock hasInstructions.
	l := builder returnBasicBlock instructions size. 
	
	trueConstant := builder constant: true.
	
	self deny: builder currentBasicBlock hasInstructions.
	self assert: builder returnBasicBlock instructions size equals: l
]

{ #category : #tests }
SoBuilderTest >> testInitialAndFinalBlocksAreAutomaticallyCreated [


	| entry out |
	builder := SoBuilder on: SoMethod.
	entry := builder currentBasicBlock.
	self deny: entry hasPredecessors.
	self deny: entry hasInstructions.
	
	out := builder returnBasicBlock.
	self deny: out hasPredecessors.
	self assert: out hasInstructions.
	self assert: out firstInstruction class equals: SoPhi.
	self assert: builder returnPhi class equals: SoPhi.
	
	
]

{ #category : #tests }
SoBuilderTest >> testSmoke [

	"Set up a complex CFG to test dominator computation, using the example of the book Engineering a Compiler at page 531"

	| trueConstant branchB3B6Instr branchB5B2Instruction branchB7B9Instr b1 b2 b3 b4 b5 b6 b7 b8 b9 |

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
