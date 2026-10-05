extends Node2D

@onready var label = $Label
@onready var scoreCards = $ScoreCards

func _ready() -> void:
	if (GlobalManager.bonusRoundResult):
		label.text = label.text.replace("{NAME}", GlobalManager.playerNames[GlobalManager.currentStartingPlayer])
	else:
		label.text = label.text.replace("CONGRATS {NAME} ON EARNING
$50,000 IN THE BONUS ROUND!!!", "SORRY {NAME} THAT YOU
DIDN'T WIN THE $50,000
IN THE BONUS ROUND".replace("{NAME}", GlobalManager.playerNames[GlobalManager.currentStartingPlayer]))
	for i in range(3):
		scoreCards.updatePlayerName(i, GlobalManager.playerNames[i])
		scoreCards.updatePlayerScore(i, GlobalManager.playerBanks[i])

func _on_play_again_button_pressed() -> void:
	GlobalManager.restart()
