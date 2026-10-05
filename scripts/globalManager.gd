extends Node

const setupScenePath = "res://setup.tscn"
const mainGamePath = "res://main.tscn"
const tossupPath = "res://tossup.tscn"
const speedUpRoundPath = "res://speedUpRound.tscn"
const bonusRoundPath = "res://bonusRound.tscn"

var playerNames: Array[String] = ["", "", ""]
var playerBanks: Array[int] = [0, 0, 0]
var currentRound: int = 0
var currentStartingPlayer: int = 0

func startGame(player1Name: String, player2Name: String, player3Name: String) -> void:
	playerNames = [player1Name, player2Name, player3Name]
	playerBanks = [0, 0, 0]
	currentRound = 0
	currentStartingPlayer = 0
	get_tree().change_scene_to_file(tossupPath)

func handleWin(winner: int, amount: int) -> void:
	if (currentRound == 0):
		if (range(3).has(winner)):
			playerBanks[winner] += 1000
		get_tree().change_scene_to_file(tossupPath)
	elif (currentRound == 1):
		if (range(3).has(winner)):
			playerBanks[winner] += 2000
		get_tree().change_scene_to_file(mainGamePath)
	elif (currentRound == 2 || currentRound == 3):
		if (range(3).has(winner)):
			playerBanks[winner] += amount
		currentStartingPlayer += 1
		get_tree().change_scene_to_file(mainGamePath)
	elif (currentRound == 4):
		if (range(3).has(winner)):
			playerBanks[winner] += amount
		get_tree().change_scene_to_file(tossupPath)
	elif (currentRound == 5 || currentRound == 6):
		if (range(3).has(winner)):
			playerBanks[winner] += 2000
		get_tree().change_scene_to_file(tossupPath)
	elif (currentRound == 7):
		if (range(3).has(winner)):
			playerBanks[winner] += 2000
		currentStartingPlayer = winner
		get_tree().change_scene_to_file(speedUpRoundPath)
	elif (currentRound == 8):
		if (range(3).has(winner)):
			playerBanks[winner] += amount
		currentStartingPlayer = playerBanks.find(playerBanks.max())
		get_tree().change_scene_to_file(bonusRoundPath)
	elif (currentRound == 9):
		pass
	currentRound += 1
