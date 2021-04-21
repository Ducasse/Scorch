Class {
	#name : #SoPassTest,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'pass'
	],
	#category : #'ScorchingTests-NewUnit'
}

{ #category : #helpers }
SoPassTest >> runFor: aCompiledMethod [

	| soMethod |
	soMethod := self soMethodOf: aCompiledMethod.
	self runOnSoMethod: soMethod.
	^ soMethod
]

{ #category : #helpers }
SoPassTest >> runOnSoMethod: soMethod [

	pass runOn: soMethod
]

{ #category : #helpers }
SoPassTest >> setUp [

	super setUp.
	pass := self passClass new.
]

{ #category : #helpers }
SoPassTest >> soMethodOf: aCompiledMethod [

	^ SoMethodDecompiler decompile: aCompiledMethod
	
]
