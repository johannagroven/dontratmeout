extends Control

#Normal Color
var NORMAL_COLOR = Color("ffffff")
var GREYED_OUT = Color("565656")

##State Machine (Actually lookup dict)
var STATES = {
	0:"NEW_GAME",
	1:"LEVEL_SELECT"
}

var cur_state: int = 0

func updateState(pos: bool): 
	if pos:
		cur_state=(cur_state+1)%STATES.size()
	else:
		cur_state=(cur_state-1)%STATES.size()
	match cur_state:
		0: 
			get_node("./NewGame").text = "New Game [Enter]"
			get_node("./NewGame").modulate = NORMAL_COLOR
			get_node("./LevelSelect").text = "Level Select"
			get_node("./LevelSelect").modulate = GREYED_OUT
		1:
			get_node("./NewGame").text = "New Game"
			get_node("./NewGame").modulate = GREYED_OUT
			get_node("./LevelSelect").text = "Level Select [Enter]"
			get_node("./LevelSelect").modulate = NORMAL_COLOR

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("./NewGame").text = "New Game [Enter]"
	get_node("./NewGame").modulate = NORMAL_COLOR
	get_node("./LevelSelect").text = "Level Select"
	get_node("./LevelSelect").modulate = GREYED_OUT


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_DOWN:
			updateState(true)
		if event.keycode == KEY_UP:
			updateState(false)
		if event.keycode == KEY_ENTER:
			if STATES[cur_state] == "NEW_GAME":
				Globals.current_Level = 1
				var leveltoload = "res://" + Globals.level_Names[Globals.current_Level] + ".tscn"
				get_tree().change_scene_to_file(leveltoload)
			if STATES[cur_state] == "LEVEL_SELECT":
				get_tree().change_scene_to_file("res://level_select.tscn")
