extends KinematicBody2D

var playerStats

export var MOVEMENT_SPEED = 150
export var MAX_SPEED = 250
export var GRAVITY = 12

var jump_acceleration = 8
var jump_power = 150
export var FLOOR = Vector2(0,-1)
var momentum  = 15

var FUSION_RATE = 0.04
var FUSION_DELAY = 0.01
var can_infuse

var running = false

var velocity = Vector2(0,0)
var acceleration = 1
var jumping = false
var lastPressed = ""
var timer = 0

var sol_distance = 50
var sol_form = false
var sol_speed = 500
var sol_control = 5
var sol_fusion_min = 10
var sol_momentumX  = false
var sol_momentumY  = false

var just_attacked = false

var face_left = true

var dodge_speed = 900
var dodge_time = 0.1
var dodge_time_left = 0
export var STATE = '_move'
var animation = "_idle"
var mouse_direction = Vector2()

var knockback_speed = 300
export var INVULNERABLE = false

onready var sol_ray = get_node("sol").get_node("raycast_sol")

var moving = false

onready var raycast_attack = get_node("raycast_attack")

func _ready():
	can_infuse = true
	playerStats = Global.playerStats
	playerStats.life_rate = playerStats.default_life_rate
	playerStats.lifespan = playerStats.max_lifespan
	SwitchForms(false, true)

func PlayAnimation():
	get_node("AnimationPlayer").play(animation)

func FlipNodes(flip):
	
	if(flip and get_node("Sprite").scale.x >=0):
		get_node("Sprite").scale.x*= -1
		raycast_attack.rotation = deg2rad(90)
	elif(not flip):
		raycast_attack.rotation = deg2rad(-90)
		get_node("Sprite").scale.x = abs(get_node("Sprite").scale.x)
	
func SetSpriteFlash():
	get_node("Sprite")._flash()
	pass

func _physics_process(delta):
	timer+=delta
	PlayAnimation()
	
	
	if(Input.is_action_just_pressed("ui_cancel")):
		GlobalScenes.current_scene.get_node('Menu').toggle()
		
	if(playerStats.is_dead):
		pass
	else:
		playerStats.Update(delta)
		heartBeatSfx()
		OrbitSol()
		
		if Input.is_action_just_pressed("sol"):
			SwitchForms(!sol_form)
		
		if Input.is_action_just_pressed("interact"):
			if raycast_attack.is_colliding() and "Door" in raycast_attack.get_collider().name and playerStats.keys > 0:
				if(raycast_attack.get_collider().id == 5):
					GlobalScenes.current_scene.LoadNewBackground()
				GlobalScenes.RemoveSpawnable('doors', raycast_attack.get_collider().id)
				raycast_attack.get_collider().queue_free()
				playerStats.UseKey()
				
		if Input.is_action_just_pressed("heal"):
			playerStats.HealHealth()
					
		if Input.is_action_just_pressed("special_ability"):
			playerStats.DecreaseFusionEnergy(20)
		
		if Input.is_action_just_pressed("dodge") and STATE != '_dodge' and playerStats.Dodge():
			STATE = '_dodge'
			dodge_time_left = dodge_time
			playerStats.playerDodging = true
			
		if Input.is_action_just_pressed("attack") and not "attack" in animation and playerStats.Attack():
			STATE = '_attack'
			velocity.x = 0
			just_attacked = true
			animation = '_attack'
			moving = false
			onStopSfx("sfx_swing")
			onPlaySfx("sfx_swing")
			if(get_node("Sprite").scale.x <0):
				face_left = true
				raycast_attack.rotation = deg2rad(90)
			else:
				face_left = false
				raycast_attack.rotation = deg2rad(-90)
		else:
			just_attacked = false
			
		if playerStats.blinding_light_duration > 0 &&  Input.is_action_just_pressed("blinding_light") and not "blinding_light" in animation and playerStats.BlindingLight():
			STATE = '_blindingLight'
			animation = "_blinding_light"
				
		call(STATE,delta)
		
		move_and_slide(velocity, FLOOR)
		Collisions()
		CheckDoorCollision()
		
func _blindingLight(delta):
	pass
func _dodge(delta):
	dodge_time_left-=delta
	if(dodge_time_left<=0):
		playerStats.playerDodging = false
		STATE = '_move'
		if(face_left):
			velocity.x = -MOVEMENT_SPEED
		else:
			velocity.x = MOVEMENT_SPEED
	else:
		if(face_left):
			velocity.x = - dodge_speed
		else:
			velocity.x = dodge_speed

func SpawnBlindingLight():
	STATE = '_move'
	var scene = load("res://Projectiles/BlindingLight/BlindingLight.tscn")
	var node = scene.instance()
	node.TIME = playerStats.blinding_light_duration
	add_child(node)

func Knockbacked(hitFromLeft):
	STATE = '_knockback'
	animation = '_knockback'
	FlipNodes(not hitFromLeft)

	if(hitFromLeft):
		velocity.x = - knockback_speed
	else:
		velocity.x = knockback_speed
	 
func _knockback(delta):
	pass
func _attack(delta):
	#$player_sprite.play("attack")
	pass
	
func Attack():
	if(raycast_attack.is_colliding()):
		var node = raycast_attack.get_collider()
		if("Enemy" in node.name 
		and (node.STATE == '_tired' or node.face_left == face_left)):
			node.damage(playerStats.GetAttackDamage())
			INVULNERABLE = true
			animation = "_attack_hit"
		else:
			animation = "_attack_miss"
	else:
		animation = "_attack_miss"
			
func _sol(delta):
	SolMovement()
	
func _move(delta):
	if(moving):
		sol_momentumX=false
	if(sol_momentumX):
		if(MomentumMovementX()):
			sol_momentumX = false
	if(sol_momentumY):
		if(MomentumMovementY()):
			sol_momentumY = false

	MoveVertical(delta)
	MoveHorizontal(delta)

func CheckDoorCollision():
	if raycast_attack.is_colliding() and not raycast_attack.get_collider() == null:
		if "Door" in raycast_attack.get_collider().name:
			if(playerStats.keys > 0):
				GlobalDialog.ShowDialog("door_unlocked")
			else:
				GlobalDialog.ShowDialog("door_locked")
		else:
			GlobalDialog.RemoveDialog("door")
	else:
		GlobalDialog.RemoveDialog("door")

func MoveVertical(delta):
	if is_on_floor():
		velocity.y = 0
	
	if Input.is_action_pressed("jump"):
		
		if is_on_floor() or sol_form:
			velocity.y = -jump_power
			jumping = true
		elif jumping and velocity.y<0  and velocity.y>-200:
			velocity.y -= jump_acceleration
			
	if Input.is_action_just_released("jump"):
		if is_on_floor():
			jumping = false
			
	if(velocity.y<0):
		animation = "_jump"
	if can_infuse and playerStats.use_luminosity:
		
		if Input.is_action_just_released("decrease_fusion_rate"):
			ChangeFusionRate(-FUSION_RATE)
			
		elif Input.is_action_just_released("increase_fusion_rate"):
			ChangeFusionRate(FUSION_RATE)
		

	velocity.y += GRAVITY

func MoveHorizontal(delta):
	if Input.is_action_pressed("move_right"):
		FlipNodes(false)
		if(lastPressed=="right"):
			if(velocity.x<MAX_SPEED):
				velocity.x  +=acceleration
			else:
				velocity.x = max(velocity.x-acceleration*2, MAX_SPEED)
			face_left = false
			moving = true
		else:
			if(velocity.x<0):
				velocity.x  = min(velocity.x+momentum,0)
			else:
				velocity.x = MOVEMENT_SPEED
				lastPressed ="right"
		
	elif Input.is_action_pressed("move_left"):
		FlipNodes(true)
		if(lastPressed=="left"):
			if(velocity.x>-MAX_SPEED):
				velocity.x  -=acceleration
			else:
				velocity.x = min(velocity.x+acceleration*2, -MAX_SPEED)
			face_left = true
			moving = true
		else:
			if(velocity.x>0):
				velocity.x =max(velocity.x-momentum,0)
			else:
				velocity.x = -MOVEMENT_SPEED
				lastPressed = "left"
		
	else:
		MomentumMovementX()
		if is_on_floor():
			animation = "_idle"
		moving = false
		
		lastPressed = ""
	
	if moving:
		animation = "_run"
			
func MomentumMovementY():
	velocity.y +=GRAVITY*0.5
	return velocity.y>=0
	
func MomentumMovementX():
	
	var momentum_speed = momentum
	if(sol_momentumX):
		momentum_speed  = momentum_speed*0.5
	if(velocity.x>0):
		velocity.x -=momentum_speed
		if(velocity.x<0):
			velocity.x = 0
	elif(velocity.x<0):
		velocity.x +=momentum_speed
		if(velocity.x>0):
			velocity.x = 0
	
	return velocity.x<=0

func RoofAbove():
	return get_node("meteor_detection").is_colliding()
		
func SpawnExplosion():
	
	var item_scene = load("res://Particles/SolExplosion/SolExplosion.tscn")
	var item = item_scene.instance()
	item.position = get_position()
	GlobalScenes.current_scene.add_child(item)
	
func SolMovement():
	
	if Input.is_action_just_released("jump"):
		SwitchForms(false)
			
	if(playerStats.UseSolAbility()):
		
		if(sol_ray.is_colliding() and "Enemy" in sol_ray.get_collider().name):
			SwitchForms(false)
			sol_ray.get_collider().damage(playerStats.GetSolDamage())
			SpawnExplosion()
		var angle_diff = rad2deg(mouse_direction.angle_to(velocity))
		
		var threshold = 5
		
		var velocity_angle = rad2deg(velocity.angle())
		if(abs(angle_diff)>threshold):
			
			if(angle_diff>0):
				velocity_angle-=sol_control
			else:
				velocity_angle+=sol_control
			
		$sol.rotation = deg2rad(velocity_angle+90)
		velocity_angle = deg2rad(velocity_angle)
		velocity = Vector2(cos(velocity_angle), sin(velocity_angle)).normalized()*sol_speed
			
	else:
		SwitchForms(false)
		
func SwitchForms(var toSol, var  onStart = false):
	if(toSol && playerStats.fusion_energy>sol_fusion_min):
		sol_form = true
		$player_collision.disabled = true
		$sol_collision.disabled = false
		get_node("Sprite").set_visible(false)
		$sol.set_visible(true)
		
		velocity = mouse_direction*sol_speed
		onPlaySfx("sfx_sol_start")
		STATE = '_sol'
		
	else:
		sol_form = false
		$player_collision.disabled = false
		$sol_collision.disabled = true
		get_node("Sprite").set_visible(true)
		$sol.set_visible(false)
		if(not onStart):
			sol_momentumX = true
			sol_momentumY = true
			onPlaySfx("sfx_sol_end")
		$sol.rotation = 0
		FlipNodes(velocity.x<0)
		face_left = velocity.x
		onStopSfx("sfx_sol_start")
		STATE = '_move'
		
	
func OrbitSol():
	var mouse_pos = get_global_mouse_position()
	
	mouse_direction = (mouse_pos-position).normalized()
	var sol_pos = mouse_direction*sol_distance
	$Sol.set_position(sol_pos)
			
func Collisions():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if(collision.collider.name=="Unknown"):
			playerStats.is_dead = true
	
func ChangeFusionRate(value):
	
	can_infuse = false
	playerStats.UpdateLifeRate(value)
	SetInterfaceData()
	yield(get_tree().create_timer(FUSION_DELAY), "timeout")
	can_infuse = true

func SetInterfaceData():
	get_node("Sol").get_node("player_light").scale = playerStats.GetLightSize()

func heartBeatSfx():
	var rate = playerStats.GetHeartBeatRate()
	get_node("sfx_heartbeat").set_pitch_scale(rate)

func onPlaySfx(name):
	if not get_node(name).playing:
		get_node(name).play()
		
func onStopSfx(name):
	get_node(name).stop()
	


func _on_Area2D_body_entered(body):
	if "foreground" in body.name:
		playerStats.playerSafe = true
		#"safe!")


func _on_Area2D_body_exited(body):
	playerStats.playerSafe = false
	#"oh no!")
