extends Area2D

enum Tile {
	START = -2,
	GOAL = -1,
	FLOOR = 0,
	WALL = 1,
	MOUSE = 98,
	PLAYER = 99
}
const tileSize = Vector2i(32,32)


# Also const, but because they're dynamically loaded they cannot be const
var tileText = load("res://assets/mazetile.png")
var wallText = load("res://assets/walls/wall0.png")

var height = 10
var width = 10
var rng = RandomNumberGenerator.new()
var board = []
var sprites = []
var startLoc = Vector2i(-1,-1)
var goalLoc = Vector2i(-1,-1)

func _ready():
	#randomBoard()
	boardFromFile("res://assets/boards/test.json")
	addSprites()

func randomBoard():
	startLoc = Vector2i(width - 1, height - 1)
	goalLoc = Vector2i(0,0)
	for y in range(0,height):
		for x in range(0,height):
			if (rng.randi_range(0,1) == 0):
				board.append(Tile.FLOOR)
			else:
				board.append(Tile.WALL)
				
func boardFromFile(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.new()
	var asString = file.get_as_text
	asString = file.get_as_text()
	file.close()
	var dict = json.parse_string(asString)
	width = int(dict["width"])
	height = int(dict["height"])
	board = []
	for row in dict["board"]:
		for cell in row:
			board.append(int(cell))
	
			
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
			Tile.START:
				sprite = Sprite2D.new()
				sprite.texture = tileText
			Tile.GOAL:
				sprite = Sprite2D.new()
				sprite.texture = tileText
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
