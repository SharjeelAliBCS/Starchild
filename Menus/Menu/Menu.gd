extends Control

var show = true
var delay = 0
var time = 0.5

var current_selection = 0
onready  var SkillsMenu = $CanvasLayer/Content/Skills/SkillsMenu
func _ready():
	toggle()

func toggle():
	show = not show
	$CanvasLayer/ColorRect.visible = show
	$CanvasLayer/Content.visible = show
	get_tree().paused = show
	delay = time
	$CanvasLayer/Content.set_current_tab(1)
	
	if(show):
		SkillsMenu.Reset()

func _process(delta):
	delay = max(delay-delta, 0)
	if(show):
			
		if(Input.is_action_just_pressed("ui_cancel") and delay == 0):
			toggle()


func _on_Content_tab_changed(tab):
	if(tab == 0):
		toggle()
	if(tab == 3):
		toggle()
		GlobalScenes.goto_main()
