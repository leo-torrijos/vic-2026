extends Node3D


## List of previously inspected objects, used for dialogue with cops in the investigation phase
var inspected_list = []


func inspect(interact: InteractTrigger):
	if interact.inspection_name:
		inspected_list.push(interact.inspection_name)
		# Unique voicelines?
		match interact.inspection_name:
			pass
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
