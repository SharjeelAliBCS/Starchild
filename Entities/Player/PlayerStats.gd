extends Node

var default_life_rate = 1.0
var life_rate = default_life_rate
var lifespan = 100.0
var max_lifespan = 100

var min_life_rate = 0.2
var max_life_rate = 5.0

var luminosity = 2

var max_fusion_energy = 100
var fusion_energy = 100
var fusion_energy_rate = 15.0

var hydrogen_orbs = 0 
var hydrogen_heal_amount = 100

var unknown_secretions = 0
var keys = 0
var open_portal_energy = 50

var sol_rate = 2

var is_dead = false
var use_luminosity = true

var sol_damage = 35
var attack_damage = 20

var dodge_energy = 35
var attack_energy = 25
var blinding_light_energy = 50

var playerSafe = false
var playerDodging = false

var blinding_light_duration = 0

func _ready():
	life_rate = default_life_rate
	

func NewLife():
	is_dead = false
	lifespan = 100.0
	fusion_energy = 100
	life_rate = 0
	use_luminosity = false

func Dodge():
	return DecreaseFusionEnergy(dodge_energy)

func Attack():
	return DecreaseFusionEnergy(attack_energy)

func UseKey():
	keys = max(0, keys-1)
	
func BlindingLight():
	return DecreaseFusionEnergy(blinding_light_energy)
	
func Rebirth():
	lifespan = 100.0
	fusion_energy = 100
	life_rate = default_life_rate
	use_luminosity = true

func GetAttackDamage():
	return attack_damage
	
func GetSolDamage():
	lifespan = max(lifespan-sol_damage*0.5, 0)
	return sol_damage
	
func Update(delta):
	lifespan =max(lifespan-life_rate*delta,0)
	if(lifespan==0):
		is_dead = true
	
	if(life_rate>0):
		fusion_energy =min(fusion_energy+fusion_energy_rate*delta,max_fusion_energy)
	else:
		fusion_energy =min(fusion_energy+fusion_energy_rate*2.5*delta,max_fusion_energy)
	#sprite_material.set_shader_param("Flash", true)

func Damage(dmg):
	if(not playerDodging):
		lifespan  = max(lifespan-dmg, 0)
		GlobalScenes.current_scene.get_node("Player").SetSpriteFlash()

func UseSolAbility():
	var ability_rate = sol_rate
	if(life_rate>0):
		ability_rate = ability_rate /life_rate
	else:
		ability_rate = ability_rate*2.1
	ability_rate = -4*(pow(3, -ability_rate/5))+4.5
	
	return DecreaseFusionEnergy(ability_rate)
	
func UpdateLifeRate(val):
	
	life_rate +=val
	
	if(life_rate<=min_life_rate):
		life_rate = min_life_rate
		return false
	elif(life_rate>=max_life_rate):
		life_rate = max_life_rate
		return false
	return true
	
func GetLightSize():
	if(use_luminosity):
		return Vector2(luminosity*life_rate, luminosity*life_rate)
	else: 
		return Vector2(0,0)

func GetHeartBeatRate():
	
	if(GlobalScenes.current_world == "sol"):
		return 1
	else:
		var heart_min = 0.5
		var heart_max = 2
		var percent = (life_rate-min_life_rate)/(max_life_rate-min_life_rate)
		var heartbeat = percent*(heart_max-heart_min)+heart_min
		
		return heartbeat
	
func GetProgressValue(val):
	var progress
	if(val=="lifespan"):
		progress = lifespan/max_lifespan*100
	else:
		progress = fusion_energy/max_fusion_energy*100
	return progress

func HealHealth():
	if(hydrogen_orbs>0):
		lifespan =min(lifespan+hydrogen_heal_amount, max_lifespan)
		hydrogen_orbs-=1
		
func OpenPortal():
	if(GlobalScenes.current_world=="reality"):
		if(unknown_secretions>0):
			unknown_secretions = max(unknown_secretions-1, 0)
			return true
		
	elif(GlobalScenes.current_world=="void"):
		if(fusion_energy>open_portal_energy):
			fusion_energy = max(open_portal_energy-1, 0)
			return true
			
	return false
	
func DecreaseFusionEnergy(amount):
	if(fusion_energy-amount<0):
		return false
	fusion_energy-=amount
	return true

func SolarWindDamage(amount):
	if(not playerSafe):
		Damage(amount)
