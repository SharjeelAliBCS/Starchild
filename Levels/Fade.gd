extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var fadeColor = Color(0,0,0,0)

var fade_time = 5
var fade_current_time = -1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func StartFading(color):
	if(fade_current_time == -1):
		fadeColor = color
		fade_current_time = 0
		$Fade.visible = true

	return fadeColor.a >= 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(fade_current_time >=0):
		fade_current_time = min(fade_time, fade_current_time+delta)
		fadeColor.a = float(fade_current_time)/float(fade_time)
		$Fade.color = fadeColor
		
