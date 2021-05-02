"
Should revisit the logic so that we can run multiple passes and unify this for all the soPassTest
"
Class {
	#name : #SoSimplifyPhisTest,
	#superclass : #SoPassTest,
	#category : #'ScorchingTests-NewUnit'
}

{ #category : #helpers }
SoSimplifyPhisTest >> passClass [
	"Dummy we will have to change this."
	^ SoReorderBasicBlocks
]

{ #category : #helpers }
SoSimplifyPhisTest >> runOnSoMethod: soMethod [
	
	| currentPass |
	{ SoReorderBasicBlocks . SoSimpleFindDominators . SoSimplifyPhis } do: [ :eachPass | 
		currentPass := eachPass.
		eachPass new runOn: soMethod ].
	
]

{ #category : #helpers }
SoSimplifyPhisTest >> testBasicNoReorderSmoke [

	|  so |
	so := self soMethodOf: (SoExamples>> #iv2).
	self runOnSoMethod: so.
]
