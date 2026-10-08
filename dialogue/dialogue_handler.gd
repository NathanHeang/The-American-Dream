extends Control

const DIALOGUE_BUTTON = preload("res://dialogue/dialogue_button.tscn")

@onready var label: RichTextLabel = %Text
@onready var speaker_sprite: TextureRect = %SpeakerSprite
@onready var button_container: HBoxContainer = %ButtonContainer

@onready var text_sound: AudioStreamPlayer = $TextSound

var dialogue:Array[Dialogue]
var current_dialogue:int=0
var next_item:bool=false

func _ready() -> void:
	visible = false
	button_container.visible = false
	
	begin("test")
	
func begin(id:String)->void:
	dialogue = DialogueLibrary.dialogues[id].list
	next_item = true
	
func _process(_dt: float) -> void:
	if current_dialogue == dialogue.size()-1:
		next_item = false
	if next_item:
		next_item = false
		var i = dialogue[current_dialogue]
		visible = true
		if i is DialogueText:
			text_dialogue(i)
		elif i is DialogueChoice:
			choice_dialogue(i)
		elif i is DialogueFunction:
			function_dialogue(i)
			visible = not i.hide_box
		else:
			print("wrong resource type!")
			current_dialogue +=1
			next_item = true

func text_dialogue(d:DialogueText)->void:
	text_sound.stream = d.text_sound
	text_sound.volume_db = d.text_volume
		
	if !d.speaker_texture:
		speaker_sprite.visible = false
	else:
		speaker_sprite.visible = true
		speaker_sprite.texture = d.speaker_texture
		
	label.visible_characters = 0
	label.text = d.text
	var cleaned:String = clean_text(d.text)
	var total_chars:int = cleaned.length()
	var char_timer:float = 0.0
	while label.visible_characters < total_chars:
		if Input.is_action_just_pressed("ui_cancel"):
			label.visible_characters = total_chars
			break
		
		char_timer += get_process_delta_time()
		if char_timer >= (1.0/d.text_speed) or cleaned[label.visible_characters] == "":
			var c:String = cleaned[label.visible_characters]
			label.visible_characters += 1
			if c != "":
				text_sound.pitch_scale = randf_range(d.text_min_pitch, d.text_max_pitch)
				text_sound.play()
			char_timer = 0.0
			
		await get_tree().process_frame
		
	while true:
		await get_tree().process_frame
		if label.visible_characters == total_chars:
			if Input.is_action_just_pressed("ui_accept"):
				current_dialogue +=1
				next_item = true
	
func clean_text(t:String)->String:
	var res:String = ""
	var inside_bracket:bool = false
	
	for i in t:
		if i == "[":
			inside_bracket = true
			continue
		
		if i == "]":
			inside_bracket = false
			continue
		
		if !inside_bracket:
			res +=i
	
	return res
	
func choice_dialogue(d:DialogueChoice)->void:
	label.text = d.text
	label.visible_characters = -1
	if d.speaker_texture:
		speaker_sprite.visible = true
		speaker_sprite.texture = d.speaker_texture
	else:
		speaker_sprite.visible = false
	button_container.visible = true
	
	for i in d.choice_text.size():
		var btn:Button = DIALOGUE_BUTTON.instantiate()
		btn.text = d.choice_text[i]
		
		var function_resource:DialogueFunction = d.choice_function_call[i]
		if function_resource:
			btn.connect("pressed",
			Callable(get_node(function_resource.target_path), function_resource.method_name).bindv(function_resource.args),
			CONNECT_ONE_SHOT)
			if function_resource.hide_box:
				btn.connect("pressed", hide, CONNECT_ONE_SHOT)
			
			btn.connect("pressed", 
			choice_pressed.bind(get_node(function_resource.target_path)),
			CONNECT_ONE_SHOT
			)
		else:
			btn.connect("pressed", choice_pressed.bind(null, ""), CONNECT_ONE_SHOT)
		button_container.add_child(btn)
	button_container.get_child(0).grab_focus()
			
func choice_pressed(target_node:Node, wait_signal:String):
	button_container.visible = false
	
	for i:Node in button_container.get_children():
		i.queue_free()
		
	if wait_signal:
		if target_node.has_signal(wait_signal):
			var state = {"done":false}
			var callable = func(_args):state.done = true
			target_node.connect(wait_signal, callable, CONNECT_ONE_SHOT)
			while not state.done:
				await get_tree().process_frame
	
	current_dialogue +=1
	next_item = true

func function_dialogue(d:DialogueFunction)->void:
	var target_node:Node = get_node(d.target_path)
	if target_node.has_method(d.method_name):
		if d.args.size() == 0:
			target_node.call(d.method_name)
		else:
			target_node.callv(d.method_name, d.args)
			
	if d.wait_signal_name:
		if target_node.has_signal(d.wait_signal_name):
			var state = {"done": false}
			var callable = func(_args): state.done = true
			target_node.connect(d.wait_signal_name, callable, CONNECT_ONE_SHOT)
			while not state.done:
				await get_tree().process_frame
	
	current_dialogue +=1
	next_item = true
