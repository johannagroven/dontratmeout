extends Area2D

const height = 10
const width = 10
var board = []
var sprites = []
const tileSize = Vector2i(32,32)
var tileText = load("res://assets/mazetile.png")
var wallText = load("res://assets/walls/wall0.png")

enum Tile {WALL, FLOOR, MOUSE, PLAYER}

func _ready():
	initBoard()
	addSprites()

func initBoard():
	for y in range(0,height):
		for x in range(0,height):
			board.append(Tile.FLOOR)
			
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
