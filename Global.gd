extends Node2D

var playerStats = preload("Entities/Player/PlayerStats.gd").new()
var seedData = preload("res://Saves/SeedData.gd").new().saveDataInitial

const FILE_NAME = 'res://Saves/savefile.json'

var saveData = {}
var STATE = 'opening'

func _ready():
	pass

func StartNewGame():
	NewSave()
	LoadSave()
	LoadData()

func NewGame():
	playerStats = preload("Entities/Player/PlayerStats.gd").new()
	GlobalScenes.goto_story()

func PlayEnding():
	STATE = 'ending'
	var dir = Directory.new()
	dir.remove(FILE_NAME)
	GlobalScenes.goto_story()

func FinishGame():
	GlobalScenes.goto_main()
	STATE = 'opening'
	
func LoadGame():
	if(LoadSave()):
		LoadData()
	else:
		NewGame()
		
func LoadData():
	GlobalScenes.current_world = saveData['current_world']
	SetPlayerStats()
	SetWorldStats()
	GlobalScenes.goto_scene(saveData['current_world'])
	
func VecToArr(vec):
	return [vec.x, vec.y]
	
func ArrToVec(arr):
	return Vector2(arr[0], arr[1])

func SpawnableVecToArr(data):
	var new_data = []
	for i in data:
		var item = i.duplicate()
		item["position"] = VecToArr(item["position"])
		new_data.append(item)
	return new_data

func SpawnableArrToVec(data):
	var new_data = []
	for i in data:
		var item = i.duplicate()
		item["position"] = ArrToVec(item["position"])
		new_data.append(item)
	return new_data

func GetSkillValue(skill):
	var level = saveData['skills'][skill]['current_level']
	return saveData['skills'][skill]['values'][level]
	
func SetPlayerStats():
	playerStats.max_lifespan = GetSkillValue('lifespan')
	playerStats.lifespan = saveData['player']['lifespan']
	playerStats.max_fusion_energy = GetSkillValue('fusion_energy')
	playerStats.luminosity = GetSkillValue('luminosity')
	playerStats.blinding_light_duration =GetSkillValue('blinding_light')
	playerStats.sol_damage =GetSkillValue('sol')
	playerStats.attack_damage =GetSkillValue('attack')
	playerStats.hydrogen_orbs = saveData['items']['hydrogen_orbs']
	playerStats.unknown_secretions = saveData['items']['unknown_secretions']
	playerStats.keys = saveData['items']['keys']

func SetWorldStats():
	
	for i in GlobalScenes.worlds:
		GlobalScenes.worlds[i].player_position = ArrToVec(saveData['levels'][i]['player_position'])
		GlobalScenes.worlds[i].loaded_count = saveData['levels'][i]['loaded_count']
		GlobalScenes.worlds[i].enemies = SpawnableArrToVec(saveData['levels'][i]['enemies'])
		GlobalScenes.worlds[i].keys =  SpawnableArrToVec(saveData['levels'][i]['keys'])
		GlobalScenes.worlds[i].doors =  SpawnableArrToVec(saveData['levels'][i]['doors'])
		
func GetPlayerStats():
	saveData['player']['max_lifespan'] = playerStats.max_lifespan
	saveData['player']['max_fusion_energy'] = playerStats.max_fusion_energy
	saveData['player']['fusion_energy_rate'] = playerStats.fusion_energy_rate
	
	saveData['items']['hydrogen_orbs'] = playerStats.hydrogen_orbs
	saveData['items']['unknown_secretions'] = playerStats.unknown_secretions 
	saveData['items']['keys'] = playerStats.keys

func GetWorldStats():
	for i in GlobalScenes.worlds:
		saveData['levels'][i]['player_position'] = VecToArr(GlobalScenes.worlds[i].player_position)
		saveData['levels'][i]['loaded_count'] = GlobalScenes.worlds[i].loaded_count
		saveData['levels'][i]['enemies'] = SpawnableVecToArr(GlobalScenes.worlds[i].enemies)
		saveData['levels'][i]['keys'] = SpawnableVecToArr(GlobalScenes.worlds[i].keys)
		saveData['levels'][i]['doors'] = SpawnableVecToArr(GlobalScenes.worlds[i].doors)
		
#https://gdscript.com/solutions/how-to-save-and-load-godot-game-data/
func LoadSave():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			saveData = data
			return true
		else:
			printerr("Corrupted data!")
			return false
	else:
		return false

func NewSave():
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(seedData))
	file.close()
	
func SaveGame(world):
	saveData['current_world'] = world
	GetPlayerStats()
	GetWorldStats()
	OverwriteSave()
	
func OverwriteSave():
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(saveData))
	file.close()

func HasEncountered(key):
	return saveData['encountered'][key]

func Encountered(key):
	saveData['encountered'][key] = true
