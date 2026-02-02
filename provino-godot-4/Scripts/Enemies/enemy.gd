class_name Enemy
extends BaseEntity

@export var vision_sensors_container : Node2D
var target : Player
var vision_sensors_ref : Array[Node]
var vision_sensors : Array[RayCast2D]


func _ready() -> void:
	vision_sensors_ref = vision_sensors_container.get_children()
	
	for sensor in vision_sensors_ref:
		if sensor is RayCast2D:
			vision_sensors.append(sensor)


func _on_vision_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body


func _physics_process(delta: float) -> void:
	if !target: return
	
	direction = (target.global_position - global_position).normalized()
	
	_update_vision()
	
	var hit_info : Array[RayCast2D] = _check_collision_with_obstacle()
	var deviation : float
	
	if hit_info.size() > 0:
		#if hit_info.size() < 2:
		var raycast_angle = abs(atan2(global_position.x + hit_info[0].target_position.x, global_position.y + hit_info[0].target_position.y))
		var direction_angle = abs(atan2(direction.x, direction.y))
		deviation = direction_angle - raycast_angle
	
	if deviation > 0 and direction != Vector2.ZERO:
		direction.x += cos(deviation)
		direction.y += sin(deviation)
		direction = direction.normalized()
	
	super._physics_process(delta)


func _update_vision():
	if direction == Vector2.ZERO:
		return
	
	vision_sensors_container.rotation = -atan2(direction.x, direction.y)


func _check_collision_with_obstacle() -> Array[RayCast2D]:
	var hit_info : Array[RayCast2D]
	for ray in vision_sensors:
		if ray.is_colliding():
			hit_info.append(ray)
	
	return hit_info


func _on_vision_body_exited(body: Node2D) -> void:
	if body is Player:
		target = null
