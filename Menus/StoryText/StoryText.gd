extends Control

var opening = "The discovery of the Living Stars ushered an eon of worship.\n"+ \
			 "One that created the order of the Imperium, whom were granted the powers of fusion.\n"+ \
			 "Soon, they rose to become the rulers of humanity for countless eons.\n"+ \
			 "All until, the Great Dying of the stars.\n"+ \
			 "One by one, the living star would vanish into the eternal void.\n"+ \
			 "One by one, the Imperium grew weaker.\n"+ \
			 "Now only one Living star remains.\n"+ \
			 "Solnio.\n"+ \
			 "And yet, they do not know why.\n"+ \
			 "Rumors whisper of hidden knowledge that reveal the Living Star's true enemy.\n"+ \
			 "Buried within the ruins of a long lost civilization on Meero, a planet orbiting Solnio.\n"+ \
			 "And so forth, they have sent a loneful Priest of Solnio,\n"+ \
			 "To save the last Living Star."
var ending = 'Having unveiled the truth behind the deaths of the Living Stars,\n'+\
			'the Priest of Solnio accepts their defeat.\n'+\
			 'Lying still, atop the soon devoured planet.\n'+\
			'Knowning both, themself and the great Imperium will fall.\n'+\
			'And there is nothing they can do to stop it\n'+\
			'\n\n\nTHE END'

var isOpening  = true

onready var label = get_node("CanvasLayer/Control/Label")
func _ready():
	print(Global.STATE)
	if(Global.STATE == 'opening'):
		PlayOpening()
	elif(Global.STATE == 'ending'):
		PlayEnding()

func _unhandled_key_input(event):
	if event.is_pressed():
		if(Global.STATE == 'opening'):
			Global.StartNewGame()
		elif(Global.STATE == 'ending'):
			Global.FinishGame()

func _process(delta):
	var pos = label.get_position()
	label.set_position(Vector2(pos.x, pos.y - delta*15))
	print(pos)
	if(pos.y < -310):
		Global.StartNewGame()
		
	if(Global.STATE == 'opening'):
		if(pos.y < -310):
			Global.StartNewGame()
	elif(Global.STATE == 'ending'):
		if(pos.y < -210):
			Global.FinishGame()
		
func PlayOpening():
	label.text = opening
	label.set_position(Vector2(0, 280))
	
func  PlayEnding():
	label.text = ending
	label.set_position(Vector2(0, 280))
