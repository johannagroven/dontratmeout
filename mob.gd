class_name Mob extends PlayerCharacter2D
## Snaps to a tile map grid and moves according to player input.


func get_movement():
	var rng = RandomNumberGenerator.new()
	var directions = [Vector2(-1,0), Vector2(1,0), Vector2(0,-1), Vector2(0,1)]
	var input_direction: Vector2 = directions[rng.randi_range(0,3)]
	return input_direction
