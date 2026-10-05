extends Node2D

const phraseJson = "res://phrases.json"

var targetText: String = ""
var currentCategory: String = ""
var guessedLetters: Array[String] = []
var currentTurn: int = 0
var finalSpinValue: int = 0
var playerNames: Array[String] = ["PLAYER 1", "PLAYER 2", "PLAYER 3"]
var playerScores: Array[int] = [0, 0, 0]
var winner: int = -1 # -1 means no current winner
@onready var board = $Board
@onready var categoryLabel = $Category
@onready var wheel = $Wheel
@onready var scoreCards = $ScoreCards
@onready var guessField = $GuessField
@onready var guessButton = $GuessButton
@onready var spinValueLabel = $SpinValue
@onready var instructionsLabel = $Instructions

func getRandomPhraseAndCategory() -> Array[String]:
	var phraseText = FileAccess.get_file_as_string(phraseJson)
	var phraseData = JSON.parse_string(phraseText)
	var category = phraseData["categories"][randi() % phraseData["categories"].size()]
	var phrase = phraseData[category][randi() % phraseData[category].size()]
	return [phrase, category]

func setupGame(initialPlayerNames: Array[String], initialTurn: int) -> void:
	var phraseData = getRandomPhraseAndCategory()
	targetText = phraseData[0]
	board.setText(targetText)
	board.resetBoard()
	board.showGuessedBoard()
	currentCategory = phraseData[1]
	categoryLabel.text = currentCategory
	playerNames = initialPlayerNames
	playerScores = [0, 0, 0]
	winner = -1
	for i in range(3):
		scoreCards.updatePlayerName(i, playerNames[i])
		scoreCards.updatePlayerScore(i, playerScores[i])
	while true:
		var spinValue = await wheel.spinWheel()
		if (spinValue == "BANKRUPT" || spinValue == "LOSE A TURN"):
			continue
		finalSpinValue = 1000 + int(spinValue.replace("$", ""))
		spinValueLabel.text += " $" + str(finalSpinValue)
		break
	guessField.editable = true
	guessButton.disabled = false
	setTurn(initialTurn)

func setTurn(turn: int) -> void:
	currentTurn = turn
	scoreCards.setTurn(turn)
	guessField.text = ""
	
func _ready() -> void:
	setupGame(["NATHAN", "POOBERT", "SHREK"], 0)
