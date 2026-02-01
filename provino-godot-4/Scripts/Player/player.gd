extends CharacterBody2D

class_name Player

@export var max_speed = 350
@export var accel_speed = 3000
@export var sprite_ref : Sprite2D
var direction : Vector2

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void:
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	direction = direction.normalized()
	
	if direction.x < 0:
		sprite_ref.flip_h = true
		$Shadow.material.set_shader_parameter("look_right", false)
	elif direction.x > 0:
		sprite_ref.flip_h = false
		$Shadow.material.set_shader_parameter("look_right", true)

func _physics_process(delta: float) -> void:
	var current_speed : Vector2
	
	if direction != Vector2.ZERO:
		current_speed.x = move_toward(velocity.x, max_speed * direction.x, accel_speed * delta)
		current_speed.y = move_toward(velocity.y, max_speed * direction.y, accel_speed * delta)
	else:
		current_speed.x = move_toward(velocity.x, 0, accel_speed * delta)
		current_speed.y = move_toward(velocity.y, 0, accel_speed * delta)
	
	velocity = Vector2(current_speed.normalized().x * current_speed.length(), current_speed.normalized().y * current_speed.length())
	
	move_and_slide()
