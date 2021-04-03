extends "../Enemy.gd"


func _ready():
	MOVEMENT_SPEED = 70
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
		
	if(attack_num>=MAX_ATTACKS):
		StartedTiring()
		
func _attack(delta):
	attack_frames+=1
	parry(delta)
	
func StartAttack():
	attack_frames = 0
	velocity.x = 0
	STATE = '_attack'
	animation = "_attack"
	
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
					velocity.x = -MOVEMENT_SPEED
				else:
					velocity.x = MOVEMENT_SPEED
			
				flipRays(player_pos.x < position.x)
			
			animation = "_move"
	
