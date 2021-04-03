extends Node2D


var normalColor = Vector3(255, 255, 255)
var enrageColor = Vector3(255, 185, 0)

var switchColor = normalColor

var switchDuration = 0
var switchTime = 0


var STATE = '_idle'
# Called when the node enters the scene tree for the first time.
func _ready():
	setColor(normalColor)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	call(STATE, delta)

func StartEnraging(time):
	switchDuration = time
	STATE  = '_startEnraging'
	
func StopEnraging(time):
	switchDuration = time
	STATE  = '_stopEnraging'
	#setColor(normalColor)
	

func _startEnraging(delta):
	switchTime+=delta
	switchColor = normalColor
	switchColor.x += (enrageColor.x-normalColor.x)*(switchTime/switchDuration)
	switchColor.y += (enrageColor.y-normalColor.y)*(switchTime/switchDuration)
	switchColor.z += (enrageColor.z-normalColor.z)*(switchTime/switchDuration)
	setColor(switchColor)
	
	if(switchTime>=switchDuration):
		STATE = '_idle'
		switchTime = 0

func _stopEnraging(delta):
	switchTime+=delta
	switchColor = enrageColor
	switchColor.x += (normalColor.x-enrageColor.x)*(switchTime/switchDuration)
	switchColor.y += (normalColor.y-enrageColor.y)*(switchTime/switchDuration)
	switchColor.z += (normalColor.z-enrageColor.z)*(switchTime/switchDuration)
	setColor(switchColor)
	
	if(switchTime>=switchDuration):
		STATE = '_idle'
		switchTime = 0

func _idle(delta):
	pass
	
func setColor(color):
	var colorNormalized =  Color(color.x/255, color.y/255, color.z/255)

	modulate = colorNormalized
