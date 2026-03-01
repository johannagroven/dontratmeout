extends Control

#Normal Color
var NORMAL_COLOR = Color("ffffff")
var GREYED_OUT = Color("565656")

##State Machine (Actually lookup dict)
var STATES = {
	0:"SELECT",
	1:"RETURN"
}

var cur_state: int = 0

func updateState(pos: bool): 
	if pos:
		cur_state=(cur_state+1)%STATES.size()
	else:
		cur_state=(cur_state-1)%STATES.size()
	match cur_state:
		0: 
			get_node("./LevelLabel").text = "< " + str(Globals.current_Level) + " > [ENTER]"
			get_node("./LevelLabel").modulate = NORMAL_COLOR
			get_node("./ReturnLabel").text = "Return to Main Menu"
			get_node("./ReturnLabel").modulate = GREYED_OUT
		1:
			get_node("./LevelLabel").text = "< " + str(Globals.current_Level) + " >"
			get_node("./LevelLabel").modulate = GREYED_OUT
			get_node("./ReturnLabel").text = "Return to Main Menu [Enter]"
			get_node("./ReturnLabel").modulate = NORMAL_COLOR

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.current_Level = 1
	get_node("./LevelLabel").text = "< " + str(Globals.current_Level) + " > [ENTER]"
	get_node("./LevelLabel").modulate = NORMAL_COLOR
	get_node("./ReturnLabel").text = "Return to Main Menu"
	get_node("./ReturnLabel").modulate = GREYED_OUT


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_RIGHT and STATES[cur_state] == "SELECT" and Globals.current_Level < 5:
			Globals.current_Level += 1
			get_node("./LevelLabel").text = "< " + str(Globals.current_Level) + " > [ENTER]"
		if event.keycode == KEY_LEFT and STATES[cur_state] == "SELECT" and Globals.current_Level > 1:
			Globals.current_Level -= 1
			get_node("./LevelLabel").text = "< " + str(Globals.current_Level) + " > [ENTER]"
		if event.keycode == KEY_DOWN:
			updateState(true)
		if event.keycode == KEY_UP:
			updateState(false)
		if event.keycode == KEY_ENTER:
			if STATES[cur_state] == "SELECT":
				var leveltoload = "res://" + Globals.level_Names[Globals.current_Level] + ".tscn"
				get_tree().change_scene_to_file(leveltoload)
			if STATES[cur_state] == "RETURN":
				Globals.current_Level = 0
				get_tree().change_scene_to_file("res://MainMenu.tscn")
