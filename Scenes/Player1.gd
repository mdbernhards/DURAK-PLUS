extends Camera3D

var Hand

var PlayerId
var Phase = Game.Phase.Waiting
var YourTurn = false
var Name = "temp"
var GameLogic
var FinalPlace

func _ready():
	Hand = $Hand
	PlayerId = getPlayerId()
	GameLogic = get_parent().get_parent()

func _process(delta):
	if current:
		$UILayer.visible = true
	else:
		$UILayer.visible = false
		
	setUiVisibility()

func setUiVisibility():
	if Hand and Hand.SelectedCards.size() > 0 and Phase == Game.Phase.Attack:
		$UILayer/Container/AttackButton.visible = true
	else:
		$UILayer/Container/AttackButton.visible = false

	if (YourTurn and Phase == Game.Phase.Defence):
		$UILayer/Container/TakeCardsButton.visible = true
	else:
		$UILayer/Container/TakeCardsButton.visible = false
		
	if Phase == Game.Phase.Defence:
		if $PlayerBoard.AttackCardsOnBoard.size() == $PlayerBoard.DefenceCardsOnBoard.size():
			$UILayer/Container/EndDefendingButton.visible = true
		else:
			$UILayer/Container/EndDefendingButton.visible = false
		
		var isPassButtonVisible = true
		if Hand.SelectedCards.size() == 1:
			for attackCard in $PlayerBoard.AttackCardsOnBoard:
				if attackCard.CardValue != Hand.SelectedCards[0].CardValue:
					isPassButtonVisible = false
		else:
			isPassButtonVisible = false
		
		$UILayer/Container/PassCardsButton.visible = isPassButtonVisible
	else:
		$UILayer/Container/EndDefendingButton.visible = false
		$UILayer/Container/PassCardsButton.visible = false
	
	var isBonusAttackVisible = false
	if Phase == Game.Phase.Waiting and PlayerId != GameLogic.WhatPlayersTurn:
		var playerBoard = GameLogic.getTheCurrentPlayersBoard()
		if playerBoard.AttackCardsOnBoard.size() < 6:
			for attackCard in playerBoard.AttackCardsOnBoard:
				if Hand.SelectedCards and attackCard.CardValue == Hand.SelectedCards[0].CardValue:
					isBonusAttackVisible = true
			for defenceCard in playerBoard.DefenceCardsOnBoard:
				if Hand.SelectedCards and defenceCard.CardValue == Hand.SelectedCards[0].CardValue:
					isBonusAttackVisible = true
		$UILayer/Container/BonusAttackButton.visible = isBonusAttackVisible

func setWinner(finalPlace):
	FinalPlace = finalPlace
	setPhase(Game.Phase.Win)

func setLoser():
	pass

func getPlayerId():
	var groups = get_groups()
	
	for group in groups:
		if group == "Player1":
			return 1
		elif group == "Player2":
			return 2
		elif group == "Player3":
			return 3
		elif group == "Player4":
			return 4
		elif group == "Player5":
			return 5
		elif group == "Player6":
			return 6

func setPhase(phase):
	Phase = phase
	
	if Phase == Game.Phase.Attack:
		attackPhase()
	if Phase == Game.Phase.Defence:
		defencePhase()
	if Phase == Game.Phase.Waiting:
		waitingPhase()
	if Phase == Game.Phase.Win:
		waitingPhase()
	if Phase == Game.Phase.Lose:
		waitingPhase()

func attackPhase():
	$UILayer/Container/PhaseLabel.text = "Attack"

func defencePhase():
	$UILayer/Container/PhaseLabel.text = "Defend"

func waitingPhase():
	$UILayer/Container/PhaseLabel.text = "Waiting.."

func winPhase():
	$UILayer/Container/PhaseLabel.text = getWinText()

func losePhase():
	$UILayer/Container/PhaseLabel.text = "DURAK!"

func getWinText():
	if FinalPlace == 1:
		return FinalPlace + "st place"
	if FinalPlace == 2:
		return FinalPlace + "nd place"
	if FinalPlace == 3:
		return FinalPlace + "rd place"
	else:
		return FinalPlace + "th place"
