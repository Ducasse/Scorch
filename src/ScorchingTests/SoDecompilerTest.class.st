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
]

{ #category : #tests }
SoDecompilerTest >> testDecompileReturnsASoMethod [ 
	| soMethod |
	soMethod := SoMethodDecompiler decompile: (Integer >> #factorial).
	self assert: soMethod class equals: SoMethod.
]
