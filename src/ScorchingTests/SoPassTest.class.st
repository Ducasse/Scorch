Class {
	#name : #SoPassTest,
	#superclass : #TestCase,
	#category : #'ScorchingTests-NewUnit'
}

{ #category : #helpers }
SoPassTest >> runFor: aCompiledMethod [

	| soMethod |
	soMethod := self soMethodOf: aCompiledMethod.
	self passClass new runOn: soMethod.
	^ soMethod
]

{ #category : #helpers }
SoPassTest >> soMethodOf: aCompiledMethod [

	^ SoMethodDecompiler decompile: aCompiledMethod
	
]
