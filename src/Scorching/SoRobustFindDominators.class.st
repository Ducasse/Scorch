Class {
	#name : #SoRobustFindDominators,
	#superclass : #SoSimpleFindDominators,
	#category : #'Scorching-Pass-Utils'
}

{ #category : #private }
SoRobustFindDominators >> computeDominators: blocks [
	
	| change block preds |
	
	"initialization"
	change := true.
	dominators := Array new: blocks size.
	1 to: blocks size do: [ :i |
		dominators at: (blocks at: i) tempData put: (Set withAll: blocks) ].
	
	"set allows faster intersection: and allows one to write add: instead of union: in our case"
	[change] whileTrue: [ 
		change := false.
		1 to: blocks size do: [ :i | | tmpSet |
			block := blocks at: i.
			preds := block predecessors.
			preds
				ifEmpty: [ tmpSet := { block } asSet ]
				ifNotEmpty: [ 
					tmpSet := (dominators at: (preds at: 1) tempData) copy.
					2 to: preds size do: [ :j |
						tmpSet := tmpSet intersection: (dominators at: (preds at: j) tempData) ].
					tmpSet add: block.
					tmpSet ].
			tmpSet = (dominators at: block tempData) ifFalse: [ 
				change := true.
				dominators at: block tempData put: tmpSet ].
		]
	 ].
]

{ #category : #testing }
SoRobustFindDominators >> supportsRandomBlockOrder [
	
	^ true
]
