Class {
	#name : #SoPassTest,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'pass',
		'passes'
	],
	#category : #'ScorchingTests-NewUnit'
}

{ #category : #helpers }
SoPassTest >> passClasses [

	^ #()
]

{ #category : #helpers }
SoPassTest >> runFor: aCompiledMethod [

	| soMethod |
	soMethod := self soMethodOf: aCompiledMethod.
	self runOnSoMethod: soMethod.
	^ soMethod
]

{ #category : #helpers }
SoPassTest >> runOnSoMethod: soMethod [

	passes do: [ :each | each runOn: soMethod ]
]

{ #category : #helpers }
SoPassTest >> setUp [

	super setUp.
	passes := self passClasses collect: [ :each | each new ]
]

{ #category : #helpers }
SoPassTest >> soMethodOf: aCompiledMethod [

	^ SoMethodDecompiler decompile: aCompiledMethod
	
]
