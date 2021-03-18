Class {
	#name : #SoBlockNLRScannerTest,
	#superclass : #TestCase,
	#category : #'ScorchingTests-UnitTests'
}

{ #category : #tests }
SoBlockNLRScannerTest >> testExampleBlock5 [
	"exampleBlock5
	| t |
	t := [ 1 + 2. self ].
	4 + 5 - 3.
	self evalFar: t.
	^ 3 + 2
	"
	| res |
	(SoExamples >> #exampleBlock5) literals do: [ :each |
		(each class == CompiledBlock)
			ifTrue: [ res := (SoBlockNLRScanner on: each) scan. ]].
	self deny: res
	
]

{ #category : #tests }
SoBlockNLRScannerTest >> testExampleNonLocalReturn [
	"exampleNonLocalReturn
	| temp |
	temp := 1.
	[ ^ 2 ] value
	"
	| res |
	(SoExamples >> #exampleNonLocalReturn) literals do: [ :each |
		(each class == CompiledBlock)
			ifTrue: [ res := (SoBlockNLRScanner on: each) scan. ]].
	self assert: res
	
]

{ #category : #tests }
SoBlockNLRScannerTest >> testExampleSpillPhi [ 
	"By default a block scanner is initialized to return false."
	| scanner |
	scanner := SoBlockNLRScanner on: (SoExamples >> #exampleSpillPhi).
	self deny: scanner hasNLR

]
