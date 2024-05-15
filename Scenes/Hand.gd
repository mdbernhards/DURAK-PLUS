extends Node3D

@export var spread_curve: Curve
@export var height_curve: Curve
@export var rotation_curve: Curve

var MIN_CARDS_IN_HAND = 6

const CARD = preload("res://Scenes/Card.tscn")
var CardDeck

var SelectedCards

func _ready():
	#add_5_cards()
	CardDeck = get_tree().get_first_node_in_group("CardDeck")
	SelectedCards = []

func _process(delta):
	pass

func add_5_cards()->void:
	for _x in 5:
		var card = CARD.instantiate()
		add_child(card)
	spaceOutCards()
	
func spaceOutCards():
	for card in get_children():
		var hand_ratio = 0.5
		
		if get_child_count() > 1 :
			hand_ratio = float(card.get_index())/float(get_child_count() - 1)
			
		var destination := global_transform
		
		var camera := get_parent()
		var curvespread = spread_curve.sample(hand_ratio) * 0.5
		var angle = camera.get_rotation().y 
		
		destination.basis = camera.global_transform.basis
		destination.origin += height_curve.sample(hand_ratio) * (camera.basis * Vector3.UP) * 0.33
		destination.origin += camera.basis * Vector3.FORWARD * hand_ratio * -0.1
		card.global_transform = (destination)
		card.position += Vector3(1,0, 0) * curvespread
		card.rotation.z = rotation_curve.sample(hand_ratio) * 1.2

func pullCardFromDeck():
	var oldCard = CardDeck.GameDeck.pop_back()
	
	if !oldCard:
		return
	
	var newCard = CARD.instantiate()
	newCard.CardValue = oldCard.CardValue
	newCard.CardSuit = oldCard.CardSuit
	newCard.IsCardInHand = true
	add_child(newCard)
	oldCard.queue_free()
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
	pass # Replace with function body.

func _on_take_cards_button_pressed():
	pass # Replace with function body.

func _on_end_turn_button_pressed():
	pass # Replace with function body.

func selectCard(card):
	if SelectedCards.size() == 0:
		SelectedCards.append(card)
		return true
	for selectedCard in SelectedCards:
		if selectedCard.CardValue == card.CardValue:
			SelectedCards.append(card)
			return true
	return false

func deselectCard(card):
	SelectedCards.erase(card)
