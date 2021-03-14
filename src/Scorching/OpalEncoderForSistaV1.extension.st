Extension { #name : #OpalEncoderForSistaV1 }

{ #category : #'*Scorching' }
OpalEncoderForSistaV1 >> genBranchIfInstanceOf: literalIndex distance: distance [
	self genBranchIfInstanceOf: literalIndex distance: distance orNot: false
]

{ #category : #'*Scorching' }
OpalEncoderForSistaV1 >> genBranchIfInstanceOf: literalIndex distance: distance orNot: orNot [
	"254		11111110	kkkkkkkk	jjjjjjjj		branch If Not Instance Of Behavior/Array Of Behavior kkkkkkkk (+ Extend A * 256, where Extend A >= 0) distance jjjjjjjj (+ Extend B * 256, where Extend B >= 0)"
							
	| extendedIndex extendedDistance |
	(literalIndex < 0 or: [literalIndex > 65535]) ifTrue:
		[^self outOfRangeError: 'index' index: literalIndex range: 0 to: 65536].
	(distance < 1 or: [distance > 32767]) ifTrue: 
		[^self outOfRangeError: 'distance' index: distance range: 0 to: 32767].
	(extendedIndex := literalIndex) > 255 ifTrue:
		[self genUnsignedSingleExtendA: extendedIndex // 256.
		 extendedIndex := extendedIndex \\ 256].
	(orNot not or: [(extendedDistance := distance) > 255]) ifTrue:
		[self genUnsignedSingleExtendB: (distance bitShift: -8) + (orNot not asBit  * 128).
		extendedDistance := distance bitAnd: 255].
	
	stream
		nextPut: 254;
		nextPut: extendedIndex;
		nextPut: extendedDistance
]

{ #category : #'*Scorching' }
OpalEncoderForSistaV1 >> genBranchIfNotInstanceOf: literalIndex distance: distance [
	self genBranchIfInstanceOf: literalIndex distance: distance orNot: true
]

{ #category : #'*Scorching' }
OpalEncoderForSistaV1 >> genEnsureAllocatableSlots: int [
	stream
		nextPut: 236;
		nextPut: int
]

{ #category : #'*Scorching' }
OpalEncoderForSistaV1 class >> isReturnByte: byte [
	^ byte between: 88 and: 94
]

{ #category : #'*Scorching' }
OpalEncoderForSistaV1 class >> returnSelfByte [
	^ 88
]
