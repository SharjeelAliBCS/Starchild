extends VBoxContainer
#https://youtu.be/Jjv2MWbQVhs
onready var load_game = $LoadGame
onready var new_game = $NewGame
onready var quit_game = $QuitGame

var current_selection = 0
func _ready():
	set_current_selection(0)

func _process(delta):
	if(Input.is_action_just_pressed('ui_down')):
		current_selection = (current_selection + 1) % 3
		set_current_selection(current_selection)
	elif(Input.is_action_just_pressed('ui_up')):
		current_selection = current_selection - 1
		if(current_selection <0):
			current_selection = 2
		set_current_selection(current_selection)
	
	if(Input.is_action_just_pressed("ui_accept")):
		if(current_selection == 0):
			Global.LoadGame()
		elif(current_selection == 1):
			Global.NewGame()
		elif(current_selection == 2):
			get_tree().quit()
		
func set_current_selection(_current_selection):
	load_game.Selected(false)
	new_game.Selected(false)
	quit_game.Selected(false)
	
	load_game.Selected(_current_selection == 0)
	new_game.Selected(_current_selection == 1)
	quit_game.Selected(_current_selection == 2)
