extends Container

var cardHeld = ""

func _ready():
	pass


func _process(delta):
	self.global_position = get_global_mouse_position()
