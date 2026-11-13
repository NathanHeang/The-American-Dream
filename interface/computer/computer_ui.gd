extends Control
class_name ComputerUI

const PAPERS = preload("res://objects/prop/papers.tscn")

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
	if state or not visible:
		if System.on_computer:
			return
		System.on_computer = true
	else:
		System.exited_computer.start()
	visible = state if state else not visible
	System.mouse_mode = Input.MOUSE_MODE_HIDDEN if visible else Input.MOUSE_MODE_CAPTURED
	var plr:Player = get_tree().get_first_node_in_group("plr")
	plr.controllable = not visible
	var head:Node3D = plr.get_node("%Head")
	if head:
		head.rotation.x = -90
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
	"int",
	"float",
	"double",
	"string",
	"work",
	"money",
	"computer",
	"mind",
	"system",
	"network",
	"coffee",
	"glass",
	"steel",
	"chair",
	"office",
	"pen",
	"keyboard",
	"mouse",
	"hunger",
	"poor",
	"life",
	"business",
	"cycle",
	"night",
	"day",
	"break",
	"information",
	"technology",
	"elevator",
	"null",
	"dictionary",
	"array",
	"set",
	"lambda",
	"async",
	"annoying dog",
	"america",
	"dream",
	"nightmare",
	"broken",
	"fall",
	"interface",
	"laptop",
	"monitor",
	"intelligence",
	"hierarchy",
	"class",
	"supercalifragilisticexpialidocious",
	"fun",
	"boredom",
	"dread",
	"safety",
	"stability",
	"economy",
	"income",
	"cash",
	"coins",
	"dollars",
	"bank",
	"authority",
	"sudo",
	"cd",
	"mkdir",
	"rm",
	"captcha",
	"bot",
	"artificial",
	"tear",
	"shred",
	"note",
	"meeting",
	"digital",
	"screen",
	"escape",
	"ternary",
	"addition",
	"subtraction",
	"comparison",
	"condition",
	"vector",
	"position",
	"scale",
	"profit",
	"rich",
	"empire",
	"structure",
	"flowchart",
	"presentation",
	"mistake",
	"error",
	"warning",
	"english",
	"lesson",
	"security",
	"cyber",
	"apply",
	"determination",
	"logic",
	"skycorp",
	"tiasystems",
	"lie",
	"conference",
	"trainee",
	"intern",
	"unpaid",
	"minimum",
	"wage",
	"referral",
	"suspension",
	"fired",
	"impending",
	"doom",
	"complicated",
	"simple",
	"stupid",
	"keep",
	"repeat",
	"don't",
	"yourself",
	"contact",
	"management",
	"higher ups",
	"circumstances",
	"proceed",
	"crunchy",
	"nutshell",
	"doctor",
	"vagabond",
	"vagrant",
	"counting",
	"streets",
	"skyscraper",
	"home",
	"2009",
	"generated",
	"friday",
	"monday",
	"cleanup",
	"file",
	"explorer"
]
func randomize_goal()->void:
	var goal = ""
	for i in range(randi_range(3, 20)):
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
		last_match = new_last_match
	if a == b:
		var plr:Player = get_tree().get_first_node_in_group("plr")
		var papers:Papers = PAPERS.instantiate()
		papers.value = last_match
		papers.global_position = plr.global_position + Vector3(-2, 1, 2)
		get_tree().current_scene.add_child(papers)
		randomize_goal()
