extends HBoxContainer

export var NAME =""
var hit_time =  0.3
var hit_timer = 0

func _ready():
	UpdateProgress(100)
	$Node2D/Label.visible =  false

func Hit(health_value, damage):
	UpdateProgress(health_value)
	hit_timer = hit_time
	$Node2D/Label.visible =  true
	$Node2D/Label.text =  '-'+String(damage)
	
func UpdateProgress(health_value):
	$bar_size/TextureProgress.value = health_value


func  _process(delta):
	hit_timer = max(hit_timer-delta, 0)
	if(hit_timer <= 0):
		$Node2D/Label.visible =  false
