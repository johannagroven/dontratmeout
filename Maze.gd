extends Area2D

enum Tile {
	FLOOR = 0,
	WALL = 1,
	MOUSE = 8,
	PLAYER = 9
}
const tileSize = Vector2i(32,32)
const height = 10
const width = 10

# Also const, but because they're dynamically loaded they cannot be const
var tileText = load("res://assets/mazetile.png")
var wallText = load("res://assets/walls/wall0.png")

var rng = RandomNumberGenerator.new()
var board = []
var sprites = []


func _ready():
	initBoard()
	addSprites()

func initBoard():
	for y in range(0,height):
		for x in range(0,height):
			if (rng.randi_range(0,1) == 0):
				board.append(Tile.FLOOR)
			else:
				board.append(Tile.WALL)
			
func getIndex(x, y):
	return y * width + x
	
func getLoc(index):
	var y = int(index)/int(width)
	var x = index % width
	return Vector2i(x,y)
	
func addSprites():
	for i in range(board.size()):
		var location = getLoc(i) * tileSize
		var sprite
		match board[i]:
			Tile.WALL:
				sprite = Sprite2D.new()
				sprite.texture = wallText
			Tile.FLOOR:
				sprite = Sprite2D.new()
				sprite.texture = tileText
			Tile.MOUSE:
				break
			Tile.PLAYER:
				break
		sprite.global_position = location
		add_child(sprite)
		sprites.append(sprite)		
