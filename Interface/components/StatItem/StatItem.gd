extends CenterContainer
export var id  = ''
export var stat_name = ''
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var default_color = Color(1,1,1,1)
var highlight_color = Color(0,1,0,1)

# Called when the node enters the scene tree for the first time.
func _ready():
	SetValue(0)
	SetColor(false)
	$HBoxContainer/Name.text  =  stat_name

func SetValue(val):
	$HBoxContainer/Label.text = String(val)

func SetColor(highlight):
	if(highlight):
		$HBoxContainer/Label.add_color_override("font_color", highlight_color)
	else:
		$HBoxContainer/Label.add_color_override("font_color", default_color)
