extends Control

var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene

var GameLogic
var PlayerCount = 2
@export var PlayersCurrently = 0

func _ready():
	pass
	
func _process(delta):
	pass
 
func thing():
	pass
	#Main menu pogas, start, quit
	# Lobby host join pogas
	# host poga uztaisa loby var redzet vardus un start pogu
	# join pievieno pie lobby redz to pashu bet bez start pogas
	# start sak speli ar tik cilvekiem cik ir lobby
	# beigas punktu gain un tabula no pedejam spelem kam ir punkti
	# do this and we will be smoking
	# also rewrite players to not have ids from 1 to 6 to being just a list, where id's is how you get the player, not the order? idk
	# shuffle player at the start of each game

func _on_host_pressed():
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	GameLogic = load("res://Scenes/game_logic.tscn").instantiate()
	add_child(GameLogic)
	GameLogic.setUpPlayers(PlayerCount)
	_add_player()
	visible = false
	$JoinUI.visible = false

func _add_player(id = 1):
	var player = GameLogic.Players[PlayersCurrently]
	PlayersCurrently += 1
	call_deferred("add_child", player)

func _on_join_pressed():
	peer.create_client("localhost", 135)
	multiplayer.multiplayer_peer = peer
	visible = false
	$JoinUI.visible = false


func _on_back_pressed():
	get_parent().get_node("MainMenuObjects").visible = true
	$JoinUI.visible = false
