extends Node

const setupScenePath = "res://setup.tscn"
const mainGamePath = "res://main.tscn"

var playerNames: Array[String] = ["", "", ""]
var playerBanks: Array[int] = [0, 0, 0]
var currentRound: int = 0
var currentStartingPlayer: int = 0

func startGame(player1Name: String, player2Name: String, player3Name: String) -> void:
	playerNames = [player1Name, player2Name, player3Name]
	playerBanks = [0, 0, 0]
	currentRound = 0
	currentStartingPlayer = 0
	get_tree().change_scene_to_file(mainGamePath)
