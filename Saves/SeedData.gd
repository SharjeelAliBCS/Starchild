
var saveDataInitial =  {
	'player': {
		'lifespan': 100,
		'fusion_energy_rate': 15
	},
	'items': {
		'hydrogen_orbs': 10,
		'unknown_secretions': 0,
		'keys': 10
	},
	'current_world': 'sol',
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
				{'id': 0, 'position': [1607,293], 'type': 'melee' },
				{'id': 1, 'position': [2730, 668], 'type': 'ranged' },
				{'id': 2, 'position': [2404, 668], 'type': 'melee' },
				{'id': 3, 'position': [1800, 5], 'type': 'melee' },
				{'id': 4, 'position': [2200, 5], 'type': 'ranged' },
				{'id': 5, 'position': [1591, 668], 'type': 'melee' },
				{'id': 6, 'position': [1850, 980], 'type': 'ranged' },
				{'id': 7, 'position': [2575, 980], 'type': 'melee' },
				{'id': 8, 'position': [3089, 980], 'type': 'ranged' },
				{'id': 9, 'position': [3038, -770], 'type': 'melee' },
				{'id': 10, 'position': [2889, -510], 'type': 'ranged' },
				{'id': 11, 'position': [2864, -1116], 'type': 'melee' },
				{'id': 12, 'position': [5802, 224], 'type': 'ranged' },
				{'id': 13, 'position': [6865, 832], 'type': 'ranged' },
				{'id': 14, 'position': [6125, 700], 'type': 'melee' },
				{'id': 15, 'position': [5696, 980], 'type': 'melee' },
				{'id': 16, 'position': [6198, 980 ], 'type': 'ranged' },
				{'id': 17, 'position': [8804, 320], 'type': 'corrupted' }
				#{'id': 0, 'position': [1000,280], 'type': 'corrupted' }
			],
			'keys': [],
			'doors': [
				{'id': 0, 'position': [1096.91,287.085] },
				{'id': 1, 'position': [1815, 670] },
				{'id': 2, 'position': [1960, 670] },
				{'id': 3, 'position': [5430, -66] },
				{'id': 4, 'position': [8551, 318] },
				{'id': 5, 'position': [6900, 991] },
				{'id': 6, 'position': [9143, 320] }
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
	},
	'encountered': {
		'enemy': false,
		'unknown_secretion': false,
		'key': false,
		'solar_winds': false,
		'hydrogen_orbs': false,
		'vonubris': false,
		'knowledge': false
	}
}
