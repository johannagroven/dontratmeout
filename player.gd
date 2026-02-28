extends Area2D

# TODO Lift up into globa enum definitions
enum Direction {
	UP = 0,
	DOWN = 1,
	LEFT = 2,
	RIGHT = 3
}

# TODO Pull tile size up
const size = Vector2i(32,32)
var location = Vector2i(-1,-1)
var facing = Direction.UP
var texture = load("res://assets/computer mouse-Sheet.png")
var sprite = Sprite2D.new()

func _init():
	sprite.texture = texture
	add_child(sprite)

func facingToRadians(f):
		match f:
			Direction.UP:
				return 0.0
			Direction.DOWN:
				return 1.0
			Direction.LEFT:
				return 2.0
			Direction.RIGHT:
				return 3.0
	
func facingToVector2i(f):
	match f:
		Direction.UP:
			return Vector2i(0,-1)
		Direction.DOWN:
			return Vector2i(0,1)
		Direction.LEFT:
			return Vector2i(-1, 0)
		Direction.RIGHT:
			return Vector2i(1,0)

func updateSprite():
	sprite.global_position = size * location
	sprite.rotate(facingToRadians(facing))
