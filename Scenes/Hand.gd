extends Node3D

@export var spread_curve: Curve
@export var height_curve: Curve
@export var rotation_curve: Curve

var MIN_CARDS_IN_HAND = 6

const CARD = preload("res://Scenes/Card.tscn")

var GameLogic
var CardDeck
var PlayerCamera
var PlayerBoard

var SelectedCards
var DefendingCards

func _ready():
	CardDeck = get_tree().get_first_node_in_group("CardDeck")
	SelectedCards = []
	DefendingCards = []
	GameLogic = get_tree().get_first_node_in_group("GameLogic")
	PlayerCamera = get_parent()
	PlayerBoard = PlayerCamera.get_node("PlayerBoard")

func _process(delta):
	pass

func spaceOutCards():
	for card in get_children():
		var hand_ratio = 0.5
		
		if get_child_count() > 1 :
			hand_ratio = float(card.get_index())/float(get_child_count() - 1)
			
		var destination := global_transform
		
		var curvespread = spread_curve.sample(hand_ratio) * 0.5
		var angle = PlayerCamera.get_rotation().y 
		
		destination.basis = PlayerCamera.global_transform.basis
		destination.origin += height_curve.sample(hand_ratio) * (PlayerCamera.basis * Vector3.UP) * 0.33
		destination.origin += PlayerCamera.basis * Vector3.FORWARD * hand_ratio * -0.03
		card.global_transform = (destination)
		card.position += Vector3(1,0, 0) * curvespread
		card.rotation.z = rotation_curve.sample(hand_ratio) * 1.2

func pullCardFromDeck():
	var oldCard = CardDeck.GameDeck.pop_back()
	
	if !oldCard:
		return
	
	addCard(oldCard.CardValue, oldCard.CardSuit)
	
	oldCard.queue_free()

func addCard(cardValue, cardSuit):
	var newCard = CARD.instantiate()
	newCard.CardValue = cardValue
	newCard.CardSuit = cardSuit
	newCard.CardStatus = Game.CardStatus.Hand
	add_child(newCard)
	spaceOutCards()

func fillHand():
	var count = get_child_count()
	
	if count >= MIN_CARDS_IN_HAND:
		return
	
	for _i in MIN_CARDS_IN_HAND - count:
		pullCardFromDeck()

func _on_get_card_button_pressed():
	pullCardFromDeck()

func _on_attack_button_pressed():
	var attackerId = PlayerCamera.PlayerId
	var defenderId = PlayerCamera.PlayerId + 1
	if defenderId > GameLogic.playerCount:
		defenderId -= GameLogic.playerCount
	
	GameLogic.attack(SelectedCards, attackerId, defenderId)
	
	for card in SelectedCards:
		card.free()
	
	SelectedCards.clear()
	GameLogic.nextTurn(Game.Phase.Defence, true)
	spaceOutCards()

func _on_take_cards_button_pressed():
	for card in PlayerBoard.AttackCardsOnBoard:
		addCard(card.CardValue, card.CardSuit)
		card.queue_free()
	
	for card in PlayerBoard.DefenceCardsOnBoard:
		addCard(card.CardValue, card.CardSuit)
		card.queue_free()
	
	PlayerBoard.AttackCardsOnBoard.clear()
	PlayerBoard.DefenceCardsOnBoard.clear()
	GameLogic.nextTurn(Game.Phase.Attack, true)

func _on_end_defending_button_pressed():
	for card in PlayerBoard.AttackCardsOnBoard:
		card.queue_free()
	
	for card in PlayerBoard.DefenceCardsOnBoard:
		card.queue_free()
	
	PlayerBoard.AttackCardsOnBoard.clear()
	PlayerBoard.DefenceCardsOnBoard.clear()
	GameLogic.nextTurn(Game.Phase.Attack, false)

func selectCard(card):
	if (SelectedCards.size() == 0 or DefendingCards.size() > 0) and PlayerCamera.Phase != Game.Phase.Waiting:
		SelectedCards.append(card)
		return true
	elif PlayerCamera.Phase == Game.Phase.Attack:
		for selectedCard in SelectedCards:
			if selectedCard.CardValue == card.CardValue:
				SelectedCards.append(card)
				return true
	return false

func deselectCard(card):
	SelectedCards.erase(card)

func defendCard(card):
	if SelectedCards.size() != 1:
		return false
	
	if (SelectedCards[0].CardValue > card.CardValue && SelectedCards[0].CardSuit == card.CardSuit) or (SelectedCards[0].CardSuit != card.CardSuit and GameLogic.TrumpCard.CardSuit == SelectedCards[0].CardSuit):
		var valid = GameLogic.defend(SelectedCards[0], card.name, PlayerCamera.PlayerId)
		if valid:
			SelectedCards[0].visible = false
			DefendingCards.append(SelectedCards[0])
			SelectedCards.pop_at(0)

func takeBackDefendingCard(card):
	card.visible = false
	var tempCard
	for defCard in DefendingCards:
		if defCard.CardValue == card.CardValue and defCard.CardSuit == card.CardSuit:
			defCard.visible = true
			defCard.reset()
			defCard.cardInHand()
			DefendingCards.erase(defCard)
			PlayerBoard.DefenceCardsOnBoard.erase(card)
