"
I provide an API to build basic blocks and instructions.

Instance Variables
	codeNode:		<AbsCode>
	currentBasicBlock:		<BasicBlock> BasicBlock I am adding instruction to while building instructions.
	returnBasicBlock <BasicBlock> basicblock created specifically to hold the unique return instruction of the method.
	currentInstr: <Instruction> last instruction I added or nil if the currentBasicBlock has no instructions. 

"
Class {
	#name : #SoBuilder,
	#superclass : #Object,
	#instVars : [
		'codeNode',
		'currentBasicBlock',
		'returnBasicBlock',
		'currentInstr'
	],
	#category : #'Scorching-Decompiler'
}

{ #category : #'instance creation' }
SoBuilder class >> on: codeNodeClass [
	^ self basicNew
		codeNode: codeNodeClass new;
		initialize;
		yourself
]

{ #category : #'adding instructions' }
SoBuilder >> addCFGInstr: instr [
	currentBasicBlock lastInstr: instr.
	^ self addInstruction: instr
]

{ #category : #building }
SoBuilder >> addFakeConstant: cst fakeBasicBlock: bb [
	returnBasicBlock firstInstruction addInput: cst basicBlock: bb.
]

{ #category : #'adding instructions' }
SoBuilder >> addInstruction: instr [
	"Insert the instruction after existing ones, or as first instruction of the current block."
	
	currentInstr 
		ifNotNil: [ currentInstr nextInstruction: instr ]
		ifNil: [ currentBasicBlock firstInstruction: instr ].
	^ currentInstr := instr
]

{ #category : #'building-immediate' }
SoBuilder >> arg: index [
	"Return an SoArg instance of given index."
	
	^ SoArg new 
		index: index;
		yourself
]

{ #category : #building }
SoBuilder >> array: values [
	^ self addInstruction: (SoCreateArray new values: values; yourself)
]

{ #category : #building }
SoBuilder >> backjump: basicBlock [
	^  self addCFGInstr: (SoBackjump 
		from: currentBasicBlock
		to: basicBlock)
]

{ #category : #accessing }
SoBuilder >> branch: expression [

	^ self addCFGInstr: (SoBooleanBranch new 
		expression: expression;
		yourself)
]

{ #category : #accessing }
SoBuilder >> codeNode [
	<generated>
	^ codeNode
]

{ #category : #accessing }
SoBuilder >> codeNode: aValue [
	
	codeNode := aValue
]

{ #category : #'building-immediate' }
SoBuilder >> constant: cst [
	^ SoConstant new 
		constant: cst;
		yourself
]

{ #category : #building }
SoBuilder >> context [
	self flag: #TODO.
	^ SoConstant new constant: #thisContext; yourself
]

{ #category : #building }
SoBuilder >> contextInstVar: index of: object [
	^ self addInstruction: (SoContextInstVar new
		index: index;
		object: object;
		yourself)
]

{ #category : #building }
SoBuilder >> createTempVector: size [
	^ self addInstruction: (SoCreateTempVect new
		vectorSize: size;
		yourself)
]

{ #category : #accessing }
SoBuilder >> currentBasicBlock [

	^ currentBasicBlock
]

{ #category : #accessing }
SoBuilder >> currentBasicBlock: aValue [
	
	currentBasicBlock := aValue
]

{ #category : #accessing }
SoBuilder >> currentInstruction [

	^ currentInstr
]

{ #category : #accessing }
SoBuilder >> currentInstruction: anInstruction [

	currentInstr := anInstruction
]

{ #category : #decompilation }
SoBuilder >> fillPhi: firstPhi withValues: predecessors [ 
	| instr index |
	instr := firstPhi.
	index := 1.
	[ instr notNil and: [ instr isPhi ] ] whileTrue: [ 
		[ predecessors allSatisfy: [ :pred | (pred tempData at: index) isTempVector ] 
			] whileTrue: [ index := index + 1 ]. "no phis for temp vectors"
		predecessors do: [ :pred | instr addInput: (pred tempData at: index) basicBlock: pred ].
		index := index + 1.
		instr := instr nextInstruction ].
]

{ #category : #building }
SoBuilder >> fullBlock: compiledBlock receiver: rcvr copiedValues: copiedValues class: closureClass [
	^ self addInstruction: (closureClass new
		values: copiedValues;
		receiver: rcvr;
		compiledCode: compiledBlock;
		yourself)
	
]

{ #category : #building }
SoBuilder >> global: assoc [
	^ self addInstruction: (SoGlobal new
		assoc: assoc;
		yourself)
]

{ #category : #building }
SoBuilder >> indirectTemp: remoteTempIndex vector: varHolder [
	^ self addInstruction: (SoRemoteTemp new
		remoteIndex: remoteTempIndex;
		tempVector: varHolder;
		yourself)
]

{ #category : #initialization }
SoBuilder >> initialize [

	super initialize.

	"build the last basicBlock"
	currentBasicBlock := returnBasicBlock := SoBasicBlock new.
	self return: self phi level: codeNode returnToSenderLevel.

	"superBB entry"
	self switchToBasicBlock: SoBasicBlock new.
]

{ #category : #building }
SoBuilder >> instVar: index of: object [
	^ self addInstruction: (SoInstVar new
		index: index;
		object: object;
		yourself)
]

{ #category : #building }
SoBuilder >> jump: basicBlock [
	^  self addCFGInstr: (SoJumpAhead from: currentBasicBlock to: basicBlock)
]

{ #category : #building }
SoBuilder >> localReturn: instr [
	returnBasicBlock firstInstruction addInput: instr basicBlock: currentBasicBlock.
	self jump: returnBasicBlock.
]

{ #category : #building }
SoBuilder >> loopHead [
	^ self addInstruction: SoLoopHead new
]

{ #category : #building }
SoBuilder >> mutableLiteral: lit [
	^ self addInstruction: (SoMutableLiteral new
		literal: lit;
		yourself)
]

{ #category : #building }
SoBuilder >> nonLocalReturn: value [
	^  self addCFGInstr: (SoReturn new
		returnedValue: value;
		numLevels: 2;
		yourself)
]

{ #category : #building }
SoBuilder >> phi [
	^ self addInstruction: SoPhi new
]

{ #category : #building }
SoBuilder >> pointerEquals: rcvr with: arg [
	^ self addInstruction: (SoPointerEqualsOp 
		withReceiver: rcvr
		arguments: {arg})
]

{ #category : #'building-immediate' }
SoBuilder >> receiver [
	"Return an SoReceiver instance."
	
	^ SoReceiver new
]

{ #category : #initialization }
SoBuilder >> return: instr level: level [
	^ self addCFGInstr: (SoReturn new
		returnedValue: instr;
		numLevels: level;
		yourself)
]

{ #category : #accessing }
SoBuilder >> returnBasicBlock [

	^ returnBasicBlock
]

{ #category : #accessing }
SoBuilder >> returnBasicBlock: aValue [

	returnBasicBlock := aValue
]

{ #category : #accessing }
SoBuilder >> returnPhi [

	^ returnBasicBlock firstInstruction
]

{ #category : #decompilation }
SoBuilder >> saveLiveVariables: array [
	currentBasicBlock tempData: array
]

{ #category : #building }
SoBuilder >> send: selector receiver: rcvr args: args [
	^ self addInstruction: (SoSend new 	
		receiver: rcvr;
		arguments: args;
		selector: selector;
		yourself)
]

{ #category : #building }
SoBuilder >> store: val contextInstVar: index of: object [
	^ self addInstruction: (SoContextInstVar new
		index: index;
		object: object;
		beWrite;
		expression: val;
		yourself)
]

{ #category : #building }
SoBuilder >> store: val global: assoc [
	^ self addInstruction: (SoGlobal new 
		assoc: assoc;
		beWrite;
		expression: val;
		yourself)
]

{ #category : #building }
SoBuilder >> store: val indirectTemp: remoteTempIndex vector: varHolder [
	^ self addInstruction: (SoRemoteTemp new
		remoteIndex: remoteTempIndex;
		tempVector: varHolder;
		beWrite;
		expression: val;
		yourself)
]

{ #category : #building }
SoBuilder >> store: val instVar: index of: object [
	^ self addInstruction: (SoInstVar new
		index: index;
		object: object;
		beWrite;
		expression: val;
		yourself)
]

{ #category : #decompilation }
SoBuilder >> switchBackToBasicBlock: basicBlock [
	codeNode basicBlocks removeLast.
	currentBasicBlock := basicBlock.
	currentInstr := basicBlock lastInstr prevInstr.
	basicBlock lastInstr: nil.
]

{ #category : #decompilation }
SoBuilder >> switchToBasicBlock: basicBlock [
	currentBasicBlock lastInstr ifNil: [ self jump: basicBlock ].
	currentBasicBlock := basicBlock.
	currentInstr := nil.
	codeNode addBasicBlock: basicBlock
]

{ #category : #decompilation }
SoBuilder >> terminate [
	returnBasicBlock firstInstruction inputs ifEmpty: [ ^ codeNode ].
	codeNode addBasicBlock: returnBasicBlock.
	SoBasicBlockMerger new mergeIntoPredecessorIfPossible: returnBasicBlock.
	^ codeNode  
]
