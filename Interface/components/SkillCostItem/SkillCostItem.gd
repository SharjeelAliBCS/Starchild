extends HBoxContainer
export var cost_name = ''

var default_color = Color(1,1,1,1)
var highlight_color = Color(0,1,0,1)

# Called when the node enters the scene tree for the first time.
func _ready():
	SetValue(0)
	SetColor(false)
	$Name.text  =  cost_name

func SetValue(val):
	$Label.text = String(val)

func SetColor(highlight):
	if(highlight):
		$Label.add_color_override("font_color", highlight_color)
	else:
		$Label.add_color_override("font_color", default_color)
