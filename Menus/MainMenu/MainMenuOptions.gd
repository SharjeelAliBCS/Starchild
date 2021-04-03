extends CenterContainer
#https://youtu.be/Jjv2MWbQVhs
onready var load_game = $VBoxContainer/LoadGame/HBoxContainer/Selector
onready var new_game = $VBoxContainer/NewGame/HBoxContainer/Selector
onready var quit_game = $VBoxContainer/QuitGame/HBoxContainer/Selector

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
	load_game.text = ''
	new_game.text = ''
	quit_game.text = ''
	if(_current_selection == 0):
		load_game.text = '>'
	elif(_current_selection == 1):
		new_game.text = '>'
	elif(_current_selection == 2):
		quit_game.text = '>'



func _on_LoadGameButton_pressed():
	Global.LoadGame()

func _on_NewGameButton_pressed():
	Global.NewGame()

func _on_QuitGameButton_pressed():
	get_tree().quit()
