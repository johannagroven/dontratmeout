extends Area2D

const height = 10
const width = 10
var board = []
var sprites = []
const tileSize = Vector2i(32,32)

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
		match board[i]:
			Tile.WALL:
				break
			Tile.FLOOR:
				var sprite = Sprite2D.new()
				sprite.texture = load("res://assets/mazetile.png")
				var location = getLoc(i)*tileSize
				print(i,location,board.size())
				sprite.global_position = getLoc(i)*tileSize
				add_child(sprite)
				sprites.append(sprite)				
			Tile.MOUSE:
				break
			Tile.PLAYER:
				break
