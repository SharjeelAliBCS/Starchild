extends Node2D

export var timer = 0
export var MAX_TIME = 5
export var world = 'void'

func _ready():
	GlobalScenes.LoadScene(world)
	GlobalScenes.current_scene.get_node("Player").SetInterfaceData()
	if(GlobalScenes.GetWorldCount()==1):
		GlobalDialog.ShowDialog("start_void")
	SpawnData()
	
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
		var item_scene = load("res://Items/Key/Key.tscn")
		var item = item_scene.instance()
		item.id = key['id']
		item.position = key['position']
		add_child(item)
	
func _physics_process(delta):
	timer+=delta
	
	if(GlobalScenes.current_scene.get_node("Player").playerStats.is_dead):
		print("changed worlds")
		Global.SaveGame('sol')
		GlobalScenes.switch_dimensions("sol")
		
	if Input.is_action_just_pressed("open_portal") and GlobalScenes.current_scene.get_node("Player").playerStats.OpenPortal():
		Global.SaveGame('reality')
		GlobalScenes.switch_dimensions("reality")
		
	
		
	
