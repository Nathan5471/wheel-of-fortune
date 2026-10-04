extends Node2D

var player1Name: String = ""
var player2Name: String = ""
var player3Name: String = ""
@onready var player1NameInput = $Player1Name
@onready var player2NameInput = $Player2Name
@onready var player3NameInput = $Player3Name
@onready var playButton = $Play

func changeName(newName: String, player: int) -> void:
	if (player == 1):
		player1Name = newName
	elif (player == 2):
		player2Name = newName
	else:
		player3Name = newName
	if (player1Name != "" && player2Name != "" && player3Name != ""):
		playButton.disabled = false
	else:
		playButton.disabled = true

func _on_play_pressed() -> void:
	GlobalManager.startGame(player1Name, player2Name, player3Name)
