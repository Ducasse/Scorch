"
I reorder the basicblocks of a `SoMethod` for data optimizations and bytecode generation.
I modify in place the soMethod that I reorganize. I do not add or eliminate any basic blocks. In addition assign a postOrder value to the basic I treat.


The original comment states: ""This is a postOrderTraversal, but in addition, loop bodies are kept contiguous."" However, basic blocks are treated as they come with pending successors added in as first entities in a worklist.


## Implementation

- `basicBlocksOrdered` <Collection of BasicBlock> the basicBlocks of the codeNode in the right order that will be set to the codeNode once the pass has been run.
- `workList` <Collection of BasicBlock> the basicBlocks that need to be processed by the algorithm (the graph is traversed in control flow order).
- `loops`  <Collection of BasicBlock> keeps a list of basic blocks.

## Reminder

Just to remember postd order is the following and this is not what we are doing. 
postOrder traversal is (Left, Right, Root) : 4 5 2 3 1
```
		 1	
	 /	 \
	2		  3
/  \
4	  5
```
"
Class {
	#name : #SoReorderBasicBlocks,
	#superclass : #Object,
	#instVars : [
		'basicBlocksOrdered',
		'workList',
		'loops'
	],
	#category : #'Scorching-Pass-Utils'
}

{ #category : #accessing }
SoReorderBasicBlocks >> basicBlocksOrdered [

	^ basicBlocksOrdered
]

{ #category : #accessing }
SoReorderBasicBlocks >> basicBlocksOrdered: aValue [

	basicBlocksOrdered := aValue
]

{ #category : #private }
SoReorderBasicBlocks >> canExecute: basicBlock [
	"If all the predecessors have been handled, and basicBlock is currently on loops then it is ok to handle it."
	self flag: #todo. "rename me"
	
	^ (basicBlock forwardPredecessors allSatisfy: [ :bb | basicBlocksOrdered includes: bb ])
		and: [ loops isEmpty 
			or: [ loops last includes: basicBlock ] ]
]

{ #category : #private }
SoReorderBasicBlocks >> computeNextBlockToVisit: aBasicBlock [
	"If the arg does not have successors, then pick a branch.
	Before adding aBasicBlock successors to the workList, add the basicBlock to the list of loops target if necessary."

	aBasicBlock successors 
		ifEmpty: [ ^ self restartFromBranch ].
	aBasicBlock hasBackwardPredecessor 
		ifTrue: [ self setLoops: aBasicBlock ].
	workList addAllFirst: aBasicBlock successors.
	self restartFromBranch
]

{ #category : #initialization }
SoReorderBasicBlocks >> initialize [

	super initialize.
	basicBlocksOrdered := OrderedCollection new.
	workList := OrderedCollection new.
	loops := OrderedCollection new.
]

{ #category : #accessing }
SoReorderBasicBlocks >> loops [
	<generated>
	^ loops
]

{ #category : #accessing }
SoReorderBasicBlocks >> loops: aValue [
	<generated>
	loops := aValue
]

{ #category : #private }
SoReorderBasicBlocks >> nextBasicBlockToProcess [
	"Find a basicblock in the workList which has all its non-back jump 
	predecessors processed. Restart bytecode generation form there."
	
	^ workList 
		detect: [ :basicBlock | self canExecute: basicBlock ] 
		ifFound: [ :elem | elem ]
		ifNone: nil "infinite loop"
]

{ #category : #private }
SoReorderBasicBlocks >> pendingBlocksFromBackJump: backJump to: basicBlock [
	"Compute all the blocks from backJump to basicBlock following predecessors."
	
	| trace workList1 top |
	trace := OrderedCollection new.
	workList1 := OrderedCollection with: backJump.
	[ workList1 isEmpty ] whileFalse: [ 
		top := workList1 removeLast.
		(trace includes: top) ifFalse: [ 
			trace add: top.
			top == basicBlock ifFalse: [ workList1 addAll: top predecessors ] ]  ].
	^ trace
]

{ #category : #private }
SoReorderBasicBlocks >> popFromLoops: aBasicBlock [
	"Remove the argument from all the loop bodies."
	
	loops do: [ :each |
		each remove: aBasicBlock ].
	[ loops isEmpty ifTrue: [ ^ self ]. 
	loops last isEmpty ] whileTrue: [ 
		loops removeLast ].
]

{ #category : #public }
SoReorderBasicBlocks >> reorderBasicBlocks: codeNode [
	"I'm the main entry of the class. codeNode is a soMethod, i.e. a method containing basic blocks.
	My arg (its basicblocks) gets modified in place."
	 	
	self traverseBasicBlock: codeNode basicBlocks first.
	codeNode basicBlocks: basicBlocksOrdered.

]

{ #category : #private }
SoReorderBasicBlocks >> restartFromBranch [
	"Check if there is basicBlock to handle (held in worklist), in that case identify the next one, remove it from the work list and handle it."
	
	| basicBlock |
	workList ifEmpty: [ ^ self ].
	basicBlock := self nextBasicBlockToProcess.
	basicBlock ifNil: [ ^ self ].
	workList remove: basicBlock.
	self traverseBasicBlock: basicBlock.
	
]

{ #category : #public }
SoReorderBasicBlocks >> runOn: codeNode [
	self reorderBasicBlocks: codeNode
]

{ #category : #private }
SoReorderBasicBlocks >> setLoops: basicBlock [
	"Put as block that should be treated as part of a loop, the blocks that are predecessors of backjump to the argument and that are not already handled."
	
	| trace |
	trace := (self pendingBlocksFromBackJump: basicBlock backwardPredecessor to: basicBlock) asSet.
	basicBlocksOrdered do: [ :bb | 
		trace remove: bb ifAbsent: [] ].
	trace ifEmpty: [ ^ self ].
	loops add: trace. 
]

{ #category : #visiting }
SoReorderBasicBlocks >> traverseBasicBlock: basicBlock [
	
	(basicBlocksOrdered includes: basicBlock) 
		ifTrue: [ ^ self restartFromBranch ].
	self popFromLoops: basicBlock.
	basicBlocksOrdered add: basicBlock.
	basicBlock postOrder: basicBlocksOrdered size.
	self computeNextBlockToVisit: basicBlock.
]

{ #category : #accessing }
SoReorderBasicBlocks >> workList [
	
	^ workList
]

{ #category : #accessing }
SoReorderBasicBlocks >> workList: aValue [

	workList := aValue
]
