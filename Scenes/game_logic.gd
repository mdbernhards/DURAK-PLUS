extends Node3D

var playerCount = 6
var WhatPlayersTurn = 1
var CurrentPlayersTurn = 1
var Players

func _ready():
	Players = get_tree().get_nodes_in_group("Player")
	dealCards()

func _process(delta):
	setCurrentPlayer()

func dealCards():
	var players = getPlayersInOrder()
	
	for player in players:
		player.get_node("Hand").fillHand()

func getPlayersInOrder():
	var players = []
	
	for playerIndex in range(WhatPlayersTurn, playerCount+WhatPlayersTurn):
		if playerIndex > playerCount:
			playerIndex -= playerCount
		
		players.append(Players[playerIndex - 1])
	
	return players

func setCurrentPlayer():
	if WhatPlayersTurn != CurrentPlayersTurn:
		CurrentPlayersTurn = WhatPlayersTurn
		
		for player in Players:
			player.YourTurn = false
		Players[CurrentPlayersTurn-1].YourTurn = true
