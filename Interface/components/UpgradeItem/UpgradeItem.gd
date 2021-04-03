extends CenterContainer

export var upgrade_name = ''
export var id = ''

var default_color = Color(1,1,1,1)
var highlight_color = Color(0,1,0,1)
# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/Name.text = upgrade_name
	SetValue(0)
	SetColor(false)

func SetValue(val):
	$HBoxContainer/Label.text = String(val)

func _on_UpgradeDec_pressed():
	GlobalScenes.current_scene.get_node('Menu').SkillsMenu.DecCurrLevel(id)

func _on_UpgradeInc_pressed():
	GlobalScenes.current_scene.get_node('Menu').SkillsMenu.IncCurrLevel(id)

func SetColor(highlight):
	if(highlight):
		$HBoxContainer/Label.add_color_override("font_color", highlight_color)
	else:
		$HBoxContainer/Label.add_color_override("font_color", default_color)

