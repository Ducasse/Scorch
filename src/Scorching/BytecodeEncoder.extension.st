Extension { #name : #BytecodeEncoder }

{ #category : #'*Scorching' }
BytecodeEncoder >> bytecodes [
	^ stream contents
]

{ #category : #'*Scorching' }
BytecodeEncoder >> sizeBranchIfInstanceOf: behaviors distance: distance [
	^self sizeOpcodeSelector: #genBranchIfInstanceOf:distance: withArguments: {behaviors.distance}
	
]

{ #category : #'*Scorching' }
BytecodeEncoder >> sizeBranchIfNotInstanceOf: behaviors distance: distance [
	^self sizeOpcodeSelector: #genBranchIfNotInstanceOf:distance: withArguments: {behaviors.distance}
]
