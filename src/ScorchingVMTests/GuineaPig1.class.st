Class {
	#name : #GuineaPig1,
	#superclass : #Object,
	#category : #ScorchingVMTests
}

{ #category : #'as yet unclassified' }
GuineaPig1 >> methodToInstrument [
	"This method is instrumented in the tests. Do *not* edit it.
	
	The instrumentation starts after the last temporary assignment. 
	Temporaries are result of message sends, so they're in registers 
	or spilled on stack, whereas literals are constants.
	 
	Code after the last temporary assignment is here to generate the 
	required literals and to let enough room for instrumentation."
	  
	| t50 t3 tArray tByteArray tLargeArray tLargeByteArray |
	t50 := self get50.
	t3 := self get3.     
	tArray := self getArray.  
	tByteArray := self getByteArray.
	tLargeArray := self getLargeArray.
	tLargeByteArray := self getLargeByteArray.
	5 + 10 + 3 + 50 + #(1 2 3 4 5 6) first + #[1 2 3 4 5 6 7 8 9 10] first. 
	{ $a . $b . $c } yourself.
	tArray copy.
	^ t3 + t50 + t3 + t50 + t3 + t50 + t3 + t50 + t3 + t50 
	
]
