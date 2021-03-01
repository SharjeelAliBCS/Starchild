extends TextureProgress

export var NAME =""

func _ready():
	UpdateProgress(100)

func UpdateProgress(health_value):
	value = health_value
	
	
