Class {
	#name : #SoSendAndBranchDataCacheTest,
	#superclass : #TestCase,
	#category : #'ScorchingTests-UnitTests'
}

{ #category : #tests }
SoSendAndBranchDataCacheTest >> testExampleAdd [
	
	self assert: (SoSendAndBranchDataCache exampleData: SoExamples>>#exampleAdd) isEmpty
]

{ #category : #tests }
SoSendAndBranchDataCacheTest >> testExampleAssignment [
	"normal there is no branch and not send."
	self assert: (SoSendAndBranchDataCache exampleData: SoExamples>>#exampleAssignment) isEmpty
]

{ #category : #tests }
SoSendAndBranchDataCacheTest >> testExampleEqual [
	
	self 
		assert: (SoSendAndBranchDataCache exampleData: SoExamples>>#exampleEqual) 
		equals: {{42. SoExamples. SoExamples>>#string}. {44. SoExamples. SoExamples>>#string2}. #(45 nil #'==')}
]

{ #category : #tests }
SoSendAndBranchDataCacheTest >> testExampleSpillPhi [
	
	self assert: (SoSendAndBranchDataCache exampleData: SoExamples>>#exampleSpillPhi) equals: 
		{#(82 30000 35535). {100. SoExamples. SoExamples>>#bar:foo:baz:}}
]

{ #category : #tests }
SoSendAndBranchDataCacheTest >> testMakeSureThatGenerateExamplesDataDoesNotFail [
	"Yes this is a smoke test. But better this than nothing. 
	And before there was nothing!"
	
	SoSendAndBranchDataCache generateExamplesData 
]
