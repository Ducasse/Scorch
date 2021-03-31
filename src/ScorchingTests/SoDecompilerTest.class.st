Class {
	#name : #SoDecompilerTest,
	#superclass : #TestCase,
	#category : #'ScorchingTests-NewUnit'
}

{ #category : #tests }
SoDecompilerTest >> testDecompileInstanceVariableReturn [
	| soMethod |
	soMethod := SoMethodDecompiler decompile: (SoExamples >> #iv2).
	self assert: soMethod basicBlocks size equals: 1.
	self assert: soMethod basicBlocks first instructions size equals: 2.
	self assert: soMethod basicBlocks first instructions first class equals: SoInstVar.
	self assert: soMethod basicBlocks first instructions second class equals: SoReturn.
]

{ #category : #tests }
SoDecompilerTest >> testDecompileReturnsASoMethod [ 
	| soMethod |
	soMethod := SoMethodDecompiler decompile: (Integer >> #slowFactorial).
	self assert: soMethod class equals: SoMethod.
]

{ #category : #tests }
SoDecompilerTest >> testSimpleBasicBlockDoesNotHavePredecessors [
	| soMethod |
	soMethod := SoMethodDecompiler decompile: (SoExamples >> #iv2).
	self assert: soMethod basicBlocks first predecessors isEmpty
]
