extends Node2D

export var timer = 0
export var MAX_TIME = 5
export var world = 'reality'

var next_meteor_time
var corrupted_background = load("res://Assets/Graphics/Backgrounds/backgound_sol_corrupted.png")
var knowledge_found = false
var knowledge_time = 5
var knowledge_counter = 5
onready var fade = get_node("Fade/Fade")

func _ready():
	GlobalScenes.LoadScene(world) 
	GlobalScenes.current_scene.get_node("Player").SetInterfaceData()
	
	SetMeteorSpawnTimer()
	if(GlobalScenes.GetWorldCount()==0):
		GlobalDialog.ShowDialog("start_reality")
	SpawnData()
	if(not GlobalScenes.SpawnableExists('doors', 5)):
		LoadNewBackground()

func LoadNewBackground():
	get_node("Background/Sprite").set_texture(corrupted_background)
	
func SpawnData():
	for enemy in GlobalScenes.worlds[world].enemies:
		var item_scene
		if(enemy['type'] == 'corrupted'):
			item_scene = load("res://Entities/Enemies/EnemyCorrupted/EnemyCorrupted.tscn")
		elif(enemy['type'] == 'melee'):
			item_scene = load("res://Entities/Enemies/EnemyMelee/EnemyMelee.tscn")
		elif(enemy['type'] == 'ranged'):
			item_scene = load("res://Entities/Enemies/EnemyRanged/EnemyRanged.tscn")
		
		var item = item_scene.instance()
		item.id = enemy['id']
		item.position = enemy['position']
		add_child(item)
	
	for door in GlobalScenes.worlds[world].doors:
		var item_scene = load("res://Rigids/Door/Door.tscn")
		var item = item_scene.instance()
		item.id = door['id']
		item.position = door['position']
		add_child(item)
	
	for key in GlobalScenes.worlds[world].keys:
		var item_scene = load("res://Rigids/Key/Key.tscn")
		var item = item_scene.instance()
		item.id = key['id']
		item.position = key['position']
		add_child(item)
		
func SetMeteorSpawnTimer():
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	
	var next_time = rand.randf_range(2, 5)

	next_meteor_time = timer+next_time
	
func SpawnMeteor():
	
	if(not GlobalScenes.current_scene.get_node("Player").RoofAbove()):
		var rand = RandomNumberGenerator.new()
		var meteor_scene = load("res://Entities/Meteor/Meteor.tscn")
		var screen_size = get_viewport().get_visible_rect().size
		
		var camera_pos = GlobalScenes.current_scene.get_node("Player").get_node("Camera2D").get_camera_position()
		
		var meteor = meteor_scene.instance()
		rand.randomize()
		var x  = rand.randf_range(camera_pos.x-screen_size.x/2,camera_pos.x+screen_size.x/2)
		rand.randomize()
		var y  = camera_pos.y-screen_size.y*0.6
		meteor.position.y = y
		meteor.position.x = x
		add_child(meteor)
			
	SetMeteorSpawnTimer()
		
func _physics_process(delta):
	timer+=delta
	
	blackHoleDialog()
	knowledgeDialog()
	
	if(timer>=next_meteor_time):
		SpawnMeteor()
	
	if(knowledge_found):
		knowledge_counter-=delta
		
		if(knowledge_counter<=0):
			var faded = get_node("Fade").StartFading(Color(0,0,0,0))
			if(faded):
				Global.PlayEnding()
	else:
		if(GlobalScenes.current_scene.get_node("Player").playerStats.is_dead):
			GlobalScenes.switch_dimensions("sol")
		
	if Input.is_action_just_pressed("open_portal") and GlobalScenes.current_scene.get_node("Player").playerStats.OpenPortal():
		GlobalScenes.switch_dimensions("void")

func blackHoleDialog():
	if(get_node("Player").position.distance_to(Vector2(7300, 1000))<100 and
	not Global.HasEncountered('vonubris')):
		GlobalDialog.ShowDialog("vonubris")
		Global.Encountered('vonubris')

func knowledgeDialog():
	if(get_node("Player").position.distance_to(Vector2(9450, 325))<100 and
	not Global.HasEncountered('knowledge')):
		GlobalDialog.ShowDialog("knowledge")
		Global.Encountered('knowledge')
		knowledge_found = true
		knowledge_counter = knowledge_time
