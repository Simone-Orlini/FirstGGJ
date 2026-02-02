class_name BaseEntity
extends CharacterBody2D

@export var stats : EntityStats
@export var sprite_ref : Sprite2D
var direction : Vector2

func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(direction * stats.max_speed, stats.accel_speed * delta)
	move_and_slide()
