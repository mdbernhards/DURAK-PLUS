extends Node3D

var CardCount = 0
var AttackCardsOnBoard = []
var DefenceCardsOnBoard = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func addAttackCard(cardSuit, cardValue):
	CardCount += 1
	
	if CardCount > 6:
		CardCount -= 1
		return
		
	var cardName = getCardName(CardCount)

	var playedCard = $IncomingAttack.get_node(cardName)
	
	playedCard.CardSuit = cardSuit
	playedCard.CardValue = cardValue
	playedCard.visible = true
	AttackCardsOnBoard.append(playedCard)
	
func addDefendCard(cardSuit, cardValue, cardName):
	var playedCard = $Defence.get_node(String(cardName))
	
	playedCard.CardSuit = cardSuit
	playedCard.CardValue = cardValue
	playedCard.visible = true
	DefenceCardsOnBoard.append(playedCard)

func getCardName(cardPosition):
	var cardName = "Card1"
	
	if cardPosition == 1:
		return "Card1"
	elif cardPosition == 2:
		return "Card2"
	elif cardPosition == 3:
		return "Card3"
	elif cardPosition == 4:
		return "Card4"
	elif cardPosition == 5:
		return "Card5"
	elif cardPosition == 6:
		return "Card6"
