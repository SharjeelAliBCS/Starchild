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

var mouse_direction = Vector2()

var moving = false

func _ready():
	can_infuse = true
	playerStats = Global.playerStats
	SwitchForms(false, true)

func _physics_process(delta):
	timer+=delta
	
	if(playerStats.is_dead):
		pass
	else:
		playerStats.Update(delta)
		OrbitSol()
		
		if(moving):
			sol_momentumX=false
			
		if(sol_momentumX):
			if(MomentumMovementX()):
				sol_momentumX = false
		if(sol_momentumY):
			if(MomentumMovementY()):
				sol_momentumY = false
				
		if Input.is_action_just_pressed("sol"):
			SwitchForms(!sol_form)
			
		if(sol_form):
			SolMovement()
			
		else:
			if Input.is_action_pressed("move_right"):
				if(lastPressed=="right"):
					if(velocity.x<MAX_SPEED):
						velocity.x  +=acceleration
					else:
						velocity.x = max(velocity.x-acceleration*2, MAX_SPEED)
					$player_sprite.flip_h = false
					moving = true
				else:
					if(velocity.x<0):
						velocity.x  = min(velocity.x+momentum,0)
					else:
						velocity.x = MOVEMENT_SPEED
						lastPressed ="right"
				
			elif Input.is_action_pressed("move_left"):
				
				if(lastPressed=="left"):
					if(velocity.x>-MAX_SPEED):
						velocity.x  -=acceleration
					else:
						velocity.x = min(velocity.x+acceleration*2, -MAX_SPEED)
					$player_sprite.flip_h = true
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
					$player_sprite.play("idle")
				moving = false
				
				lastPressed = ""
			
			if moving:
				$player_sprite.play("run")
							
			if Input.is_action_just_pressed("special_ability"):
				playerStats.DecreaseFusionEnergy(20)
			
			if Input.is_action_just_pressed("attack"):
				playerStats.hydrogen_orbs+=1
		
				
		if is_on_floor():
			velocity.y = 0
		
		if Input.is_action_pressed("jump"):
			
			if is_on_floor() or sol_form:
				velocity.y = -jump_power
				jumping = true
			elif jumping and velocity.y<0  and velocity.y>-200:
				print(velocity.y)
				velocity.y -= jump_acceleration
				
		if Input.is_action_just_released("jump"):
			if is_on_floor():
				jumping = false
			if(sol_form):
				SwitchForms(false)
				
		if(velocity.y<0):
			$player_sprite.play("jump")
		if can_infuse and playerStats.use_luminosity:
			
			if Input.is_action_just_released("decrease_fusion_rate"):
				ChangeFusionRate(-FUSION_RATE)
				
			elif Input.is_action_just_released("increase_fusion_rate"):
				ChangeFusionRate(FUSION_RATE)
			
		if Input.is_action_just_pressed("heal"):
			playerStats.HealHealth()
		
		
		if(!sol_form):
			velocity.y += GRAVITY
	
		move_and_slide(velocity, FLOOR)
		Collisions()

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
	
func SolMovement():
	if(playerStats.UseSolAbility()):
		
		
		var angle_diff = rad2deg(mouse_direction.angle_to(velocity))
		
		var threshold = 5
		
		if(abs(angle_diff)>threshold):
			
			var velocity_angle = rad2deg(velocity.angle())
			if(angle_diff>0):
				velocity_angle-=sol_control
			else:
				velocity_angle+=sol_control
			
			$sol_sprite.rotation = deg2rad(velocity_angle+90)
			velocity_angle = deg2rad(velocity_angle)
			velocity = Vector2(cos(velocity_angle), sin(velocity_angle)).normalized()*sol_speed
			

	else:
		SwitchForms(false)
		
func SwitchForms(var toSol, var  onStart = false):
	if(toSol && playerStats.fusion_energy>sol_fusion_min):
		sol_form = true
		$player_collision.disabled = true
		$sol_collision.disabled = false
		
		$player_sprite.set_visible(false)
		$sol_sprite.set_visible(true)
		
		velocity = mouse_direction*sol_speed
		
	else:
		sol_form = false
		$player_collision.disabled = false
		$sol_collision.disabled = true
		
		$player_sprite.set_visible(true)
		$sol_sprite.set_visible(false)
		if(not onStart):
			sol_momentumX = true
			sol_momentumY = true
		
		$player_sprite.flip_h = velocity.x<0
		
	
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
