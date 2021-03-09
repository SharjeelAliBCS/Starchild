extends AnimatedSprite

var flash_time = 0.2
var flash_time_left = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	flash_time_left-=delta
	if(flash_time_left<=0):
		material.set_shader_param("flash", false)
	else:
		material.set_shader_param("flash", true)
func _flash():
	if(flash_time_left <=0.0):
		flash_time_left = flash_time

