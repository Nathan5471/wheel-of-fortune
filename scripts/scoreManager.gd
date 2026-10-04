extends Node2D

@onready var scoreLabels: Array[Label] = [$Player1Label, $Player2Label, $Player3Label]
@onready var nameLabels: Array[Label] = [$Player1Name, $Player2Name, $Player3Name]
@onready var outlines: Array[ReferenceRect] = [$Player1Box/Player1Outline, $Player2Box/Player2Outline, $Player3Box/Player3Outline]

func updatePlayerScore(player: int, newScore: int) -> void:
	scoreLabels[player].text = "$%d" % newScore

func updatePlayerName(player: int, newName: String) -> void:
	nameLabels[player].text = newName
	
func setTurn(player: int) -> void:
	for i in range(3):
		outlines[i].visible = true if (player == i) else false

func resetDisplays() -> void:
	for i in range(3):
		scoreLabels[i].text = "$0"
		nameLabels[i].text = "PLAYER %d" % (i+1)
