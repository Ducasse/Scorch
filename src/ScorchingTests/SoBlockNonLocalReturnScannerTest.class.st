Class {
	#name : #SoBlockNonLocalReturnScannerTest,
	#superclass : #TestCase,
	#category : #'ScorchingTests-UnitTests'
}

{ #category : #tests }
SoBlockNonLocalReturnScannerTest >> testExampleBlock5 [
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
			ifTrue: [ res := (SoBlockNonLocalReturnScanner on: each) scan. ]].
	self deny: res
	
]

{ #category : #tests }
SoBlockNonLocalReturnScannerTest >> testExampleNonLocalReturn [
	"exampleNonLocalReturn
	| temp |
	temp := 1.
	[ ^ 2 ] value
	"
	| res |
	(SoExamples >> #exampleNonLocalReturn) literals do: [ :each |
		(each class == CompiledBlock)
			ifTrue: [ res := (SoBlockNonLocalReturnScanner on: each) scan. ]].
	self assert: res
	
]

{ #category : #tests }
SoBlockNonLocalReturnScannerTest >> testExampleSpillPhi [ 
	"By default a block scanner is initialized to return false."
	| scanner |
	scanner := SoBlockNonLocalReturnScanner on: (SoExamples >> #exampleSpillPhi).
	self deny: scanner hasNonLocalReturn

]
