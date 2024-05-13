extends Node3D

@export var spread_curve: Curve
@export var height_curve: Curve
@export var rotation_curve: Curve

const CARD = preload("res://Scenes/Card.tscn")
var CardDeck

func _ready():
	add_5_cards()
	CardDeck = get_tree().get_first_node_in_group("CardDeck")

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
	var newCard = CARD.instantiate()
	newCard.CardValue = oldCard.CardValue
	newCard.CardSuit = oldCard.CardSuit
	add_child(newCard)
	oldCard.queue_free()
	spaceOutCards()

func _on_button_pressed():
	pullCardFromDeck()
