extends StaticBody2D

@onready var player_ref : CharacterBody2D

#signal set_player_ref;
#
#func _ready() -> void:
	#set_player_ref.emit()

#@warning_ignore("unused_parameter")
#func _process(delta: float) -> void:
	#if player_ref.global_position.dot(global_position) > 0:
		#z_index = 1
	#else:
		#z_index = 0
