"
I set correctly the dominators to the basicBlocks. 

Original comment was: ""This algorithm was ported from a C implementation. 
This algorithm is simple therefore it is slow for large CFG. For large CFG one would need to implement the Lengauer-Tarjan algorithm""


A traditional (iterative) algorithm is described in books as the following. 
page 479-480 of ""Engineering a compiler"". An alternative implementation  is described ""A simple fast dominance algorithm"" article, p 532 of the same book. 

```
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
```


## Implementation
The implementation was on purpose rewritten using optimized constructs (`to:do:`) instead of `do:`, because 20% of the time (of the whole optimizer) was spent in `SequenceableCollection>>#do:` and this algorithm is performance critical. 
The variables are declared outside of loops because it avoids the push nil at each iteration.
`tempData` of a basic block is used to number the basic blocks: see `SoFindDominators>>#setBasicBlockNumbers:`.

It is composed of 2 passes:
- pass 1 (`computeDominators:`) computes all the dominators of each basicblock.
- pass 2 (`computeImmediateDominators:`) computes the immediate dominator out of the dominators found in pass 1.

Assumes that the given basic blocks are linearised in pre order traversal for efficiency. A non-preorder linearisation breaks this algorithm and yields incorrect results.

	dominators	<Collection of Collection of basicBlocks> at the depthFirstOrder of each basic block a collection of its dominators is stored.
"
Class {
	#name : #SoSimpleFindDominators,
	#superclass : #SoAbstractDominators,
	#instVars : [
		'dominators'
	],
	#category : #'Scorching-Pass-Utils'
}

{ #category : #private }
SoSimpleFindDominators >> computeDominators: blocks [
	
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
SoSimpleFindDominators >> computeImmediateDominators: blocks [
	"Precondition: computeDominators: already run."
	
	| toRemove theDom |
	1 to: blocks size do: [ :i |
		| dominatorList |
		dominatorList := dominators at: i.
		dominatorList remove: (blocks at: i).
		dominators at: i put: dominatorList asOrderedCollection ].
	
	toRemove := OrderedCollection new.
	
	1 to: blocks size do: [ :j |
		| dominatorList |
		toRemove reset.
		dominatorList := dominators at: (blocks at: j) tempData.
		1 to: dominatorList size do: [ :s |
			1 to: dominatorList size do: [ :t |
				t == s ifFalse: [
					theDom := dominatorList at: t.
					((dominators at: (dominatorList at: s) tempData) includes: theDom) 
						ifTrue: [ toRemove add: theDom ] ] ] ].
		1 to: toRemove size do: [ :v |
			dominatorList remove: (toRemove at: v) ifAbsent: nil ] ].
	
	1 to: blocks size do: [ :k |
		| basicBlock |
		basicBlock := blocks at: k.
		(dominators at: basicBlock tempData) ifNotEmpty: [
			basicBlock dominator: (dominators at: basicBlock tempData) first ] ]
]

{ #category : #accessing }
SoSimpleFindDominators >> dominators [
	
	^ dominators
]

{ #category : #accessing }
SoSimpleFindDominators >> dominators: aValue [

	dominators := aValue
]

{ #category : #accessing }
SoSimpleFindDominators >> dominatorsOf: aSoBasicBlock [ 
	
	^ dominators at: aSoBasicBlock tempData
]

{ #category : #public }
SoSimpleFindDominators >> findDominators: basicBlocks [

	self numberBasicBlocks: basicBlocks.
	self computeDominators: basicBlocks.
	self computeImmediateDominators: basicBlocks.
	
]

{ #category : #private }
SoSimpleFindDominators >> numberBasicBlocks: basicBlocks [
	"Number the basic blocks according to their position in the basicBlock collection."
	
	1 to: basicBlocks size do: [ :i |
		(basicBlocks at: i) tempData: i ]
]

{ #category : #testing }
SoSimpleFindDominators >> supportsRandomBlockOrder [
	
	^ false
]
