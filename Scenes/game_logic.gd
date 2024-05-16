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
		if playerIndex > playerCount:
			playerIndex -= playerCount
		
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
	
	if WhatPlayersTurn > playerCount:
		WhatPlayersTurn -= playerCount
	
	if phase == Game.Phase.Attack:
		$DealCardsTimer.start()
	
	setPlayerPhases(phase)


func _on_timer_timeout():
	dealCards()
