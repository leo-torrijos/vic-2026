extends Node3D


## List of previously inspected objects, used for dialogue with cops in the investigation phase
var inspected_list = []
var pills_instance : Pills


func inspect(interact: InteractTrigger):
	if interact.inspection_name:
		interact.inspected = true
		inspected_list.push_back(interact.inspection_name)
		# Unique voicelines?
		match interact.inspection_name:
			"pills":
				pills_instance = interact.get_parent()
	else:
		match interact.interaction_type:
			"clean":
				pass  # Generic mess line
			"put_in_holder":
				pass  # Generic container line
			"drag":
				pass  # Generic corpse line
	
	# Prevent further inspection of this object
	interact.inspectable = false
