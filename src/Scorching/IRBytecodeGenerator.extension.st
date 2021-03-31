Extension { #name : #IRBytecodeGenerator }

{ #category : #'*Scorching' }
IRBytecodeGenerator >> spurBlockVMHeader: literalsSize [
	^ (CompiledMethod headerFlagForEncoder: self encoderClass) +
		(self numArgs bitShift: 24) +
		( self numTemps bitShift: 18) +
		literalsSize
]
