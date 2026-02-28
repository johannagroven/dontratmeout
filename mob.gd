class_name Mob extends PlayerCharacter2D
## Snaps to a tile map grid and moves according to player input.

var toGoal

func setPath():
	var position_relative_to_tile_map: Vector2 = tile_map.to_local(global_position)
	var map_position: Vector2i = tile_map.local_to_map(position_relative_to_tile_map)
	toGoal = tile_map.nav.get_id_path(map_position, tile_map.goals[0])
	toGoal.remove_at(0)

func dither():
	var rng = RandomNumberGenerator.new()
	var directions = [Vector2(-1,0), Vector2(1,0), Vector2(0,-1), Vector2(0,1)]
	var input_direction: Vector2 = directions[rng.randi_range(0,3)]
	toGoal = null
	return input_direction

func follow_path():
	if toGoal == null:
		setPath()
	if toGoal.size() == 0: 
		return Vector2i(0,0)
	var position_relative_to_tile_map: Vector2 = tile_map.to_local(global_position)
	var map_position: Vector2i = tile_map.local_to_map(position_relative_to_tile_map)
	var delta = toGoal[0] - map_position
	toGoal.remove_at(0)
	return delta

func get_movement():
	#return dither()
	return follow_path()
