extends Node3D

@export var WhatPlayersTurn = 1
var Players = []
var Winners = []
@export var Phase = Game.Phase.Attack
var TrumpCard = preload("res://Scenes/Card.tscn")
@export var FinalPlace = 1

func _ready():
	Winners = []
	dealCards()
	setPlayerPhases(Game.Phase.Attack)

func _process(delta):
	checkPlayerWinConditions()
	checkIfGameEnded()

func setUpPlayers(playerCount):
	Players = get_tree().get_nodes_in_group("Player")
	for i in Players.size():
		if i >= playerCount:
			var player = Players.pop_back()
			player.queue_free()

func dealCards():
	var players = getPlayersInOrder()
	
	for player in players:
		player.get_node("Hand").fillHand()

func getPlayersInOrder():
	if !Players:
		setUpPlayers(6)
	
	var players = []
	
	for playerIndex in range(WhatPlayersTurn, Players.size()+WhatPlayersTurn):
		playerIndex = getPlayerIdCorrectly(playerIndex)
		
		players.append(Players[playerIndex - 1])
	
	return players

func setPlayerPhases(phase):
	Phase = phase
	
	for player in Players:
		if !(player.Phase == Game.Phase.Win or player.Phase == Game.Phase.Lose):
			player.YourTurn = false
			player.setPhase(Game.Phase.Waiting)
	for player in Winners:
		player.YourTurn = false
		player.setPhase(Game.Phase.Win)
		
	if !(Players[WhatPlayersTurn-1].Phase == Game.Phase.Win or Players[WhatPlayersTurn-1].Phase == Game.Phase.Lose):
		Players[WhatPlayersTurn-1].YourTurn = true
		Players[WhatPlayersTurn-1].setPhase(Phase)

func attack(selectedCards, attackerId, defenderId):
	if attackerId != WhatPlayersTurn:
		return
	
	var player
	if defenderId == -1:
		player = getNextPlayer(attackerId)
	else:
		player = getPlayer(defenderId)
	
	for selectedCard in selectedCards:
		player.get_node("PlayerBoard").addAttackCard(selectedCard.CardSuit, selectedCard.CardValue)
	var Phase = Game.Phase.Defence

func getNextPlayer(attackerId):
	var defenderId = getPlayerIdCorrectly(attackerId + 1)
	var tempPlayer = null
	while tempPlayer == null:
		for player in Players:
			if player.PlayerId == defenderId and player.Phase != Game.Phase.Win:
				tempPlayer = player
		defenderId = getPlayerIdCorrectly(defenderId + 1)
	return tempPlayer
	
func getPlayer(defenderId):
	for player in Players:
		if player.PlayerId == defenderId:
			return player

func defend(selectedCard, cardName, defenderId):
	if defenderId != WhatPlayersTurn:
		return
	
	return Players[defenderId-1].get_node("PlayerBoard").addDefendCard(selectedCard.CardSuit, selectedCard.CardValue, cardName)

func nextTurn(phase, nextPlayer):
	if Players.size() - Winners.size() == 1:
		Players[0].setLoser()
		return
	
	if nextPlayer:
		WhatPlayersTurn = getNextPlayer(WhatPlayersTurn).PlayerId
		
	removeAllInvisibleCards()
	if phase == Game.Phase.Attack:
		$DealCardsTimer.start()
	
	setPlayerPhases(phase)

func checkPlayerWinConditions():
	for player in Players:
		if player.get_node("Hand").get_children().size() <= 0 and get_node("CardDeck").GameDeck.size() <= 0:
			if !(player.Phase == Game.Phase.Win or player.Phase == Game.Phase.Lose):
				if (Players.size() - Winners.size()) > 1:
					Winners.append(player)
					player.setWinner(FinalPlace)
					FinalPlace += 1

func checkIfGameEnded():
	var activePlayerCount = Players.size() - Winners.size()
	
	if activePlayerCount == 1:
		var lastActivePlayer
		for player in Players:
			if !(player.Phase == Game.Phase.Win or player.Phase == Game.Phase.Lose):
				player.setLoser()

func getCurrentPlayerMaxAttack():
	return getNextPlayer(WhatPlayersTurn).get_node("Hand").get_child_count()

func removeAllInvisibleCards():
	var hands = get_tree().get_nodes_in_group("Hand")
	var playerBoards = get_tree().get_nodes_in_group("PlayerBoard")
	
	for hand in hands:
		hand.removeInvisibleCards()

func getPlayerIdCorrectly(playerId):
	if playerId > Players.size():
		return playerId - Players.size()
	else:
		return playerId
		
func getTheCurrentPlayersBoard():
	return Players[getPlayerIdCorrectly(WhatPlayersTurn-1)].get_node("PlayerBoard")
	
func _on_timer_timeout():
	dealCards()
