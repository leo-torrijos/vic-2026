extends Node

var total_suspicion = 0.0
var current_level_director

func add_suspicion(amount):
	total_suspicion += amount
	current_level_director.update_suspicion_ui(total_suspicion)
