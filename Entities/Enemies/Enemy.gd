extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var MOVEMENT_SPEED = 100
export var MAX_SPEED = 250
export var GRAVITY = 12

var velocity = Vector2(0,0)
export var FLOOR = Vector2(0,-1)
export var DETECT_DISTANCE = 200
export var GIVE_UP_DISTANCE = 250
export var ENEMY_DAMAGE = 15
export var MAX_ATTACKS = 5
export var attack_num = 0

var STATE = '_move'

onready var left_ground_ray = get_node("raycast_bl")
onready var right_ground_ray = get_node("raycast_br")
onready var left_ray = get_node("raycast_l")
onready var attack_ray = get_node("raycast_attack")
onready var damage_ray = get_node("raycast_damage")
onready var sight_ray_front = get_node("raycast_sight_front")
onready var sight_ray_back = get_node("raycast_sight_back")
onready var ground_ray = get_node("raycast_b")
onready var health_bar = get_node("Bar").get_node("bar_size").get_node("TextureProgress")

var move_left = true
var attack_rate = 0.25
var attack_time_left = 0
var attack_frames = 0
var parry_frames_min = 0
var parry_frames_max = 15

var attack_delay_rate = 0.8
var attack_delay_time_left = 0
var HEALTH = 100

var tired_rate = 1.5
var tired_time_left = 0
var dir_change_delay  = 0.2
var dir_change_time_left = 0

var dying_rate = 1
var dying_time_left = 0
var face_left =false

func _ready():
	add_collision_exception_with( GlobalScenes.current_scene.get_node("Player"))

func _physics_process(delta):
	
	#print(STATE)
	call(STATE, delta)
	
	if(ground_ray.is_colliding()):
		velocity.y = 0
	else:
		velocity.y += GRAVITY
	move_and_slide(velocity, FLOOR)


func damage(dmg):
	HEALTH  = max(HEALTH-dmg, 0)
	health_bar.UpdateProgress(HEALTH)
	SetSpriteFlash()
	if(HEALTH<=0):
		$AnimatedSprite.play("death")
		STATE = '_dying'
		dying_time_left = dying_rate

func flipRays(left):
	var angle = -90
	face_left = false
	$AnimatedSprite.flip_h = false

	if(left):
		angle = 90
		face_left = true
		$AnimatedSprite.flip_h = true

	attack_ray.rotation = deg2rad(angle)
	sight_ray_front.rotation = deg2rad(angle)
	sight_ray_back.rotation = deg2rad(-angle)
	damage_ray.rotation = deg2rad(angle)
	
func _move(delta):
	
	var player_pos = GlobalScenes.current_scene.get_node("Player").get_position()

	if((sight_ray_front.is_colliding() and sight_ray_front.get_collider().name == 'Player') 
	or (sight_ray_back.is_colliding() and sight_ray_back.get_collider().name == 'Player') ):
	   STATE = '_follow'
	else:
		
		if(not left_ground_ray.is_colliding()):
			move_left = false
		elif(not right_ground_ray.is_colliding()):
			move_left = true

		if(damage_ray.is_colliding() and damage_ray.get_collider().name =="front"): 
			move_left = !move_left

		if(move_left):
			velocity.x = -MOVEMENT_SPEED
			flipRays(true)
		else:
			velocity.x = MOVEMENT_SPEED
			flipRays(false)
			
	flipRays(move_left)
	$AnimatedSprite.play("move")
	

func _dying(delta):
	dying_time_left -=delta
	if(dying_time_left<=0):
		SpawnItem()

func _tired(delta):
	$AnimatedSprite.play("tired")
	tired_time_left-=delta
	if(tired_time_left<=0):
		STATE = '_follow'
		attack_num = 0 
	
func _attack(delta):
	attack_frames+=1
	attack_time_left -= delta
	$AnimatedSprite.play("attack")
	parry(delta)
	if(attack_time_left <= 0):
		attack_time_left = attack_rate
		var player_pos = GlobalScenes.current_scene.get_node("Player").get_position()
		
		if( (damage_ray.is_colliding() and damage_ray.get_collider().name == "Player")):
			Global.playerStats.Damage(ENEMY_DAMAGE)
			
		attack_delay_time_left = attack_delay_rate
		
		STATE = '_follow'
		attack_num+=1
			
	if(attack_num>=MAX_ATTACKS):
		StartedTiring()

func SetSpriteFlash():
	$AnimatedSprite._flash()

func StartedTiring():
	STATE = '_tired'
	tired_time_left = tired_rate
	velocity.x = 0
		
func parry(delta):
	#print("just attacked: ", GlobalScenes.current_scene.get_node("Player").raycast_attack.is_colliding(), " for ", attack_frames)
	if(GlobalScenes.current_scene.get_node("Player").just_attacked
	and GlobalScenes.current_scene.get_node("Player").raycast_attack.is_colliding() 
	and GlobalScenes.current_scene.get_node("Player").raycast_attack.get_collider().get_parent().get_instance_id() == get_instance_id()  
	#and attack_frames > parry_frames_min and attack_frames < parry_frames_max
	):
		StartedTiring()
	
func _follow(delta):
	attack_delay_time_left -=delta
	
	var player_pos = GlobalScenes.current_scene.get_node("Player").get_position()

	if(attack_delay_time_left >0):
		$AnimatedSprite.play("idle")
		velocity.x = 0
	elif( (attack_ray.is_colliding() and attack_ray.get_collider().name == "Player")):
		attack_time_left = attack_rate
		attack_frames = 0
		velocity.x = 0
		STATE = '_attack'
	else:
		if(position.distance_to(player_pos)>GIVE_UP_DISTANCE):
			STATE = '_move'
			
		else:
			dir_change_time_left-=delta
			if(dir_change_time_left <=0):
				dir_change_time_left = dir_change_delay
				if(player_pos.x<position.x):
					velocity.x = -MOVEMENT_SPEED
					print("left")
				else:
					print("right")
					velocity.x = MOVEMENT_SPEED
			
				flipRays(player_pos.x < position.x)
			
			$AnimatedSprite.play("move")
	

func SpawnItem():
	
	var item_scene = load("res://Items/HydrogenOrb/HydrogenOrb.tscn")
	var item = item_scene.instance()
	item.position = get_position()
	GlobalScenes.current_scene.add_child(item)
	self.queue_free()
	

func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		return true
	return false
