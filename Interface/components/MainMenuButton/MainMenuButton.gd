extends CenterContainer

export var id = ''
func _ready():
	$HBoxContainer/Button.text = id

func Selected(flag):
	if(flag):
		$HBoxContainer/Selector.text = '>'
	else:
		$HBoxContainer/Selector.text = ''
		
func _on_Button_pressed():
	if(id == 'Continue'):
		Global.LoadGame()
	elif(id == 'New Game'):
		Global.NewGame()
	elif(id == 'Quit'):
		get_tree().quit()
