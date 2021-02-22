extends KinematicBody2D

var playerStats

var prevPosition = Vector2()
var positions = []
var timer = 0
var mimic_delay = 2
func _ready():
	pass

func _physics_process(delta):
	timer+=delta
	if(Global.playerStats.is_dead):
		pass
	else:
		var new_position =  GlobalScenes.current_scene.get_node("Player").get_position()
		positions.append(new_position)
		if(timer>mimic_delay):
			var curr_position = positions.pop_front()
			print(curr_position)
			position = curr_position
			
			if(prevPosition.x<curr_position.x):
				$sprite.play("run")
				$sprite.flip_h = false
			else:
				$sprite.play("run")
				$sprite.flip_h = true
			if(prevPosition.y<curr_position.y):
				pass

			if(prevPosition==curr_position):
				$sprite.play("idle")
				
			
			prevPosition = curr_position
		
