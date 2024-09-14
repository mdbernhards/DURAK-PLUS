extends Control

func _ready():
	pass

func _process(delta):
	pass

func _on_play_button_pressed():
	$MainMenuObjects.visible = false
	$Lobby/JoinUI.visible = true

func _on_options_button_pressed():
	pass

func _on_quit_button_pressed():
	get_tree().quit()
