extends Control

var upgrade_nodes = {}
var stat_nodes = {}

onready var hydrogenOrbs = $Container/Top/HBoxContainer/HydrogenOrbCount
onready var level = $Container/Top/level

onready var totalNode = $Container/Costs/TotalCount
onready var costNode = $Container/Costs/CostCount
onready var leftNode = $Container/Costs/LeftCount

var skills = {}
var new_skills = {}

var curr_level
var added_levels =  0
var cost = 0
var total = 0


#https://godotengine.org/qa/19396/how-do-i-duplicate-a-dictionary-in-godot-3-0-alpha-2
func clone_dict(source, target):
	for key in source:
		target[key] = source[key].duplicate()

func cost_per_level(level):
	return ceil(0.3*level)
	
func calc_cost(level):
	var val = 0
	for i in range(level-1):
		val += cost_per_level(i+1)
	return val
	
func set_cost():
	print("added level is ", added_levels)
	if(added_levels>0):
		cost = calc_cost(curr_level)
	else:
		cost =  0
	
func _ready():
	upgrade_nodes['lifespan'] = $Container/Center/skills/LifespanUpgrade
	upgrade_nodes['fusion_energy'] =  $Container/Center/skills/FusionEnergyUpgrade
	upgrade_nodes['attack'] =  $Container/Center/skills/AttackDamageUpgrade
	upgrade_nodes['sol'] =  $Container/Center/skills/SolDamageUpgrade
	upgrade_nodes['luminosity'] =  $Container/Center/skills/LuminosityUpgrade
	upgrade_nodes['blinding_light'] =  $Container/Center/skills/BlindingLightUpgrade
	
	stat_nodes['lifespan'] = $Container/Center/Stats/LifespanStat
	stat_nodes['fusion_energy'] = $Container/Center/Stats/FusionEnergyStat
	stat_nodes['attack'] = $Container/Center/Stats/AttackDamageStat
	stat_nodes['sol'] = $Container/Center/Stats/SolDamageStat
	stat_nodes['luminosity'] = $Container/Center/Stats/LuminosityStat
	stat_nodes['blinding_light'] = $Container/Center/Stats/BlindingLightStat
	
	Reset()

func GetSkillValue(name):
	var level = new_skills[name]['current_level']
	return new_skills[name]['values'][level]

func GetSkillLevel(name):
	return new_skills[name]['current_level']
	
func SetCosts():
	totalNode.SetValue(total)
	costNode.SetValue(cost)
	leftNode.SetValue(total-cost)
	
func SetLevel():
	var lifespan_level = GetSkillLevel('lifespan')-1
	var energy_level = GetSkillLevel('fusion_energy')-1
	var attack_level = GetSkillLevel('attack')-1
	var sol_level = GetSkillLevel('sol')
	var lum_level = GetSkillLevel('luminosity')-1
	var bl_level = GetSkillLevel('blinding_light')
	
	curr_level = 1
	
	curr_level+=lifespan_level
	curr_level+=energy_level
	curr_level+=attack_level
	curr_level+=lum_level
	
	curr_level+=sol_level
	curr_level+=bl_level
		
	level.SetValue(curr_level)
	level.SetColor(added_levels > 0)

func IncCurrLevel(key):
	if(new_skills[key]['current_level']<new_skills[key]['values'].size()-1 and total-calc_cost(curr_level+1) >=0):
		new_skills[key]['current_level']+=1
		assign_node(key, true)
		added_levels+=1
		Update()

func  DecCurrLevel(key):
	var org_count = skills[key]['current_level']
	if(new_skills[key]['current_level'] >org_count):
		
		new_skills[key]['current_level']-=1
		assign_node(key, true)
		added_levels-=1
		Update()
	
	if(new_skills[key]['current_level'] == org_count):
		assign_node(key, false)

func Update():
	SetLevel()
	set_cost()
	SetCosts()

func Reset():
	added_levels = 0
	clone_dict(Global.saveData['skills'], skills)
	clone_dict(skills, new_skills)
	
	total = Global.playerStats.hydrogen_orbs
	
	assign_values()
	SetLevel()
	set_cost()
	SetCosts()
		
func assign_values():
	for key in upgrade_nodes:
		assign_node(key, false)

func assign_node(key, highlight):
	upgrade_nodes[key].SetValue(GetSkillLevel(key))
	stat_nodes[key].SetValue(GetSkillValue(key))
	
	upgrade_nodes[key].SetColor(highlight)
	stat_nodes[key].SetColor(highlight)

func _on_Save_pressed():
	Global.saveData['skills'] = new_skills
	
	Global.playerStats.max_lifespan = GetSkillValue('lifespan')
	Global.playerStats.luminosity = GetSkillValue('luminosity')
	Global.playerStats.max_fusion_energy = GetSkillValue('fusion_energy')
	Global.playerStats.sol_damage = GetSkillValue('sol')
	Global.playerStats.attack_damage = GetSkillValue('attack')
	Global.playerStats.blinding_light_duration = GetSkillValue('blinding_light')
	Global.playerStats.hydrogen_orbs = total-cost
	
	Reset()
	
