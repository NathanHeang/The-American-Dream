extends Control

const DIALOGUE_BUTTON = preload("res://dialogue/dialogue_button.tscn")

@onready var label: RichTextLabel = %Text
@onready var speaker_parent: Control = $HBoxContainer/SpeakerParent
@onready var speaker_sprite: Sprite2D = %SpeakerSprite
@onready var button_container: HBoxContainer = %ButtonContainer

@onready var text_sound: AudioStreamPlayer = $TextSound

var dialogue:Array[Dialogue]
var current_dialogue:int=0
var next_item:bool=true

var plr:Player

func _ready() -> void:
	visible = false
	button_container.visible = false
	
	for i in get_tree().get_nodes_in_group("player"):
		plr = i

func _process(_dt: float) -> void:
	if current_dialogue == dialogue.size():
		if !plr:
			for i in get_tree().get_nodes_in_group("player"):
				plr = i
			return
		plr.can_move = true
		queue_free()
		pass
	if next_item:
		next_item = false
		var i = dialogue[current_dialogue]
		visible = true
		if i is DialogueText:
			visible = not i.hide_box
			function_dialogue(i)
		elif i is DialogueChoice:
			function_dialogue(i)
		elif i is DialogueFunction:
			function_dialogue(i)
		else:
			print("wrong resource type!")
			current_dialogue +=1
			next_item = true

func text_dialogue(d:DialogueText)->void:
	text_sound.stream = d.text_sound
	text_sound.volume_db = d.text_volume
	var cam:Camera2D = get_viewport().get_camera_2d()
	if cam and d.cam_pos != Vector2(999.999, 999.999):
		var cam_tw:Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		cam_tw.tween_property(cam, "global_position", d.cam_pos, d.cam_transition_time)
		
	if !d.speaker_texture:
		speaker_parent.visible = false
	else:
		speaker_parent.visible = true
		speaker_sprite.texture = d.speaker_texture
		speaker_sprite.hframes = d.speaker_hframes
		speaker_sprite.frame = 0
		
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
				if d.speaker_hframes !=1:
					if speaker_sprite.frame < d.speaker_hframes - 1:
						speaker_sprite.frame +=1
					else:
						speaker_sprite.frame = 0
			char_timer = 0.0
			
		await get_tree().process_frame
		
	speaker_sprite.frame = min(d.speaker_rest_frame, d.speaker_hframes -1)
	
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
		speaker_parent.visible = true
		speaker_sprite.texture = d.speaker_texture
		speaker_sprite.hframes = d.speaker_hframes
		speaker_sprite.frame = min(d.speaker_select_frame, d.speaker_hframes-1)
	else:
		speaker_parent.visible = false
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
