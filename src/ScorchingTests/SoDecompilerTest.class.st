Class {
	#name : #SoDecompilerTest,
	#superclass : #TestCase,
	#category : #'ScorchingTests-NewUnit'
}

{ #category : #'tests - basic blocks' }
SoDecompilerTest >> testDecompileInstanceVariableReturn [
	| soMethod |
	soMethod := SoMethodDecompiler decompile: (SoExamples >> #iv2).
	self assert: soMethod basicBlocks size equals: 1.
	self assert: soMethod basicBlocks first instructions size equals: 2.
	self assert: soMethod basicBlocks first instructions first class equals: SoInstVar.
	self assert: soMethod basicBlocks first instructions second class equals: SoReturn.
]

{ #category : #'tests - decompilerr' }
SoDecompilerTest >> testDecompileReturnsASoMethod [ 
	| soMethod |
	soMethod := SoMethodDecompiler decompile: (Integer >> #slowFactorial).
	self assert: soMethod class equals: SoMethod.
]

{ #category : #'tests -  instructions' }
SoDecompilerTest >> testGotoInstructionKnowsItsTargetBlock [
	| soMethod |
	soMethod := SoMethodDecompiler decompile: (SoExamples >> #exampleArrayAsArg).
	self assert: soMethod basicBlocks fourth firstInstr targetBasicBlock equals: soMethod basicBlocks third
]

{ #category : #'tests -  instructions' }
SoDecompilerTest >> testInstructionRefersToTheirMethod [ 
	| soMethod |
	soMethod := SoMethodDecompiler decompile: (SoExamples >> #exampleArrayAsArg).
	soMethod basicBlocks do: 
		[:bb | bb instructionsDo: [ :instr | self assert: instr codeNode = soMethod ]]
]

{ #category : #'tests - basic blocks' }
SoDecompilerTest >> testSimpleBasicBlockDoesNotHavePredecessors [
	| soMethod |
	soMethod := SoMethodDecompiler decompile: (SoExamples >> #iv2).
	self assert: soMethod basicBlocks first predecessors isEmpty
]
