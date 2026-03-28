extends Area3D

class_name InteractTrigger

# VALID INPUTS:
# inspect
# clean
# pickup
# kill
# put_in_holder
# take_from_holder
# stall
## What type of interaction this is to query crosshair changes. Example: "clean" will show a cleaning icon. See script for valid inputs.
@export var interaction_type = ""
