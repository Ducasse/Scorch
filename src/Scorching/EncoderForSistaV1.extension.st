Extension { #name : #EncoderForSistaV1 }

{ #category : #'*Scorching' }
EncoderForSistaV1 >> genStoreFlagExtensionIgnoreStoreCheck: ignoreStoreCheck maybeContext: maybeContext ignoreReadOnlyCheck: ignoreReadOnlyCheck [
	"ignoreStoreCheck: 
	Can be applied to the long form of store and store pop of literal variable, remote inst var, remote temp, receiver inst var.
	If present, the VM does not generate the GC store check. 
	The main reasons the compiler can ignore the store check are one of these two:
	- the mutated object is always young
	- the object stored is immediate
	Currently the store check is for the remembered table, but we may have it for tri color marking later. So the compiler cannot really remove the store check if the object stored is old.

	maybeContext:
	Can be used only with remote instance variable stores and receiver variable stores. If marked, the object can be a context and hence needs specific VM code. Receiver inst var have a separate encoding, temp vectors and literal variable can't be contexts
	
	ignoreReadOnlyCheck:
	no read-only check will be performed by the VM. Normally each store has a read-only check.
	"
	self genUnsignedSingleExtendB: ignoreStoreCheck asBit + (maybeContext asBit << 1) + (ignoreReadOnlyCheck asBit << 2)
]
