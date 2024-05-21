extends Node3D

var playerCount = 6
var WhatPlayersTurn = 1
var Players
var Winners
var Phase = Game.Phase.Attack
var TrumpCard

func _ready():
	setUpPlayers()
	dealCards()
	setPlayerPhases(Game.Phase.Attack)
	Winners = []

func _process(delta):
	pass

func setUpPlayers():
	Players = get_tree().get_nodes_in_group("Player")
	for i in Players.size():
		if i > playerCount:
			Players.erase(Players[i])

func dealCards():
	var players = getPlayersInOrder()
	
	for player in players:
		player.get_node("Hand").fillHand()

func getPlayersInOrder():
	var players = []
	
	for playerIndex in range(WhatPlayersTurn, playerCount+WhatPlayersTurn):
		playerIndex = getPlayerIdCorrectly(playerIndex)
		
		players.append(Players[playerIndex - 1])
	
	return players

func setPlayerPhases(phase):
	Phase = phase
	
	for player in Players:
		player.YourTurn = false
		player.current = false
		player.setPhase(Game.Phase.Waiting)
	Players[WhatPlayersTurn-1].YourTurn = true
	Players[WhatPlayersTurn-1].current = true
	Players[WhatPlayersTurn-1].setPhase(Phase)

func attack(selectedCards, attackerId, defenderId):
	if attackerId != WhatPlayersTurn:
		return
		
	defenderId = getPlayerIdCorrectly(defenderId)
	
	for selectedCard in selectedCards:
		Players[defenderId-1].get_node("PlayerBoard").addAttackCard(selectedCard.CardSuit, selectedCard.CardValue)
	var Phase = Game.Phase.Defence

func defend(selectedCard, cardName, defenderId):
	if defenderId != WhatPlayersTurn:
		return
	
	return Players[defenderId-1].get_node("PlayerBoard").addDefendCard(selectedCard.CardSuit, selectedCard.CardValue, cardName)

func nextTurn(phase, nextPlayer):
	if nextPlayer:
		WhatPlayersTurn += 1
		
	WhatPlayersTurn = getPlayerIdCorrectly(WhatPlayersTurn)
	
	removeAllInvisibleCards()
	if phase == Game.Phase.Attack:
		$DealCardsTimer.start()
	
	setPlayerPhases(phase)
	checkPlayerWinConditions()

func checkPlayerWinConditions():
	for player in Players:
		if player.get_node("Hand").get_children().size() == 0 and get_node("CardDeck").GameDeck.size() == 0:
			if playerCount > 1 and !(player.Phase == Game.Phase.Win or player.Phase == Game.Phase.Lose) :
				Winners.append(player)
				Players.erase(player)
				playerCount -= 1
				player.setWinner()
			else:
				player.setLoser()

func removeAllInvisibleCards():
	var hands = get_tree().get_nodes_in_group("Hand")
	var playerBoards = get_tree().get_nodes_in_group("PlayerBoard")
	
	for hand in hands:
		hand.removeInvisibleCards()

func getPlayerIdCorrectly(playerId):
	if playerId > playerCount:
		return playerId - playerCount
	else:
		return playerId
		
func getTheCurrentPlayersBoard():
	return Players[WhatPlayersTurn-1].get_node("PlayerBoard")
	
func _on_timer_timeout():
	dealCards()
