extends Button
class_name Email

@onready var sender_label: Label = $Sender
@onready var time_label: Label = $Time
@export var title:StringName = "New Mail"
@export var description:String = "Empty Mail"
@export var img:Texture2D
@export var is_ransom:bool = false

func _ready() -> void:
	time_label.text = System.time_string

func _process(_dt: float) -> void:
	pass

func _on_button_down() -> void:
	pass
