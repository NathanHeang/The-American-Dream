extends Control
class_name ComputerUI

@onready var window_buttons: HBoxContainer = %WindowButtons
@onready var window_container: Panel = %WindowContainer
@onready var window_title: Label = %WindowTitle

@onready var text_input: CodeEdit = %TextInput
@onready var text_goal: CodeEdit = %TextGoal

func _ready() -> void:
	for button:WindowButton in window_buttons.get_children():
		button.button_down.connect(func ():
			var pre_visible = button.window.visible
			for window in window_container.get_children():
				window.visible = false
			button.window.visible = not pre_visible
			window_title.text = button.window.title
			)

func toggle(state = null)->void:
	visible = state if state else not visible
	System.mouse_mode = Input.MOUSE_MODE_HIDDEN if visible else Input.MOUSE_MODE_CAPTURED
	var plr:Player = get_tree().get_first_node_in_group("plr")
	plr.controllable = not visible
	var interface = get_tree().get_first_node_in_group("interface")
	if interface:
		var balance_ui = interface.get_node("%Balance")
		if balance_ui:
			(balance_ui as Control).visible = not visible
			
var last_match = -1
var dictionary = [
	"abcdefg",
	"apple",
	"code",
	"program",
	"execute",
	"function",
	"class",
	"king",
	"ball",
	"project",
	"python",
	"end",
	"loop",
	"for",
	"var",
	"=",
	"."
]
func randomize_goal()->void:
	var goal = ""
	for i in range(randi_range(10, 50)):
		goal += dictionary[randi_range(0, dictionary.size()-1)] + " "
	text_input.text = ""
	text_goal.text = goal
	last_match = -1

func _on_input_text_changed() -> void:
	var a = text_input.text.strip_edges()
	var b = text_goal.text.strip_edges()
	var new_last_match = -1
	var min_len:int = min(a.length(), b.length())
	for i in range(min_len):
		if a[i] == b[i]:
			new_last_match = i
		else:
			break
	if new_last_match > last_match:
		System.money += (new_last_match - last_match)
		last_match = new_last_match
	if a == b:
		randomize_goal()
