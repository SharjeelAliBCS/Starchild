extends Area2D

export var TIME = 0.3
var timer = 0
var scale_time = 10

var enemies = {}
func _ready():
	scale = Vector2(0,0)
	print("time is ", TIME)

func _process(delta):
	timer+= delta
	IncreaseSize(delta)
	CheckTime(delta)

func IncreaseSize(delta):
	scale.x += scale_time*delta
	scale.y += scale_time*delta
	
func CheckTime(delta):
	if(timer > TIME):
		self.queue_free()
		
func _on_BlindingLight_body_entered(body):

	if "Enemy" in body.name and not enemies.has(body.name):
		print("and collided with ", body.name)
		enemies[body.name] = true
		body.StartedTiring()
