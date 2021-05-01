"
I scan blocks to know if there is a NLR (non-local return). 

hasNLR <Boolean>
"
Class {
	#name : #SoBlockNonLocalReturnScanner,
	#superclass : #SoAbstractScanner,
	#instVars : [
		'hasNonLocalReturn'
	],
	#category : #'Scorching-Decompiler'
}

{ #category : #public }
SoBlockNonLocalReturnScanner class >> scan: compiledCode [
	^ (self on: compiledCode) scan
]

{ #category : #accessing }
SoBlockNonLocalReturnScanner >> hasNonLocalReturn [
	<generated>
	^ hasNonLocalReturn
]

{ #category : #accessing }
SoBlockNonLocalReturnScanner >> hasNonLocalReturn: aBoolean [

	hasNonLocalReturn := aBoolean
]

{ #category : #initialization }
SoBlockNonLocalReturnScanner >> initialize [

	super initialize.
	hasNonLocalReturn := false.
]

{ #category : #'opcodes-control flow' }
SoBlockNonLocalReturnScanner >> methodReturnConstant: value [ 
	hasNonLocalReturn := true.
]

{ #category : #'opcodes-control flow' }
SoBlockNonLocalReturnScanner >> methodReturnReceiver [
	hasNonLocalReturn := true.
]

{ #category : #'opcodes-control flow' }
SoBlockNonLocalReturnScanner >> methodReturnTop [
	hasNonLocalReturn := true.
]

{ #category : #'opcodes-control flow' }
SoBlockNonLocalReturnScanner >> pushFullClosure: compiledBlock numCopied: numCopied receiverOnStack: recOnStack ignoreOuterContext: ignoreOuterContext [
	"For NLRs nested in closures"
	hasNonLocalReturn ifFalse: [ hasNonLocalReturn := SoBlockNonLocalReturnScanner scan: compiledBlock  ]
]

{ #category : #public }
SoBlockNonLocalReturnScanner >> scan [
	self interpret.
	^ hasNonLocalReturn
]
