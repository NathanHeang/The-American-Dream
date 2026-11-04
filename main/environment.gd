extends WorldEnvironment

@export var day_sky_color:Color
@export var day_sky_color_2:Color
@export var night_sky_color:Color
@export var night_sky_color_2:Color

func _ready() -> void:
	System.time_changed.connect(time_changed)

func time_changed(_old:int, new:int)->void:
	var hrs = (new / 3600)/24.0
	var weight = (hrs+12)/24.0
	environment.sky.sky_material.set_shader_parameter("Top Color", lerp(day_sky_color, night_sky_color, weight))
	environment.sky.sky_material.set_shader_parameter("Bottom Color", lerp(day_sky_color_2, night_sky_color_2, weight))
	
