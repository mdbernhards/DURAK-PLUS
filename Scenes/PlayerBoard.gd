extends Node3D

var CardsOnTable = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func addCard(cardSuit, cardValue):
	CardsOnTable += 1
	
	if CardsOnTable > 6:
		CardsOnTable -= 1
		return
		
	var cardName = "Card1"
	
	if CardsOnTable == 1:
		cardName = "Card1"
	elif CardsOnTable == 2:
		cardName = "Card2"
	elif CardsOnTable == 3:
		cardName = "Card3"
	elif CardsOnTable == 4:
		cardName = "Card4"
	elif CardsOnTable == 5:
		cardName = "Card5"
	elif CardsOnTable == 6:
		cardName = "Card6"

	var playedCard = $IncomingAttack.get_node(cardName)
	
	playedCard.CardSuit = cardSuit
	playedCard.CardValue = cardValue
	playedCard.visible = true
