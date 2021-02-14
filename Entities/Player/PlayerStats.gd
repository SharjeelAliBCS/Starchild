extends Node

var default_life_rate = 1.0
var life_rate = default_life_rate
var lifespan = 100.0
var max_lifespan = 100

var min_life_rate = 0.2
var max_life_rate = 5.0

var luminosity = 0.4

var max_fusion_energy = 100
var fusion_energy = 100
var fusion_energy_rate = 10.0

var hydrogen_orbs = 0 
var hydrogen_heal_amount = 20

var unknown_secretions = 0
var open_portal_energy = 50

var is_dead = false
var use_luminosity = true

func _ready():
	life_rate = default_life_rate

func NewLife():
	print("new life")
	is_dead = false
	lifespan = 100.0
	fusion_energy = 100
	life_rate = 0
	use_luminosity = false

func Rebirth():
	lifespan = 100.0
	fusion_energy = 100
	life_rate = default_life_rate
	use_luminosity = true
	
func Update(delta):
	
	lifespan =max(lifespan-life_rate*delta,0)
	if(lifespan==0):
		is_dead = true
	
	fusion_energy =min(fusion_energy+fusion_energy_rate*delta,100)

	
	
	
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

func GetProgressValue(val):
	var progress
	if(val=="lifespan"):
		progress = lifespan
	else:
		progress = fusion_energy
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
	fusion_energy-=amount
	if(fusion_energy<=0):
		fusion_energy = 0
