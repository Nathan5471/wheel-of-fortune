extends Node2D

var targetText: String = ""
var currentCategory: String = ""
var guessedLetters: Array[String] = []
var currentTurn: int = 0
var playerNames: Array[String] = ["PLAYER 1", "PLAYER 2", "PLAYER 3"]
var playerScores: Array[int] = [0, 0, 0]
var winner: int = -1 # -1 means no current winner
var inGame: bool = false
@onready var board = $Board
@onready var wheel = $Wheel
@onready var scoreCards = $ScoreCards

func setupGame() -> void: # I need to add input for names eventually (I'll have a starting screen where the players can enter their name)
	if (inGame):
		return
	targetText = "SHREK IS LOVE SHREK IS LIFE" # I need to add some sort of generation for these two
	currentCategory = "SHREK"
	guessedLetters = []
	currentTurn = 0
	scoreCards.setTurn(currentTurn)
	playerNames = ["PLAYER 1", "PLAYER 2", "PLAYER 3"]
	playerScores = [0, 0, 0]
	winner = -1
	inGame = true
	board.setText(targetText)
	board.showGuessedBoard()
	for i in range(3):
		scoreCards.updatePlayerName(i, playerNames[i])
		scoreCards.updatePlayerScore(i, playerScores[i])
	
func _process(delta: float):
	setupGame()
