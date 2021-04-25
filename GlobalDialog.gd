extends Node2D

var dialog = {}
var current_dialog = ''
var timeLimit = 0
var timeLeft = 0
func _ready():
	ReadData()

func _process(delta):
	timeLeft = max(timeLeft-delta, 0)
	
	if(timeLeft<=0 and timeLimit > 0):
		ResetDialog()
		print("and done")
		
	if Input.is_action_just_pressed("dialog_next"):
		ResetDialog()
	
func ReadData():
	var file = File.new()
	file.open("res://Dialog/dialog.json", file.READ)
	var text = file.get_as_text()
	dialog = parse_json(text)
	file.close()

func ShowDialog(key):
	if(not current_dialog):
		current_dialog = key
		if("time" in dialog[key]):
			timeLimit = dialog[key]["time"]
			timeLeft = timeLimit
		GlobalScenes.GetDialogBox().LoadDialog(dialog[key]["text"])
		
func RemoveDialog(text):
	if(text in current_dialog):
		ResetDialog()

func ResetDialog():
	if(current_dialog):
		current_dialog = ''
		timeLimit = 0
		timeLeft = 0
		var node = GlobalScenes.GetDialogBox()
		if(node!= null):
			node.Close()
		
	
	
