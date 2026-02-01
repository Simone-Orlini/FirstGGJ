extends Camera2D

@export_category("Follow Character")
@export var player : CharacterBody2D

@export_category("Camera Smooting")
@export var smoothing : bool = false
@export_range(0, 10) var smoothing_distance : int = 8

func _ready() -> void:
	global_position = player.global_position

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if player == null:
		return
	
	var camera_position : Vector2
	
	if smoothing:
		var weight : float = float(smoothing_distance) / 100
		camera_position = lerp(global_position, player.global_position, weight)
	else:
		camera_position = player.global_position
	
	global_position = camera_position
