extends Node2D

@export var tilemap_ref : TileMapLayer
@export var map_dimensions : Vector2i = Vector2(512, 512)
@export var tree_count : int = 100
@export var tree_min_distance : int = 30
@export var tree_max_distance : int = 50
var tree_scene : Resource = preload("res://Scenes/tree.tscn")
var trees_spawned : int = 0


func _ready() -> void:
	var random_tree_pos : Array[Vector2i]
	
	for x in range(map_dimensions.x):
		for y in range(map_dimensions.y):
			if x > tree_max_distance and x < map_dimensions.x - tree_max_distance:
				if y > tree_max_distance and y < map_dimensions.y - tree_max_distance:
					@warning_ignore("narrowing_conversion")
					var place_tree = randi_range(0, map_dimensions.x * map_dimensions.y / (tree_count * 0.1)) <= 1
					if place_tree:
						random_tree_pos.append(tile_coord_to_world_coord(Vector2i(x + 1, y + 1)))
						continue
			
			tilemap_ref.set_cell(Vector2i(x, y), 0, Vector2i(1, 0))
	
	_spawn_trees(random_tree_pos)


func _spawn_trees(starting_trees_pos : Array[Vector2i]):
	var tree_instance : StaticBody2D
	
	for pos in starting_trees_pos:
		tree_instance = tree_scene.instantiate()
		tree_instance.global_position = pos
		add_child(tree_instance)
		trees_spawned += 1
	
	while trees_spawned < tree_count:
		for pos in starting_trees_pos:
			
			if trees_spawned >= tree_count:
				break
			
			tree_instance = tree_scene.instantiate()
			var radius = randi_range(tree_min_distance, tree_max_distance) * tilemap_ref.tile_set.tile_size.x
			var random_pos = randf_range(0, 2 * PI)
			tree_instance.global_position = pos + Vector2i(Vector2(cos(random_pos), sin(random_pos)) * radius)
			
			tree_instance.z_index = world_coord_to_tile_coord(tree_instance.global_position).y
			
			add_child(tree_instance)
			trees_spawned += 1
	
	print(trees_spawned)


func tile_coord_to_world_coord(coord : Vector2i) -> Vector2i:
	return Vector2i(coord.x * tilemap_ref.tile_set.tile_size.x, coord.y * tilemap_ref.tile_set.tile_size.y)

func world_coord_to_tile_coord(coord : Vector2i) -> Vector2i:
	@warning_ignore("integer_division")
	return Vector2i(coord.x / tilemap_ref.tile_set.tile_size.x, coord.y / tilemap_ref.tile_set.tile_size.y)
