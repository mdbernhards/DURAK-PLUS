extends Node3D

class_name Card

var CardTemplate
enum Suit { Diamond , Club , Spade , Heart }
var startPosition
var cardHighlighted = false
var cardClicked = false

var IsCardInHand = false
var PlayersHand
var PlayersCamera

@export var data:CardData:
	set(value):
		data = value
		if CardTemplate:
			CardTemplate.get_node("Art").texture = data.art

@export var CardValue = 2:
	set(value):
		CardValue = value
		getNewCard()

@export var CardSuit: Suit:
	set(value):
		CardSuit = value
		getNewCard()

func _ready():
	CardTemplate = $"CardBody/Front/SubViewport/CardTemplate"
	getNewCard()
	if IsCardInHand:
		PlayersHand = get_parent()

func _process(delta):
	pass

func cardValueToString():
	if CardValue < 11:
		return CardValue
	elif CardValue == 11:
		return "J"
	elif CardValue == 12:
		return "Q"
	elif CardValue == 13:
		return "K"
	elif CardValue == 14:
		return "A"
	elif CardValue == 15:
		return "Joker"
		
func getCardSuit():
	if CardSuit == 0:
		return "Diamond"
	elif CardSuit == 1:
		return "Club"
	elif CardSuit == 2:
		return "Spade"
	elif CardSuit == 3:
		return "Heart"

func getNewCard():
	var card_template = $"CardBody/Front/SubViewport/CardTemplate"
	var resourceFile = "res://Resources/" + str(cardValueToString()) + getCardSuit() + ".tres"
	var tempdata = load(resourceFile)
	data = tempdata

func _on_collision_shape_3d_mouse_entered():
	if cardClicked == false && IsCardInHand:
		$"CardBody/AnimationPlayer".play("Select")
		cardHighlighted = true

func _on_collision_shape_3d_mouse_exited():
	if cardClicked == false && IsCardInHand:
		$"CardBody/AnimationPlayer".play("DeSelect")
		cardHighlighted = false

func _on_collision_shape_3d_input_event(camera, event, position, normal, shape_idx):
	if (event is InputEventMouseButton) and (event.button_index == 1) && IsCardInHand:
		if event.button_mask == 1 and cardHighlighted:
			if !cardClicked:
				cardClicked = PlayersHand.selectCard($".")
			else:
				PlayersHand.deselectCard($".")
				cardClicked = false
