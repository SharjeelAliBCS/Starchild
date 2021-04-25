extends "../Enemy.gd"

var MAX_RUN_DISTANCE = 200
var RUN_SPEED = 120
var MAX_SPACE_DISTANCE = 200
var prev_position = Vector2()

var finished_running = true
func _ready():
	STATE = '_move'
	MOVEMENT_SPEED = 70
	attack_delay_rate = 2
	tired_rate = 4
	MAX_ATTACKS = 3
	._ready()

func _physics_process(delta):
	call(STATE, delta)
	
	if(is_on_floor()):
		velocity.y = 0
	else:
		velocity.y += GRAVITY
	move_and_slide(velocity, FLOOR)
	TIME+=delta

func _attack(delta):
	attack_frames+=1
	#"attacking: ", TIME)
	
func StartAttack():
	attack_frames = 0
	velocity.x = 0
	STATE = '_attack'
	animation = "_attack"

func _runaway(delta):
	
	change_dir_time = max(change_dir_time-delta, 0)
	
	if(position.distance_to(prev_position)>=MAX_RUN_DISTANCE):
		STATE = '_follow'
		velocity.x = 0
		animation = "_idle"
		finished_running = true
		flipRays(GlobalScenes.current_scene.get_node("Player").get_position().x < position.x)
	else:
		if(change_dir_time <=0 and attack_ray.is_colliding() and (attack_ray.get_collider().name == "front" or "Door" in attack_ray.get_collider().name)): 
			move_left = !move_left
			prev_position = position
			change_dir_time = change_dir_delay
			
			ChangeMovementDirection(RUN_SPEED)

func _follow(delta):
	attack_num = 0
	attack_delay_time_left -=delta
	
	var player_pos = GlobalScenes.current_scene.get_node("Player").get_position()
	
	if(position.distance_to(player_pos)<=MAX_SPACE_DISTANCE):
		STATE = '_shoot'
		animation = '_idle'
		velocity.x = 0
	else:
		if(player_pos.x < position.x):
			velocity.x = -MOVEMENT_SPEED
		else:
			velocity.x = MOVEMENT_SPEED
		
		flipRays(player_pos.x < position.x)
	PlayerTooClose()
	
	if(position.distance_to(player_pos)>GIVE_UP_DISTANCE):
		STATE = '_move'
		
func _shoot(delta):
	attack_delay_time_left -= delta
	PlayerTooClose()
	
	if(attack_delay_time_left<=0):
		STATE = '_attack'
		animation = '_attack'

func fire():
	var player_pos = GlobalScenes.current_scene.get_node("Player").get_position()
	flipRays(player_pos.x < position.x)
	
	#"firing: ", attack_num)
	attack_delay_time_left = attack_delay_rate
	STATE = '_shoot'
	animation = '_idle'
	
	var projectile_scene = load("res://Projectiles/EnemyProjectile/EnemyProjectile.tscn")
	var projectile = projectile_scene.instance()
	projectile.position = get_position()
	GlobalScenes.current_scene.add_child(projectile)
	
	attack_num+=1
	if(attack_num>=MAX_ATTACKS):
		StartedTiring()
	
	
func PlayerTooClose():
	if(not finished_running or (attack_ray.is_colliding() and attack_ray.get_collider().name == "Player")):
		StartRunning()
	
func StartRunning():
	var player_pos = GlobalScenes.current_scene.get_node("Player").get_position()
	#"started running")
	STATE = '_runaway'
	move_left = player_pos > position
	prev_position = position
	animation = '_move'
	finished_running = false
	if(sight_ray_back.is_colliding() and sight_ray_back.get_collider().name == "front"):
		move_left = !move_left
		
	ChangeMovementDirection(RUN_SPEED)
	
