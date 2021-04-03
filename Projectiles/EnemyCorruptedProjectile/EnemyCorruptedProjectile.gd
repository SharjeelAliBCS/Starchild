extends KinematicBody2D

var velocity = Vector2()
var speed = 400
var TIME = 0
var duration = 2
var damage = 20
var rotate_amount = 0.2
export var FLOOR = Vector2(0,-1)

func _ready():
	var player_pos = GlobalScenes.current_scene.get_node("Player").get_position()
	velocity = (player_pos-position).normalized()*speed
	
func _physics_process(delta):
	
	move_and_slide(velocity, FLOOR)
	TIME+=delta
	
	RotateTowardsPlayer()
	
	if(TIME>duration):
		self.queue_free()

func RotateTowardsPlayer():
	
	var threshold = 5
	
	var velocity_angle = rad2deg(velocity.angle())
	var player_pos = GlobalScenes.current_scene.get_node("Player").get_position()

	var player_direction = (player_pos-position).normalized()
	var angle_diff = rad2deg(player_direction.angle_to(velocity))
	
	if(abs(angle_diff)>threshold):
		
		if(angle_diff>0):
			velocity_angle-=rotate_amount
		else:
			velocity_angle+=rotate_amount
		
	velocity_angle = deg2rad(velocity_angle)
	velocity = Vector2(cos(velocity_angle), sin(velocity_angle)).normalized()*speed
		


func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		Global.playerStats.Damage(30)
		self.queue_free()

