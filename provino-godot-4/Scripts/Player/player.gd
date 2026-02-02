class_name Player
extends BaseEntity

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down") # No need to normalize, it does it on it's own
	
	if direction.x < 0:
		sprite_ref.flip_h = true
		$Shadow.material.set_shader_parameter("look_right", false)
	elif direction.x > 0:
		sprite_ref.flip_h = false
		$Shadow.material.set_shader_parameter("look_right", true)
