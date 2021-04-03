extends Node2D


export(String, FILE,  "*.tscn") var world_reality
export(String, FILE,  "*.tscn") var world_sol
export(String, FILE,  "*.tscn") var world_void

var worlds = {}
var current_scene = null
var current_world = null
var mainMenu = 'res://Menus/MainMenu/MainMenu.tscn'

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	worlds["reality"] =preload("Levels/world.gd").new()
	worlds["void"] =preload("Levels/world.gd").new()
	worlds["sol"] =preload("Levels/world.gd").new()
	
	worlds["reality"].file = "res://Levels/world_reality/WorldReality.tscn"
	worlds["void"].file = "res://Levels/world_deep/WorldDeep.tscn"
	worlds["sol"].file = "res://Levels/world_sol/world_sol.tscn"
#https://www.reddit.com/r/godot/comments/ccfgdw/how_would_you_go_about_loading_a_previous_scene/
func goto_scene(scene):
	Global.SaveGame(scene)
	if(current_world != 'sol' and current_world != scene):
		worlds[current_world].player_position = current_scene.get_node("Player").get_position()
	worlds[current_world].loaded_count+=1
	call_deferred("_deferred_goto_scene", worlds[scene].file)

func goto_main():
	call_deferred("_deferred_goto_scene", mainMenu)
	
func _deferred_goto_scene(path):
	current_scene.free()

	var s = ResourceLoader.load(path)

	current_scene = s.instance()

	get_tree().get_root().add_child(current_scene)
	
	get_tree().set_current_scene(current_scene)

func LoadScene(scene):
	current_world = scene
	current_scene.get_node("Player").set_position(worlds[scene].player_position)

func GetDialogBox():
	return current_scene.get_node("Interface/CanvasLayer/NinePatchRect/DialogPlayer")

func RemoveSpawnable(type, id):
	if(type == 'enemies'):
		var index = 0
		for i in len(worlds[current_world].enemies):
			if(worlds[current_world].enemies[i].id == id):
				index = i
				break
		worlds[current_world].enemies.remove(index)
		
	elif(type == 'doors'):
		var index = 0
		for i in len(worlds[current_world].doors):
			if(worlds[current_world].doors[i].id == id):
				index = i
				break
		worlds[current_world].doors.remove(index)
		
	elif(type == 'keys'):
		var index = 0
		for i in len(worlds[current_world].keys):
			if(worlds[current_world].keys[i].id == id):
				index = i
				break
		worlds[current_world].keys.remove(index)
