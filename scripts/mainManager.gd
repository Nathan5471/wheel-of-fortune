extends Node2D

var targetText: String = ""
var currentCategory: String = ""
var guessedLetters: Array[String] = []
var currentTurn: int = 0
var currentSpinValue: int = 0
var playerNames: Array[String] = ["PLAYER 1", "PLAYER 2", "PLAYER 3"]
var playerScores: Array[int] = [0, 0, 0]
var winner: int = -1 # -1 means no current winner
var inGame: bool = false
@onready var board = $Board
@onready var wheel = $Wheel
@onready var scoreCards = $ScoreCards
@onready var spinButton = $Spin
@onready var guessField = $GuessField
@onready var guessButton = $GuessButton

func setupGame() -> void: # I need to add input for names eventually (I'll have a starting screen where the players can enter their name)
	if (inGame):
		return
	targetText = "SHREK IS LOVE SHREK IS LIFE" # I need to add some sort of generation for these two
	currentCategory = "SHREK"
	guessedLetters = []
	playerNames = ["PLAYER 1", "PLAYER 2", "PLAYER 3"]
	playerScores = [0, 0, 0]
	winner = -1
	inGame = true
	board.setText(targetText)
	board.showGuessedBoard()
	for i in range(3):
		scoreCards.updatePlayerName(i, playerNames[i])
		scoreCards.updatePlayerScore(i, playerScores[i])
	setTurn(0)
		
func setTurn(turn: int) -> void:
	currentTurn = turn
	scoreCards.setTurn(turn)
	spinButton.disabled = false
	currentSpinValue = 0
	guessField.editable = false
	guessField.text = ""
	guessButton.disabled = true

func _on_spin_pressed() -> void:
	var spinValue = await wheel.spinWheel() as String
	if (spinValue == "BANKRUPT"):
		playerScores[currentTurn] = 0
		scoreCards.updatePlayerScore(currentTurn, 0)
		setTurn((currentTurn + 1) if (currentTurn != 2) else 0)
	elif (spinValue == "LOSE A TURN"):
		setTurn((currentTurn + 1) if (currentTurn != 2) else 0)
	else:
		currentSpinValue = int(spinValue.replace("$", ""))
		spinButton.disabled = true
		guessField.editable = true
		guessButton.disabled = false

func _on_guess_button_pressed() -> void:
	pass # Replace with function body.

func _process(delta: float):
	setupGame()
