extends MeshInstance3D

@export var dialogue_sequence: DialogueSequence

func interact():
	var director = get_tree().get_first_node_in_group("DialogueDirector")
	director.start_dialogue(dialogue_sequence)
