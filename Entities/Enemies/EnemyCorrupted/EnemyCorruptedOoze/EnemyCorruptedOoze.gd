extends KinematicBody2D

var velocity = Vector2()
export var FLOOR = Vector2(0,-1)

func _ready():
	pass
func _physics_process(delta):
	
	move_and_slide(velocity, FLOOR)
