extends Node2D

@onready var scoreLabels: Array[Label] = [$Player1Label, $Player2Label, $Player3Label]
@onready var nameLabels: Array[Label] = [$Player1Name, $Player2Name, $Player3Name]

func updatePlayerScore(player: int, newScore: int) -> void:
	scoreLabels[player].text = "$%d" % newScore

func updatePlayerName(player: int, newName: String) -> void:
	nameLabels[player].text = newName

func resetDisplays() -> void:
	for i in range(3):
		scoreLabels[i].text = "$0"
		nameLabels[i].text = "PLAYER %d" % (i+1)
