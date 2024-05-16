extends Camera3D

var Hand

var PlayerId
var Phase = Game.Phase.Waiting
var YourTurn = false
var Name = "temp"

func _ready():
	Hand = $Hand
	PlayerId = getPlayerId()

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

	if YourTurn and Phase == Game.Phase.Defence:
		$UILayer/Container/TakeCardsButton.visible = true
	else:
		$UILayer/Container/TakeCardsButton.visible = false
		
	if Phase == Game.Phase.Defence:
		if $PlayerBoard.AttackCardsOnBoard.size() == $PlayerBoard.DefenceCardsOnBoard.size():
			$UILayer/Container/EndDefendingButton.visible = true
		else:
			$UILayer/Container/EndDefendingButton.visible = false
	
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

func attackPhase():
	$UILayer/Container/PhaseLabel.text = "Attack"

func defencePhase():
	$UILayer/Container/PhaseLabel.text = "Defend"

func waitingPhase():
	$UILayer/Container/PhaseLabel.text = "Waiting.."
