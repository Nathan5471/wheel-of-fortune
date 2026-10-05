extends Node2D

enum GuessState { LETTER, SOLVE }
const phraseJson = "res://phrases.json"

var targetText: String = ""
var currentCategory: String = ""
var guessedLetters: Array[String] = []
var currentTurn: int = 0
var guessState: GuessState = GuessState.LETTER
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
@onready var timer = $Timer

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
	timer.wait_time = 10
	setTurn(initialTurn)

func setTurn(turn: int) -> void:
	currentTurn = turn
	scoreCards.setTurn(turn)
	guessField.text = ""
	
func handleWin() -> void:
	pass
	
func _ready() -> void:
	guessButton.focus_mode = Control.FOCUS_NONE
	guessField.call_deferred("grab_focus")
	guessField.keep_editing_on_text_submit = true
	setupGame(["NATHAN", "POOBERT", "SHREK"], 0)
	
func handleChangeGuess() -> void:
	guessField.text = ""
	if (guessState == GuessState.LETTER):
		guessState = GuessState.SOLVE
		instructionsLabel.text = "ATTEMPT TO SOLVE (10S)"
		timer.start()
	else:
		guessState = GuessState.LETTER
		instructionsLabel.text = "GUESS A LETTER"
	
func handleGuess(guess: String) -> void:
	if (guessState == GuessState.LETTER):
		if (guess.length() != 1):
			guessField.text = ""
			return
		if (guessedLetters.has(guess)):
			setTurn((currentTurn + 1) if (currentTurn != 2) else 0)
			return
		var occurences = targetText.count(guess)
		if (occurences == 0):
			setTurn((currentTurn + 1) if (currentTurn != 2) else 0)
			return
		guessedLetters.append(guess)
		var regex = RegEx.new()
		regex.compile("[AEIOU]")
		if (!regex.search(guess)):
			playerScores[currentTurn] += finalSpinValue * occurences
			scoreCards.updatePlayerScore(currentTurn, playerScores[currentTurn])
		board.addGuess(guess)
		handleChangeGuess()
	else:
		var regex = RegEx.new()
		regex.compile("[^A-Z ]")
		var correctText = regex.sub(targetText, "", true)
		if (correctText == guess):
			timer.stop()
			handleWin()
		else:
			guessField.text = ""

func _on_guess_field_text_submitted(new_text: String) -> void:
	handleGuess(new_text)

func _on_guess_button_pressed() -> void:
	handleGuess(guessField.text)

func _on_timer_timeout() -> void:
	timer.stop()
	setTurn((currentTurn + 1) if (currentTurn != 2) else 0)
	handleChangeGuess()
