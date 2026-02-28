extends Node2D

var sprite
var poly
var maxCooldown = 100.0
var timer = 0.0


func _ready():
	sprite = get_node("Sprite2D")
	poly = get_node("Polygon2D")
	update()

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
	
