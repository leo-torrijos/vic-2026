extends Area3D

class_name InteractTrigger

var inspectable = true

# VALID INPUTS:
# none
# clean
# pickup
# kill
# put_in_holder
# take_from_holder
# stall
## What type of interaction this is to query crosshair changes. Example: "clean" will show a cleaning icon. See script for valid inputs.
@export var interaction_type = ""
## Special string passed to the player on inspection for certain relevant objects. If left blank, InspectHandler will use interaction_type instead.
@export var inspection_name = ""
