extends CanvasLayer

onready var viewport = $Viewport
onready var viewport_sprite = $ViewportSprite


var viewport_initial_size = Vector2()

func _ready():
	pass
	viewport_initial_size = viewport.size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	get_viewport().connect("size_changed", self, "_root_viewport_size_changed")
	
