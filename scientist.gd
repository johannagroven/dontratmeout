extends Node2D

enum FACINGS {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

enum DIRECTION {
	TO_START,
	TO_END
}

var startPos
var endPos
var facing = FACINGS.UP
var direction = DIRECTION.TO_START
var polygonOrig
var polygon
var turntime=50.0
var timer=0

func _ready() -> void:
	startPos = global_position
	endPos = get_node("PosEnd").global_position
	polygonOrig = get_node("Polygon2D").polygon.duplicate()
	polygon = polygonOrig.duplicate()

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
			return 270 + 90
		FACINGS.DOWN:
			return 90 + 90
		FACINGS.LEFT:
			return 180 + 90
		FACINGS.RIGHT:
			return 0 + 90
			
func update():
	timer -=1
	print(timer)
	if timer < 0:
		timer = turntime
		if facing==FACINGS.RIGHT:
			facing = FACINGS.LEFT
			rotation_degrees = facingToRotDeg(facing)
		else:
			facing = FACINGS.RIGHT
			rotation_degrees = facingToRotDeg(facing)
		var newpoly = PackedVector2Array([Vector2(0,0),Vector2(0,0),Vector2(0,0)])
		for i in polygonOrig.size():
			newpoly.set(i,polygonOrig.duplicate()[i].rotated(rotation)+global_position)
			polygon = newpoly
	#var target
	#var delta
	#if direction == DIRECTION.TO_START:
		#target = startPos
	#else:
		#target = endPos
	#delta = target - global_position
	#delta = delta.normalized()
	#global_position += delta
	##print(polygon)
	#
	#var newpoly = PackedVector2Array([Vector2(0,0),Vector2(0,0),Vector2(0,0)])
	#for i in polygonOrig.size():
		#newpoly.set(i,polygonOrig.duplicate()[i].rotated(rotation)+global_position)
	#polygon = newpoly
	##print(rotation)
	#facing = facingFromVector(delta)
	#rotation_degrees = facingToRotDeg(facing)
	#var x_delt_start = global_position.x - startPos.x
	#var x_delt_end = global_position.x - endPos.x
	#var y_delt_start = global_position.y - startPos.y
	#var y_delt_end = global_position.y - endPos.y
	#if ((x_delt_start <= 0 && x_delt_end <= 0) ||
		#(x_delt_start >= 0 && x_delt_end >= 0) ||
		#(y_delt_start <= 0 && y_delt_end <= 0) ||
		#(y_delt_start >= 0 && y_delt_end >= 0)):
		#if direction == DIRECTION.TO_START:
			#direction = DIRECTION.TO_END
		#else:
			#direction = DIRECTION.TO_START

	
