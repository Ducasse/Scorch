"
I set correctly the dominators to the basicBlocks. It implements a traditional (iterative) algorithm often described in books as

Initialization

n := |N| -1
Dom(0) := {0}
for i (1 to n)
	Dom (i) = N
	
Iteration

change := true
while (changed)
    changed := false.
    for i (1 to n)
		tmp := {i} Union (Intersection  Dom (j) where i belong to predecessors of i)
		if tmpe /= Dom (i) then
				Dom (i) := temp
				changed := true	


Original comment was: ""This algorithm was ported from a C implementation. 
This algorithm is simple therefore it is slow for large CFG. For large CFG one would need to implement the Lengauer-Tarjan algorithm"" or others (see ""A simple fast dominance algorithm"" article). 
However, as the size of the CFG is usually limited, it's usually good enough.


## Implementation
The implementation was on purpose rewritten using optimized constructs (`to:do:`) instead of `do:`, because 20% of the time (of the whole optimizer) was spent in `SequenceableCollection>>#do:` and this algorithm is performance critical. 
The variables are declared outside of loops because it avoids the push nil at each iteration.
`tempData` of a basic block is used to number the basic blocks: see `SoFindDominators>>#setBasicBlockNumbers:`.

It is composed of 2 passes:
- pass 1 (`computeDominators:`) computes all the dominators of each basicblock.
- pass 2 (`computeImmediateDominators:`) computes the immediate dominator out of the dominators found in pass 1.

Assumes that the given basic blocks are in pre order traversal for efficiency, though it works in any case.

	dominators	<Collection of Collection of basicBlocks> at the depthFirstOrder of each basic block a collection of its dominators is stored.
"
Class {
	#name : #SoFindDominators,
	#superclass : #SoAbstractDominators,
	#instVars : [
		'dominators'
	],
	#category : #'Scorching-Pass-Utils'
}

{ #category : #private }
SoFindDominators >> computeDominators: blocks [
	
	| change tmpSet block preds |
	
	"initialization"
	change := true.
	dominators := Array new: blocks size.
	dominators at: 1 put: blocks first asOrderedCollection.
	2 to: blocks size do: [ :i |
		dominators at: (blocks at: i) tempData put: (OrderedCollection withAll: blocks) ].
	
	"set allows faster intersection: and allows one to write add: instead of union: in our case"
	tmpSet := blocks asSet.
	[change] whileTrue: [ 
		change := false.
		2 to: blocks size do: [ :i |
			block := blocks at: i.
			tmpSet := tmpSet copy. 
			preds := block predecessors.
			1 to: preds size do: [ :j |
				tmpSet := tmpSet intersection: (dominators at: (preds at: j) tempData) ].
			tmpSet add: block.
			tmpSet = (dominators at: block tempData) ifFalse: [ 
				change := true.
				dominators at: block tempData put: tmpSet ].
		]
	 ].
]

{ #category : #private }
SoFindDominators >> computeImmediateDominators: blocks [
	"Precondition: computeDominators: already run."
	
	| toRemove iterator theDom |
	
	1 to: blocks size do: [ :i |
		iterator := dominators at: i.
		iterator remove: (blocks at: i).
		dominators at: i put: iterator asOrderedCollection ].
	
	toRemove := OrderedCollection new.
	
	2 to: blocks size do: [ :j |
		toRemove reset.
		iterator := dominators at: (blocks at: j) tempData.
		1 to: iterator size do: [ :s |
			1 to: iterator size do: [ :t |
				t == s ifFalse: [
					theDom := iterator at: t.
					((dominators at: (iterator at: s) tempData) includes: theDom) 
						ifTrue: [ toRemove add: theDom ] ] ] ].
		1 to: toRemove size do: [ :v |
			iterator remove: (toRemove at: v) ifAbsent: nil ] ].
	
	2 to: blocks size do: [ :k |
		iterator := blocks at: k.
		iterator dominator: (dominators at: iterator tempData) first ]
	
]

{ #category : #accessing }
SoFindDominators >> dominators [
	
	^ dominators
]

{ #category : #accessing }
SoFindDominators >> dominators: aValue [

	dominators := aValue
]

{ #category : #public }
SoFindDominators >> findDominators: basicBlocks [

	self setBasicBlockNumbers: basicBlocks.
	self computeDominators: basicBlocks.
	self computeImmediateDominators: basicBlocks.
	
]

{ #category : #private }
SoFindDominators >> setBasicBlockNumbers: basicBlocks [
	"Number the basic blocks according to their position in the basicBlock collection."
	
	1 to: basicBlocks size do: [ :i |
		(basicBlocks at: i) tempData: i ]
]
