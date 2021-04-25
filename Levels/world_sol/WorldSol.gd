extends Node2D

export var timer = 0
export var MAX_TIME = 5

export var solar_flares_duration = 5
export var solar_flares_duration_timer = 0


export var solar_flares_delay = 3
export var solar_flares_delay_timer = 0

export var startEnraging_duration = 2
export var startEnraging_timer = 0

export var stopEnraging_duration = 2
export var stopEnraging_timer = 0

onready var solarFlares = get_node("SolarFlaresBackground").get_node("Viewport").get_node("SolarFlares")
onready var solnio = get_node("Background").get_node("Solnio")
onready var solarFlaresSfx = get_node("sfx_solarWind")

var solar_wind_damage = 1
var min_wind_sound = -50
var max_wind_sound = 0
var current_wind_sound = min_wind_sound
export var world = 'sol'

var STATE = '_noSolarFlares'

var curr_time = 0
var enrage_delay = 10
func _ready():
	GlobalScenes.LoadScene(world) 
	GlobalScenes.current_scene.get_node("Player").playerStats.NewLife()
	GlobalScenes.current_scene.get_node("Player").SetInterfaceData()
	
	solar_flares_delay_timer =solar_flares_delay
	solarFlaresSfx.play()
	solarFlaresSfx.set_volume_db(min_wind_sound)
	
	var c = GlobalScenes.GetWorldCount()
	if(GlobalScenes.GetWorldCount()==1):
		GlobalDialog.ShowDialog("start_sol")
	
func _physics_process(delta):
	timer+=delta
	curr_time += delta
	if(GlobalScenes.current_scene.get_node("Player").playerStats.is_dead):
		GlobalScenes.switch_dimensions("sol")
	
	call(STATE, delta)


func _noSolarFlares(delta):
	solar_flares_delay_timer -= delta
	
	if(solar_flares_delay_timer<=0 && curr_time>enrage_delay):
		startEnraging_timer = startEnraging_duration
		solnio.StartEnraging(startEnraging_duration)
		STATE = '_startEnraging'

func _startEnraging(delta):
	startEnraging_timer -= delta
	
	var curr_time_ratio = (startEnraging_duration-startEnraging_timer)/startEnraging_duration
	current_wind_sound = min_wind_sound
	current_wind_sound += (max_wind_sound-min_wind_sound)*(curr_time_ratio)
	solarFlaresSfx.set_volume_db(current_wind_sound)
	
	if(startEnraging_timer<=0):
		solar_flares_duration_timer = solar_flares_duration
		solarFlares.ActivateFlares()
		STATE = '_solarFlares'
		
func _solarFlares(delta):
	solar_flares_duration_timer -= delta
	
	Global.playerStats.SolarWindDamage(solar_wind_damage)
	
	if(solar_flares_duration_timer<=0):
		stopEnraging_timer = stopEnraging_duration
		solarFlares.DeactivateFlares()
		STATE = '_stopEnraging'
		solnio.StopEnraging(stopEnraging_duration)

func _stopEnraging(delta):
	stopEnraging_timer -= delta
	var curr_time_ratio = (stopEnraging_duration-stopEnraging_timer)/stopEnraging_duration
	current_wind_sound = max_wind_sound
	current_wind_sound += (min_wind_sound-max_wind_sound)*(curr_time_ratio)
	solarFlaresSfx.set_volume_db(current_wind_sound)
	
	if(stopEnraging_timer<=0):
		solar_flares_delay_timer = solar_flares_delay
		STATE = '_noSolarFlares'

