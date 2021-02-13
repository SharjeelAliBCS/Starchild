extends KinematicBody2D

var playerStats

export var MOVEMENT_SPEED = 120
export var RUN_SPEED_MULTIPLYER = 1.5
export var GRAVITY = 9.8
export var JUMP_POWER  =270
export var FLOOR = Vector2(0,-1)

var FUSION_RATE = 0.02
var FUSION_DELAY = 0.01
var can_infuse

var running = false

var velocity = Vector2()

func _ready():
	can_infuse = true
	playerStats = Global.playerStats

func _physics_process(delta):
	 
	if(playerStats.is_dead):
		pass
	else:
		playerStats.Update(delta)
		
		var moving =false
		if Input.is_action_pressed("move_right"):
			velocity.x = MOVEMENT_SPEED
			$player_sprite.flip_h = false
			moving = true
			
		elif Input.is_action_pressed("move_left"):
			velocity.x= -MOVEMENT_SPEED
			$player_sprite.flip_h = true
			moving = true

		else:
			velocity.x =  0
			if is_on_floor():
				$player_sprite.play("idle")
			moving = false
		
		if moving:
			
			if Input.is_action_pressed("run"):
				velocity.x*=RUN_SPEED_MULTIPLYER
				$player_sprite.play("run")
			else:
				$player_sprite.play("walk")
			
		if Input.is_action_pressed("jump") and is_on_floor():
			velocity.y = -JUMP_POWER
			$player_sprite.play("jump")
		
		if can_infuse and playerStats.use_luminosity:
			
			if Input.is_action_just_released("decrease_fusion_rate"):
				ChangeFusionRate(-FUSION_RATE)
				
			elif Input.is_action_just_released("increase_fusion_rate"):
				ChangeFusionRate(FUSION_RATE)
				
		if Input.is_action_just_pressed("special_ability"):
			playerStats.DecreaseFusionEnergy(20)
		
		if Input.is_action_just_pressed("attack"):
			playerStats.hydrogen_orbs+=1
			
		if Input.is_action_just_pressed("heal"):
			playerStats.HealHealth()
		
		velocity.y += GRAVITY
		
		move_and_slide(velocity, FLOOR)

func ChangeFusionRate(value):
	
	can_infuse = false
	playerStats.UpdateLifeRate(value)
	SetInterfaceData()
	yield(get_tree().create_timer(FUSION_DELAY), "timeout")
	can_infuse = true
		
		
func SetInterfaceData():
	$player_light.scale = playerStats.GetLightSize()
