extends Node2D

@export var player_ref : Player

func _on_mask_collect(maskType: String) -> void:
	print("mask collected")
	
