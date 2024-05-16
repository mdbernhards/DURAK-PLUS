extends Node

var CardData = {
	"Spade": { "2": 2,  "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "10": 10, "J": 11, "Q": 12, "K": 13, "A": 14, "Joker": 15},
	"Club": { "2": 2,  "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "10": 10, "J": 11, "Q": 12, "K": 13, "A": 14, "Joker": 15},
	"Heart": { "2": 2,  "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "10": 10, "J": 11, "Q": 12, "K": 13, "A": 14, "Joker": 15},
	"Diamond": { "2": 2,  "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "10": 10, "J": 11, "Q": 12, "K": 13, "A": 14, "Joker": 15},
}

var CardSuits = ["Spade", "Club", "Heart", "Diamond"]

var GameDeck

const CARD = preload("res://Scenes/Card.tscn")

var TrumpCard

func _ready():
	GameDeck = Array()
	placeCardsOnTable(shuffleANewDeckOfCards())

func _process(delta):
	pass

func shuffleANewDeckOfCards():
	var cardArray = Array()
	for x in 56:
		cardArray.append(x)
	
	cardArray.shuffle()
	return cardArray

func placeCardsOnTable(cardArray):
	var cardCount = 0
	for cardValue in cardArray:
		var card = CARD.instantiate()
		card.CardValue = cardValue % 14 + 2
		card.CardSuit = floor(float(cardValue) / 14.0)
		card.CardStatus = Game.CardStatus.Pile
		card.rotation.x = deg_to_rad(90)
		card.rotation.y = 0
		card.rotation.z = 0
		card.position.y = -0.08 + (0.003 * cardCount)
		cardCount += 1
		GameDeck.append(card)
		add_child(card)
		
	GameDeck[0].rotation.x = deg_to_rad(-90)
	GameDeck[0].rotation.y = deg_to_rad(-90)
	GameDeck[0].position.x -= 0.17
	TrumpCard = GameDeck[0]
		
#func getCard(value):
#	var cardSuit = CardSuits[floor(float(value) / 14) - 1]
#	var cardValue
#	
#	for values in CardData[cardSuit]:
	#	if CardData[cardSuit][values] == tempValue:
	#		cardValue = values
	#		var card = CARD.instantiate()
	#		card.CardValue
#			add_child(card)
