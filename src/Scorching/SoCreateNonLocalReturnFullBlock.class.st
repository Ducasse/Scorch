"
Same as superclass but I have a NLR.

The fake constant is passed in a phi to mark where the NLRs should return to.

nlrPhi <SoPhi> phi to return to if one inlines this NLR
"
Class {
	#name : #SoCreateNonLocalReturnFullBlock,
	#superclass : #SoCreateContextFullBlock,
	#instVars : [
		'nlrPhi',
		'fakeConstant',
		'fakeBasicBlock'
	],
	#category : #'Scorching-Nodes-Body Instructions'
}

{ #category : #accessing }
SoCreateNonLocalReturnFullBlock >> fakeBasicBlock [
	<generated>
	^ fakeBasicBlock
]

{ #category : #accessing }
SoCreateNonLocalReturnFullBlock >> fakeBasicBlock: aValue [
	<generated>
	fakeBasicBlock := aValue
]

{ #category : #accessing }
SoCreateNonLocalReturnFullBlock >> fakeConstant [
	<generated>
	^ fakeConstant
]

{ #category : #accessing }
SoCreateNonLocalReturnFullBlock >> fakeConstant: aValue [
	<generated>
	fakeConstant := aValue
]

{ #category : #testing }
SoCreateNonLocalReturnFullBlock >> hasNonLocalReturn [
	^ true
]

{ #category : #initialization }
SoCreateNonLocalReturnFullBlock >> initialize [

	super initialize.

	fakeConstant := SoConstant constant: 'fakeNLRVal'.
	fakeBasicBlock := SoBasicBlock new.
	fakeBasicBlock lastInstr: (SoJumpAhead from: fakeBasicBlock to: fakeBasicBlock).
	fakeBasicBlock firstInstruction: fakeBasicBlock lastInstr.
]

{ #category : #traversing }
SoCreateNonLocalReturnFullBlock >> isTraversedBy: aTraverser [
	<generated>
	^ aTraverser traverseCreateNLRFullBlock: self
]

{ #category : #accessing }
SoCreateNonLocalReturnFullBlock >> nlrPhi [
	<generated>
	^ nlrPhi
]

{ #category : #accessing }
SoCreateNonLocalReturnFullBlock >> nlrPhi: aValue [
	<generated>
	nlrPhi := aValue
]
