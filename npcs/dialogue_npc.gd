extends NPC
class_name DialogueNPC

@export var dialogues:Array[Dialogue]
@export var loop:bool = true
var current_id = 0

func _on_interactable_component_interacted() -> void:
	if dialogues.size() == 0: return
	(Hud.get_node("DialogueHandler") as DialogueHandler).begin(dialogues[current_id])
	if current_id >= dialogues.size()-1:
		if loop:
			current_id = 0
	else:
		current_id+=1
