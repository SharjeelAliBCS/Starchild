signal hit
extends Area2D

func _ready():
	pass

func _on_HeartOfSol_body_entered(body):
	if "Player" in body.name:
		GlobalScenes.current_scene.get_node("Player").playerStats.Rebirth()
		GlobalScenes.goto_scene("reality")
		
