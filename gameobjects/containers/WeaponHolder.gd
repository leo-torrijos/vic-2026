extends Node3D
class_name WeaponHolder


## Pickup placed in the WeaponHolder
var held_object : Pickup = null


func place_object(pickup: Pickup):
	held_object = pickup
	$StoragePoint.add_child(held_object)
	held_object.global_position = $StoragePoint.global_position
	$InteractTrigger.interaction_type = "take_from_holder"


func yield_object():
	$InteractTrigger.interaction_type = "put_in_holder"
	$StoragePoint.remove_child(held_object)
	return held_object.collected_object.instantiate()
