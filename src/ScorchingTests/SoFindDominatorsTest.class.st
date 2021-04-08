Class {
	#name : #SoFindDominatorsTest,
	#superclass : #SoPassTest,
	#category : #'ScorchingTests-NewUnit'
}

{ #category : #running }
SoFindDominatorsTest >> passClass [

	^ SoFindDominators 
]

{ #category : #running }
SoFindDominatorsTest >> testSimpleCollection [

	| reorderedMethod basicBlocks |

"Preds: #(). 
[1.1] Gbl:OrderedCollection.
[1.2] (S)  [1.1] new.
[1.3] (S)  100 atRandom.
[1.4] (S)  loopHead.
[1.5] goTo: 2.

Preds: #(1 5). 
[2.1] phi: [1.2]'1 [5.1]'5 .
[2.2] phi: [1.3]'1 [5.2]'5 .
[2.3] phi: 1'1 [5.4]'5 .
[2.4] (S)  [2.3] <= [2.2].
[2.5] (S)  [2.4] ifTrue: 3 ifFalse: 7.

Preds: #(2). 
[3.1] (S)  [2.3] \\ 11.
[3.2] (S)  [3.1] = 0.
[3.3] (S)  [3.2] ifTrue: 4 ifFalse: 6.

Preds: #(3). 
[4.1] (S)  [2.3] asFloat.
[4.2] (S)  [2.3] asFloat.
[4.3] {[4.1] . [4.2]}.
[4.4] (S)  [2.1] add: [4.3].
[4.5] goTo: 5.

Preds: #(4 6). 
[5.1] phi: [2.1]'6 [2.1]'4 .
[5.2] phi: [2.2]'6 [2.2]'4 .
[5.3] phi: [2.3]'6 [2.3]'4 .
[5.4] (S)  [5.3] + 1.
[5.5] (S)  backTo: 2.

Preds: #(3). 
[6.1] goTo: 5.

Preds: #(2). 
[7.1] ^ [2.1].
"
	
"        1   
			|
			2 _____ 7 
			|   
			3    
		/		\  
		4		6   
		 \    /   
		   \ 	/   
			   5
			
			"	

	reorderedMethod := self runFor: (SoExamples>> #simpleCollection).
	basicBlocks := reorderedMethod basicBlocks.
	self assert: basicBlocks first dominator isNil.
	
	self assert: basicBlocks second dominator bbNumber equals: 1.
	self assert: basicBlocks third dominator bbNumber equals: 2.
	self assert: basicBlocks fourth dominator bbNumber equals: 3.
	self assert: basicBlocks sixth dominator bbNumber equals: 3.
	self assert: basicBlocks fifth dominator bbNumber equals: 3.
	self assert: basicBlocks seventh dominator bbNumber equals: 2.



]
