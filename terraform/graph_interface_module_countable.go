package terraform

// GraphNodeModuleCountable is an interface that must be implemented by
// anything that can be duplicated due to a parent module count.
type GraphNodeModuleCountable interface {
	// ModuleCount retrieves the value set earlier by SetModuleCount.
	// SetModuleCount sets the module count value. This will always be
	// called by some outside process. If this isn't set, the count
	// should be assumed to be 1 as a default.
	ModuleCount() int
	SetModuleCount(int)
}
