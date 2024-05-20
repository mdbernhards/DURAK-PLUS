extends Node3D

var playerCount = 6
var WhatPlayersTurn = 1
var Players
var Phase = Game.Phase.Attack
var TrumpCard

func _ready():
	Players = get_tree().get_nodes_in_group("Player")
	dealCards()
	setPlayerPhases(Game.Phase.Attack)

func _process(delta):
	pass

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

func _on_timer_timeout():
	dealCards()
