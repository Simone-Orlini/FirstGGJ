extends CharacterBody2D

class_name Wolf

@export var max_speed = 400
@export var accel_speed = 3000
@export var sprite_ref : Sprite2D
@export var rays_container : Node2D
var direction : Vector2
var target : Player
var rays_ref : Array[Node]
var rays : Array[RayCast2D]


func _ready() -> void:
	rays_ref = rays_container.get_children()
	
	for ray in rays_ref:
		if ray is RayCast2D:
			rays.append(ray)


func _on_vision_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body


func _physics_process(delta: float) -> void:
	var current_speed : Vector2
	
	if !target: return
	
	direction = (target.global_position - global_position).normalized()
	
	_update_vision()
	
	var hit_info : Array[RayCast2D] = _check_collision_with_obstacle()
	var deviation : float
	
	if hit_info.size() > 0:
		if hit_info.size() < 2:
			var raycast_angle = atan2(global_position.x + hit_info[0].target_position.x, global_position.y + hit_info[0].target_position.y)
			var direction_angle = atan2(direction.x, direction.y)
			deviation = direction_angle - raycast_angle
	
	if deviation > 0 and direction != Vector2.ZERO:
		direction.x += cos(deviation)
		direction.y += sin(deviation)
		direction = direction.normalized()
	elif deviation < 0 and direction != Vector2.ZERO:
		direction.x -= cos(deviation)
		direction.y -= sin(deviation)
		direction = direction.normalized()
	
	if direction != Vector2.ZERO:
		current_speed.x = move_toward(velocity.x, max_speed * direction.x, accel_speed * delta)
		current_speed.y = move_toward(velocity.y, max_speed * direction.y, accel_speed * delta)
	else:
		current_speed.x = move_toward(velocity.x, 0, accel_speed * delta)
		current_speed.y = move_toward(velocity.y, 0, accel_speed * delta)
	
	if (target.global_position - global_position).length() > 100:
		velocity = Vector2(current_speed.normalized().x * current_speed.length(), current_speed.normalized().y * current_speed.length())
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()


func _update_vision():
	if direction == Vector2.ZERO:
		return
	
	rays_container.rotation = -atan2(direction.x, direction.y)


func _check_collision_with_obstacle() -> Array[RayCast2D]:
	var hit_info : Array[RayCast2D]
	for ray in rays:
		if ray.is_colliding():
			hit_info.append(ray)
	
	return hit_info


func _on_vision_body_exited(body: Node2D) -> void:
	if body is Player:
		target = null
