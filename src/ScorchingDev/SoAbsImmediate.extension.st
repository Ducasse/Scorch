Extension { #name : #SoAbsImmediate }

{ #category : #'*ScorchingDev' }
SoAbsImmediate >> gtInspectorInstructionsIn: composite [
	<gtInspectorPresentationOrder: 6> 
	composite table 
		title: 'Instr'; "Instructions"
		display: self printString
]

{ #category : #'*ScorchingDev' }
SoAbsImmediate >> inspectionInstructions [
	<inspectorPresentationOrder: 6 title: 'Instr'> 
		
	^ SpTextPresenter new 
		text: self printString;
		yourself
]

{ #category : #'*ScorchingDev' }
SoAbsImmediate >> printOn: s [
	^ self shortPrintOn: s 
]
