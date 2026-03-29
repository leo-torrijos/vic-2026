extends Node3D
class_name Pills


var poisoned = false


func poison():
	poisoned = true
	$InteractTrigger.interaction_type = ""
	$InteractTrigger.inspection_name = "poisoned_pills"
	print("poisoned!")
