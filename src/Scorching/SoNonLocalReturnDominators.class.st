"
This pass sets the dominators of each basicBlock. On the contrary to findDominators,  which computes the immediate dominator for each basicblock, this pass just sets the entry as dominating all the basicBlocks. 

This class is used when inlining a method/block with a non-local return, because the dominator tree can only be partially computed at this point (a message send can have 2 exits if the non-local return is evaluated ).

The pass is correct, as the entry always dominates all the basicblocks, but does not compute the best possible dominator tree. Typically, if the non-local return is inlined, the dominator tree is recomputed afterwards.
"
Class {
	#name : #SoNonLocalReturnDominators,
	#superclass : #SoAbstractDominators,
	#category : #'Scorching-Pass-Utils'
}

{ #category : #public }
SoNonLocalReturnDominators >> findDominators: basicBlocks [
	basicBlocks allButFirstDo: [ :bb | 
		bb dominator: basicBlocks first ]
]
