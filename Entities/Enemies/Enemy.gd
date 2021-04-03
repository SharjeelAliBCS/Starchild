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
export var GIVE_UP_DISTANCE = 400
export var ENEMY_DAMAGE = 25
export var MAX_ATTACKS = 5
export var attack_num = 0

export var STATE = '_move'
export var PREV_STATE = '_move'

onready var left_ground_ray = get_node("raycast_bl")
onready var right_ground_ray = get_node("raycast_br")
onready var left_ray = get_node("raycast_l")
onready var attack_ray = get_node("raycast_attack")
onready var damage_ray = get_node("raycast_damage")
onready var sight_ray_front = get_node("raycast_sight_front")
onready var sight_ray_back = get_node("raycast_sight_back")
onready var health_bar = get_node("Bar")

var move_left = true
var attack_frames = 0
var parry_frames_min = 0
var parry_frames_max = 15

export var attack_delay_rate = 0.8
var attack_delay_time_left = 0
var HEALTH = 100

var tired_rate = 1.5
var tired_time_left = 0
var dir_change_delay  = 0.2
var dir_change_time_left = 0

var face_left =false
var animation = "_idle"
var change_dir_delay = 0.2
var change_dir_time = 0
var id = 0

var TIME = 0
func _ready():
	add_collision_exception_with( GlobalScenes.current_scene.get_node("Player"))

func _physics_process(delta):
	
	PlayAnimation()
	call(STATE, delta)
	
	if(is_on_floor()):
		velocity.y = 0
	else:
		velocity.y += GRAVITY
	move_and_slide(velocity, FLOOR)

func PlayAnimation():
	get_node("AnimationPlayer").play(animation)

func _knockback(delta):
	pass
	
func _dying(delta):
	pass
	
func damage(dmg):
	HEALTH  = max(HEALTH-dmg, 0)
	health_bar.Hit(HEALTH,dmg)
	SetSpriteFlash()
	if(HEALTH<=0):
		animation = "_dying"
		STATE = '_dying'
		velocity.x = 0
	else:
		PREV_STATE = STATE
		STATE = '_knockback'
		animation = '_knockback'
		velocity.x = 0

func SwitchToPrevState():
	STATE = PREV_STATE
	
func flipRays(left):

	var angle = -90
	face_left = false
	get_node("Sprite").scale.x = abs(get_node("Sprite").scale.x)

	if(left):
		angle = 90
		face_left = true
		get_node("Sprite").scale.x*= -1
	attack_ray.rotation = deg2rad(angle)
	sight_ray_front.rotation = deg2rad(angle)
	sight_ray_back.rotation = deg2rad(-angle)
	damage_ray.rotation = deg2rad(angle)

func ChangeMovementDirection(speed):
	if(move_left):
		velocity.x = -speed
		#print("moving left")
	else:
		#print("moving right")
		velocity.x = speed
		
	flipRays(move_left)

func _move(delta):
	
	change_dir_time = max(change_dir_time-delta, 0)
	var player_pos = GlobalScenes.current_scene.get_node("Player").get_position()

	if((sight_ray_front.is_colliding() and sight_ray_front.get_collider().name == 'Player') 
	or (sight_ray_back.is_colliding() and sight_ray_back.get_collider().name == 'Player') ):
	   STATE = '_follow'
	   change_dir_time = 0
	else:
		
		if(not left_ground_ray.is_colliding()):
			move_left = false
		elif(not right_ground_ray.is_colliding()):
			move_left = true
		
		if(change_dir_time <=0 and attack_ray.is_colliding() and (attack_ray.get_collider().name == "front" or "Door" in attack_ray.get_collider().name)): 
			move_left = !move_left
			change_dir_time = change_dir_delay

		ChangeMovementDirection(MOVEMENT_SPEED)
	#print(velocity.x)
	animation = "_move"
	
func _tired(delta):
	animation = "_tired"
	tired_time_left-=delta
	if(tired_time_left<=0):
		STATE = '_follow'
		attack_num = 0 

func SetSpriteFlash():
	$Sprite._flash()

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

func StartAttack():
	pass
	
func _follow(delta):
	pass
	
func SpawnItem():
	GlobalScenes.RemoveSpawnable('enemies', id)
	var item_scene = load("res://Items/HydrogenOrb/HydrogenOrb.tscn")
	var item = item_scene.instance()
	item.position = get_position()
	GlobalScenes.current_scene.add_child(item)
	self.queue_free()
	

