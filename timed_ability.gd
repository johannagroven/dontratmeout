extends Node2D

var sprite
var poly
var maxCooldown = 100.0
var timer = 0.0
var textures = {
	3 : load("res://assets/cards/destroyWall.png"),
	4 : load("res://assets/cards/buildWall.png")
}
var maxCooldowns = {
	3 : 100.0,
	4 : 200.0
}
var index = 3

func _ready():
	update()
	
func changeCard(i):
	index = i;
	if sprite == null:
		sprite = get_node("Sprite2D")
		poly = get_node("Polygon2D")
	sprite.texture = textures[index]
	maxCooldown = maxCooldowns[index]

func use():
	if timer == 0:
		timer = maxCooldown
		update()
		return true
	return false
	
func update():
	timer -= 1.0
	timer = max(timer, 0)
	
	var percent = timer / maxCooldown
	poly.scale = Vector2(percent, percent)	
	
