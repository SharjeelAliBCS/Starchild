extends "../Enemy.gd"

var FOLLOW_SPEED = 120

var MAX_RUN_DISTANCE = 200
var RUN_SPEED = 120
var CHARGE_SPEED = 300
var OOZE_SPEED = 400
var MAX_SPACE_DISTANCE = 200
var MOVE_DOWN_DISTANCE = 75
var prev_position = Vector2()

var finished_running = true
var ooze_dir = 'down'
onready var ooze = get_node("EnemyCorruptedOoze")

func _ready():
	MOVEMENT_SPEED = 70
	ooze.visible = false
	attack_delay_rate = 2
	._ready()

func _physics_process(delta):
	PlayAnimation()
	call(STATE, delta)
	
	if(is_on_floor()):
		velocity.y = 0
	else:
		velocity.y += GRAVITY
	move_and_slide(velocity, FLOOR)

func HitPlayer():
	var player_pos = GlobalScenes.current_scene.get_node("Player").get_position()
	var invulnerable = GlobalScenes.current_scene.get_node("Player").INVULNERABLE
	if( (attack_ray.is_colliding() and attack_ray.get_collider().name == "Player")) and not invulnerable:
		Global.playerStats.Damage(ENEMY_DAMAGE)
		GlobalScenes.current_scene.get_node("Player").Knockbacked(face_left)
	attack_delay_time_left = attack_delay_rate
	
	STATE = '_follow'
	attack_num+=1
		
func _attack(delta):
	attack_frames+=1
	parry(delta)
	
func StartAttack():
	attack_frames = 0
	velocity.x = 0
	STATE = '_attack'
	animation = "_attack"

func _charge(delta):

	var player_pos = GlobalScenes.current_scene.get_node("Player").get_position()

	if( (attack_ray.is_colliding() and attack_ray.get_collider().name == "Player")):
		StartAttack()
	else:
		if(position.distance_to(player_pos)>GIVE_UP_DISTANCE):
			STATE = '_move'
			
		else:
			dir_change_time_left-=delta
			if(dir_change_time_left <=0):
				dir_change_time_left = dir_change_delay
				if(player_pos.x<position.x):
					velocity.x = -CHARGE_SPEED
				else:
					velocity.x = CHARGE_SPEED
			
				flipRays(player_pos.x < position.x)
			
			animation = "_move"
	
func _follow(delta):
	attack_delay_time_left -=delta
	
	var player_pos = GlobalScenes.current_scene.get_node("Player").get_position()

	if(attack_delay_time_left >0):
		animation = "_idle"
		velocity.x = 0
	elif( (attack_ray.is_colliding() and attack_ray.get_collider().name == "Player")):
		StartAttack()
	else:
		if(position.distance_to(player_pos)>GIVE_UP_DISTANCE):
			STATE = '_move'
			
		else:
			dir_change_time_left-=delta
			if(dir_change_time_left <=0):
				dir_change_time_left = dir_change_delay
				if(player_pos.x<position.x):
					velocity.x = -FOLLOW_SPEED
				else:
					velocity.x = FOLLOW_SPEED
			
				flipRays(player_pos.x < position.x)
			
			animation = "_move"
	
func _runaway(delta):
	
	change_dir_time = max(change_dir_time-delta, 0)
	
	if(ooze_dir == 'down'):
		if(ooze.position.y>=MOVE_DOWN_DISTANCE):
			ooze_dir = 'across'	
			print("started moving across")
			ChangeMovementDirection(RUN_SPEED)
			ooze.velocity  = Vector2(0,0)
			ooze.rotation = deg2rad(180)
			
			if(move_left):
				ooze.rotation = deg2rad(-90)
			else:	
				ooze.rotation = deg2rad(90)
			
	elif(ooze_dir == 'up'):
		if(ooze.position.y <=0):
			
			var rand = RandomNumberGenerator.new()
			rand.randomize()
			var action  = rand.randi_range(0,1)
			if(action == 0):
				STATE = '_shoot'
				animation = "_shoot"
			else:
				STATE = '_charge'
				animation = "_idle"
				attack_delay_time_left = 0
				
			finished_running = true
			$Sprite.visible  = true
			$Bar.visible = true
			ooze.velocity  = Vector2(0,0)
			ooze.position = Vector2(0,0)
			ooze.visible = false
			flipRays(GlobalScenes.current_scene.get_node("Player").get_position().x < position.x)
	else:
		if(position.distance_to(prev_position)>=MAX_RUN_DISTANCE):
			
			ooze.velocity  = Vector2(0,-OOZE_SPEED)
			velocity.x = 0
			ooze_dir = "up"
			ooze.rotation = deg2rad(0)
		else:
			if(change_dir_time <=0 and attack_ray.is_colliding() and (attack_ray.get_collider().name == "front" or "Door" in attack_ray.get_collider().name)): 
				move_left = !move_left
				prev_position = position
				change_dir_time = change_dir_delay
				
				ChangeMovementDirection(RUN_SPEED)
				
				if(move_left):
					ooze.rotation = deg2rad(-90)
				else:	
					ooze.rotation = deg2rad(90)

func StartRunning():
	var player_pos = GlobalScenes.current_scene.get_node("Player").get_position()
	STATE = '_runaway'
	move_left = player_pos > position
	prev_position = position
	animation = '_move'
	finished_running = false
	$Sprite.visible  = false
	$Bar.visible = false
	ooze.visible = true
	ooze_dir = 'down'
	ooze.velocity = Vector2(0, OOZE_SPEED)
	ooze.rotation = deg2rad(180)
	
	if(sight_ray_back.is_colliding() and sight_ray_back.get_collider().name == "front"):
		move_left = !move_left
		
func _shoot(delta):
	pass

func fire():
	var player_pos = GlobalScenes.current_scene.get_node("Player").get_position()
	flipRays(player_pos.x < position.x)
	attack_delay_time_left = attack_delay_rate
	StartRunning()
	
	var projectile_scene = load("res://Projectiles/EnemyCorruptedProjectile/EnemyCorruptedProjectile.tscn")
	var projectile = projectile_scene.instance()
	projectile.position = get_position()
	GlobalScenes.current_scene.add_child(projectile)
	
	
	
