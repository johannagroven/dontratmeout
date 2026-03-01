extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


### Return to main Menu
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			Globals.current_Level=0
			get_tree().change_scene_to_file("res://MainMenu.tscn")
