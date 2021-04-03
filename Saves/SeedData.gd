
var saveDataInitial =  {
	'player': {
		'lifespan': 100,
		'fusion_energy_rate': 15
	},
	'items': {
		'hydrogen_orbs': 10,
		'unknown_secretions': 0,
		'keys': 0
	},
	'current_world': 'reality',
	'levels': {
		'sol': {
			'loaded_count': 0,
			'player_position': [50,330],
			'enemies': [],
			'keys': [],
			'doors': []
		},
		'reality': {
			'loaded_count': 0,
			'player_position': [30,290],
			'enemies': [
				{'id': 0, 'position': [360,280], 'type': 'melee' }
			],
			'keys': [],
			'doors': [
				{'id': 0, 'position': [1096.91,287.085] }
			]
		},
		'void': {
			'loaded_count': 0,
			'player_position': [100,266],
			'enemies': [],
			'keys': [
				{'id': 0, 'position': [3792.62,463.731] }
			],
			'doors': []
		}
	},
	'skills': {
		'lifespan': {
			'current_level': 1,
			'values': [0, 100,140,160,180,200]	
		},
		'fusion_energy': {
			'current_level': 1,
			'values': [0, 100,140,160,180,200]	
		},
		'luminosity': {
			'current_level': 1,
			'values': [0, 2.2,2.4,2.6,2.8,3]	
		},
		'blinding_light': {
			'current_level': 0,
			'values': [0, 0.3,0.4,0.5,0.6,0.7]	
		},
		'sol': {
			'current_level': 0,
			'values': [0, 10,20,30,40,50]	
		},
		'attack': {
			'current_level': 1,
			'values': [0, 20,25,30,35]	
		},
	}
}
