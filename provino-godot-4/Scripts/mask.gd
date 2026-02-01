extends Node2D

func _ready() -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		collect.emit("wolf")
		queue_free()


signal collect(maskType: String)
