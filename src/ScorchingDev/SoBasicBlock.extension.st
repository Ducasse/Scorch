Extension { #name : #SoBasicBlock }

{ #category : #'*ScorchingDev' }
SoBasicBlock >> bbNumber [
	^ [ codeNode basicBlocks identityIndexOf: self ]
			on: Error 
			do: [ 0 ]
]

{ #category : #'*ScorchingDev' }
SoBasicBlock >> debugSchedulingChildren [
	^ self instructions
]

{ #category : #'*ScorchingDev' }
SoBasicBlock >> displayStringOn: s [
	s << 'BB ' << self printingNumber.
	[
		s << ' == '.
		self instructionsDo: [ :instr | instr printOn: s ] ] on: Error do: [  ]
]

{ #category : #'*ScorchingDev' }
SoBasicBlock >> gtInspectorSchedulingIn: composite [
	<gtInspectorPresentationOrder: 9>  
	^ composite tree
		rootsExpanded;
		children: [ :each | each debugSchedulingChildren ];
		title: 'Scheduling'.		
]

{ #category : #'*ScorchingDev' }
SoBasicBlock class >> ignoreAccessorNames [
	^ #(firstInstr)
]

{ #category : #'*ScorchingDev' }
SoBasicBlock >> inspectionInstructions [
	<inspectorPresentationOrder: 4 title: 'Instructions'> 

	^ SpTablePresenter new
		items: self instructions;	
		yourself
		
]

{ #category : #'*ScorchingDev' }
SoBasicBlock >> inspectionScheduling [
	<inspectorPresentationOrder: 9 title: 'Scheduling'> 
	
	^ SpTreePresenter new 
			roots: { self };
			expandAll;
			children: [ :each | each debugSchedulingChildren] ;
			yourself
	
]

{ #category : #'*ScorchingDev' }
SoBasicBlock >> instructions [
	| instrs |
	instrs := OrderedCollection new.
	self instructionsDo: [ :instr |
		instrs add: instr ].
	^ instrs
]

{ #category : #'*ScorchingDev' }
SoBasicBlock >> isEqualsTo: anotherBasicBlock [

	^ self class = anotherBasicBlock class 
			and: [ | res | 
					self instructions 
						with: anotherBasicBlock instructions 
						do: [ :inst1 :inst2 | res := inst1 printString = inst2 printString ]. 
					res ]
]

{ #category : #'*ScorchingDev' }
SoBasicBlock >> printOn: s [
	s << 'BasicBlock ' << self printingNumber
]

{ #category : #'*ScorchingDev' }
SoBasicBlock >> printingNumber [
	^ [ (codeNode basicBlocks identityIndexOf: self) printString ]
			on: Error 
			do: [ '?' ]
]
