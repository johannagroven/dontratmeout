class_name chracter extends CharacterBody2D
## Snaps to a tile map grid and moves according to player input.

enum FACINGS {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

var facing = FACINGS.UP

## Set to the tile map you want to walk in.
@export var tile_map: TileMap = null

## Determines speed. Number of tile map tiles traveled per second.
## Cannot be changed after spawning in this demo but you could implement a setter for that.
##
## Will be rounded to an integer number of ticks per move. For example, with a physics tick rate of
## 60 (default) and a tiles_per_second of 7 it will be rounded up to 9 ticks per move which is
## 6.66 tiles per second.
##
## Note: there is no minimum speed but the maximum speed is equal to the physics tick rate.
@export var tiles_per_second: float = 1.0

# Position to interpolate visuals from. (smooths motion when framerate is higher than physics tick rate)
var _previous_position: Vector2 = Vector2.ZERO

# Number of physics ticks before character will be centered in a tile again.
# Character cannot change move direction while between tiles.
var _move_remaining_ticks: int = 0

# Calculated from tiles_per_second. Number of physics ticks to move between adjacent cells.
var _physics_ticks_per_move: int = 0
# Calculated from tiles_per_second.
var _physics_velocity_fraction: float = 0.0

#Saves last inputed direction
var _last_input_direction: Vector2 = Vector2.ZERO

## Node to interpolate between physics ticks.
## Sprites, cameras, effects, etc., should be children of this node.
## Without interpolation, any visuals attached to the character directly would appear to jitter when
## the framerate exceeds the physics tick rate.
@onready var visuals: Node2D = $visuals


func _init() -> void:
	# Reset to correct motion mode. (in case script is applied without setting motion mode)
	motion_mode = MOTION_MODE_FLOATING


func _ready() -> void:
	# Initialize interpolate-from position as starting position rather than zero.
	_previous_position = global_position

	# Convert desired movement speed into a discrete number of physics ticks per cell traveled.
	# For example, if physics_ticks_per_second is 60 (default) and tiles_per_second is 6,
	# we will spread the move between cells across 10 physics ticks.
	_physics_ticks_per_move = roundi(Engine.physics_ticks_per_second / tiles_per_second)
	print("_physics_ticks_per_move: ", _physics_ticks_per_move)

	# Since move_and_slide takes a velocity in global space, we provide the global space position
	# delta (usually the distance between two tiles unless we started off-grid) scaled according to
	# tile speed. Dividing that velocity by the physics timestep (p_delta) would move in a single
	# physics tick, so we multiply the timestep by the number of ticks per move.
	# For example, if physics_ticks_per_second is 60 (default) and _physics_ticks_per_move is 10,
	# we need our velocity to be 6x the distance per second.
	_physics_velocity_fraction = Engine.physics_ticks_per_second / float(_physics_ticks_per_move)
	print("_physics_velocity_fraction: ", _physics_velocity_fraction)

func facingFromVector(v2):
	if v2.x < 0:
		return FACINGS.LEFT
	elif v2.x > 0:
		return FACINGS.RIGHT
	elif v2.y > 0:
		return FACINGS.DOWN
	elif v2.y < 0:
		return FACINGS.UP
	else:
		return facing
		
func facingToRotDeg(f):
	match f:
		FACINGS.UP:
			return 270
		FACINGS.DOWN:
			return 90
		FACINGS.LEFT:
			return 180
		FACINGS.RIGHT:
			return 0

func get_movement():
	var input_direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	return input_direction

func _physics_process(_p_delta: float) -> void:
	if not tile_map:
		return

	if _move_remaining_ticks == 0:
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_direction: Vector2 = get_movement()
		if input_direction != Vector2(0,0):
			_last_input_direction = input_direction
		facing = facingFromVector(input_direction)
		var vision_poly = get_node("Polygon2D")
		rotation_degrees = (facingToRotDeg(facing))
		# Convert global position into a tile coordinate.
		# We don't assume we are already snapped to the tile grid.
		var position_relative_to_tile_map: Vector2 = tile_map.to_local(global_position)
		var map_position: Vector2i = tile_map.local_to_map(position_relative_to_tile_map)

		var map_direction: Vector2i = _input_direction_to_map_direction(input_direction)
		if map_direction.x == 0 and map_direction.y == 0:
			velocity = Vector2.ZERO
		else:
			var next_map_position: Vector2i = map_position + map_direction
			if _is_walkable(next_map_position):
				var next_map_local_position: Vector2 = tile_map.map_to_local(next_map_position)
				var next_global_position: Vector2 = tile_map.to_global(next_map_local_position)
				velocity = (next_global_position - global_position) * _physics_velocity_fraction
				_move_remaining_ticks = _physics_ticks_per_move
			else:
				velocity = Vector2.ZERO

	_previous_position = global_position
	if _move_remaining_ticks > 0:
		move_and_slide()
		_move_remaining_ticks -= 1


func _process(_p_delta: float) -> void:
	# Interpolate between physics ticks when framerate is higher than physics tick rate.
	# Refer to visuals property documentation for more details.
	var weight: float = Engine.get_physics_interpolation_fraction()
	visuals.global_position = lerp(_previous_position, global_position, weight)


## Convert analog input direction to grid direction.
## You could implement a mechanism to alternate horizontal/vertical inputs when analog input
## is diagonal. For example, if analog is 2:1 right/up then every third move should be up.
func _input_direction_to_map_direction(p_input_direction: Vector2) -> Vector2i:
	if is_equal_approx(abs(p_input_direction.x), abs(p_input_direction.y)):
		# Input is near zero or both left/right and up/down are held simultenously. (don't move)
		return Vector2.ZERO
	elif abs(p_input_direction.x) > abs(p_input_direction.y):
		# Left/right are held or analog stick is *more* left/right than up/down.
		return Vector2(roundf(p_input_direction.x), 0)
	else:
		# Up/down are held or analog stick is *more* up/down than left/right.
		return Vector2(0, roundf(p_input_direction.y))


## Can we enter a given tile coordinate?
## Our character has a collider and moves using the physics system so that it interacts properly
## with raycasts, areas, rigidbodies, etc., but alone this would allow us to get slightly closer to
## walls than the center of the tile. Instead, we check before moving whether a tile is enterable.
## In this demo we only allow entering tiles without any collision polygons.
## This could, for example, check a custom data layer "is_walkable" property.
func _is_walkable(p_map_position: Vector2i) -> bool:
	var tile_data: TileData = tile_map.get_cell_tile_data(0, p_map_position)
	if not tile_data:
		# Outside level.
		return false
	if tile_data.get_custom_data("isGoal"):
		# TODO Something Reasonable
		get_node("goalLabel").text = "You\nWin!"
	return tile_data.get_collision_polygons_count(0) < 1

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_3:
			var position_relative_to_tile_map: Vector2 = tile_map.to_local(global_position)
			var map_position: Vector2i = tile_map.local_to_map(position_relative_to_tile_map)

			var map_direction: Vector2i = _input_direction_to_map_direction(_last_input_direction)
			var next_map_position: Vector2i = map_position + map_direction
			if not _is_walkable(next_map_position):
				tile_map.set_cell(0,next_map_position,5,Vector2i(0,0))
			
