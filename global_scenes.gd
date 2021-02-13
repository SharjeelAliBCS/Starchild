extends Node2D


export(String, FILE,  "*.tscn") var world_reality
export(String, FILE,  "*.tscn") var world_sol
export(String, FILE,  "*.tscn") var world_void

var worlds = {}
var current_scene = null
var current_world = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	worlds["reality"] =preload("Levels/world.gd").new()
	worlds["void"] =preload("Levels/world.gd").new()
	worlds["sol"] =preload("Levels/world.gd").new()
	
	worlds["reality"].file = "res://Levels/world_reality/WorldReality.tscn"
	worlds["void"].file = "res://Levels/world_deep/WorldDeep.tscn"
	worlds["sol"].file = "res://Levels/world_sol/world_sol.tscn"
	
func goto_scene(scene):
	worlds[current_world].player_position = current_scene.get_node("Player").get_position()
	worlds[current_world].loaded_count+=1
	call_deferred("_deferred_goto_scene", worlds[scene].file)

func _deferred_goto_scene(path):
	current_scene.free()

	var s = ResourceLoader.load(path)

	current_scene = s.instance()

	get_tree().get_root().add_child(current_scene)
	
	get_tree().set_current_scene(current_scene)

func LoadScene(scene):
	current_world = scene
	if(worlds[scene].loaded_count>0):
		current_scene.get_node("Player").set_position(worlds[scene].player_position)

