class_name Mob extends PlayerCharacter2D
## Snaps to a tile map grid and moves according to player input.

var toGoal

func setPath():
	var position_relative_to_tile_map: Vector2 = tile_map.to_local(global_position)
	var map_position: Vector2i = tile_map.local_to_map(position_relative_to_tile_map)
	toGoal = tile_map.nav.get_id_path(map_position, tile_map.goals[0])

func get_movement():
	if toGoal == null:
		setPath()
	var rng = RandomNumberGenerator.new()
	var directions = [Vector2(-1,0), Vector2(1,0), Vector2(0,-1), Vector2(0,1)]
	var input_direction: Vector2 = directions[rng.randi_range(0,3)]
	return input_direction
