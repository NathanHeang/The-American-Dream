extends Email
class_name RansomEmail

const RANSOM = preload("res://ransom/ransom.tscn")

func _on_button_down() -> void:
	System.add_child(RANSOM.instantiate())
