extends Node3D

var AttackCardsOnBoard
var DefenceCardsOnBoard

func _ready():
	AttackCardsOnBoard = []
	DefenceCardsOnBoard = []

func _process(delta):
	pass

func addAttackCard(cardSuit, cardValue):
	var count = AttackCardsOnBoard.size()
		
	var cardName = getCardName(count + 1)
	var playedCard = $IncomingAttack.get_node(cardName)
	
	playedCard.CardSuit = cardSuit
	playedCard.CardValue = cardValue
	playedCard.visible = true
	AttackCardsOnBoard.append(playedCard)
	
func addDefendCard(cardSuit, cardValue, cardName):
	var playedCard = $Defence.get_node(String(cardName))
	
	if playedCard.visible == false:
		playedCard.CardSuit = cardSuit
		playedCard.CardValue = cardValue
		playedCard.visible = true
		DefenceCardsOnBoard.append(playedCard)
		return true
	return false

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

#func removeInvisibleCards():
#	for attackCard in AttackCardsOnBoard:
#		if attackCard.visible == false:
#			AttackCardsOnBoard.erase(attackCard)
#			attackCard.queue_free()
#		
#	for defenceCard in DefenceCardsOnBoard:
#		if defenceCard.visible == false:
#			DefenceCardsOnBoard.erase(defenceCard)
#			defenceCard.queue_free()
