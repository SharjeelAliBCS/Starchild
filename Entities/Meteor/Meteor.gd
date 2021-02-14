extends KinematicBody2D

export var GRAVITY = 9.8

const FLOOR = Vector2(0,-1)

var velocity = Vector2()
func _ready():
	var rand = RandomNumberGenerator.new()
	
	var direction  = Vector2(0,1)
	rand.randomize()
	direction.x = rand.randf_range(-1,1)
	direction = direction.normalized()
	
	rand.randomize()
	var speed = rand.randf_range(400, 600)
	
	velocity = direction*speed
	
	var particle_dir = Vector2(-direction.x, -direction.y)
	$Particles2D.rotation += particle_dir.angle()
	print(direction.angle())
	
	add_collision_exception_with(GlobalScenes.current_scene.get_node("Player"))
	
func _physics_process(delta):
	if is_on_floor():
		SpawnItem()
	else:
		velocity = move_and_slide(velocity, FLOOR)
	

func SpawnItem():
	
	var item_scene = load("res://Items/UnknownSecretion/UnknownSecretion.tscn")
	var item = item_scene.instance()
	item.position = get_position()
	GlobalScenes.current_scene.add_child(item)
	self.queue_free()
