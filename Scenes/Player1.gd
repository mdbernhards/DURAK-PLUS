extends Camera3D

var playerId

var YourTurn = false

func _ready():
	pass


func _process(delta):
	if current:
		$UILayer.visible = true
	else:
		$UILayer.visible = false
		
	if YourTurn:
		$UILayer/Container/YourTurnLabel.visible = true
	else:
		$UILayer/Container/YourTurnLabel.visible = false
