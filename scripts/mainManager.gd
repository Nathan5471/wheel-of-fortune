extends Node2D

enum GuessState { NONE, CONSONANT, VOWEL, SOLVE }
const phraseJson = "res://phrases.json"

var targetText: String = ""
var currentCategory: String = ""
var guessedLetters: Array[String] = []
var currentTurn: int = 0
var currentSpinValue: int = 0
var playerNames: Array[String] = ["PLAYER 1", "PLAYER 2", "PLAYER 3"]
var playerScores: Array[int] = [0, 0, 0]
var winner: int = -1 # -1 means no current winner
var guessState: GuessState = GuessState.NONE
@onready var board = $Board
@onready var categoryLabel = $Category
@onready var wheel = $Wheel
@onready var scoreCards = $ScoreCards
@onready var spinButton = $Spin
@onready var guessField = $GuessField
@onready var guessButton = $GuessButton
@onready var buyVowelButton = $BuyVowel
@onready var solveButton = $Solve

func getRandomPhraseAndCategory() -> Array[String]:
	var phraseText = FileAccess.get_file_as_string(phraseJson)
	var phraseData = JSON.parse_string(phraseText)
	var category = phraseData["categories"][randi() % phraseData["categories"].size()]
	var phrase = phraseData[category][randi() % phraseData[category].size()]
	return [phrase, category]

func setupGame(initialPlayerName, initialTurn) -> void:
	var generatedPhraseAndCategory = getRandomPhraseAndCategory()
	targetText = generatedPhraseAndCategory[0]
	board.setText(targetText)
	board.resetBoard()
	board.showGuessedBoard()
	currentCategory = generatedPhraseAndCategory[1]
	categoryLabel.text = currentCategory
	guessedLetters = []
	playerNames = initialPlayerName
	playerScores = [0, 0, 0]
	winner = -1
	for i in range(3):
		scoreCards.updatePlayerName(i, playerNames[i])
		scoreCards.updatePlayerScore(i, playerScores[i])
	setTurn(initialTurn)
		
func setTurn(turn: int) -> void:
	currentTurn = turn
	scoreCards.setTurn(turn)
	spinButton.disabled = false
	currentSpinValue = 0
	guessField.editable = false
	guessField.text = ""
	guessButton.disabled = true
	solveButton.disabled = false
	if (playerScores[turn] >= 250):
		buyVowelButton.disabled = false
	else:
		buyVowelButton.disabled = true
	
func handleWin() -> void:
	GlobalManager.handleWin(winner, max(playerScores[winner], 1000))

func _on_spin_pressed() -> void:
	buyVowelButton.disabled = true
	solveButton.disabled = true
	var spinValue = await wheel.spinWheel() as String
	if (spinValue == "BANKRUPT"):
		playerScores[currentTurn] = 0
		scoreCards.updatePlayerScore(currentTurn, 0)
		setTurn((currentTurn + 1) if (currentTurn != 2) else 0)
	elif (spinValue == "LOSE A TURN"):
		setTurn((currentTurn + 1) if (currentTurn != 2) else 0)
	else:
		currentSpinValue = int(spinValue.replace("$", ""))
		guessState = GuessState.CONSONANT
		spinButton.disabled = true
		guessField.editable = true
		guessButton.disabled = false
		
func handleGuess() -> void:
	var guessText = guessField.text
	if (guessText.length() == 0):
		return
	if (guessText.length() == 1):
		var regex = RegEx.new()
		regex.compile("[AEIOU]")
		if (regex.search(guessText)):
			if (playerScores[currentTurn] < 250 || guessState != GuessState.VOWEL):
				guessField.text = ""
				return
			playerScores[currentTurn] -= 250
		else:
			if (guessState != GuessState.CONSONANT):
				guessField.text = ""
				return
		var isGuessCorrect = targetText.contains(guessText) && !(guessedLetters.has(guessText))
		if (isGuessCorrect):
			if (!regex.search(guessText)):
				playerScores[currentTurn] += currentSpinValue * targetText.count(guessText)
			scoreCards.updatePlayerScore(currentTurn, playerScores[currentTurn])
			board.addGuess(guessText)
			guessField.text = ""
			spinButton.disabled = false
			guessField.editable = false
			guessButton.disabled = true
			solveButton.disabled = false
			if (playerScores[currentTurn] >= 250):
				buyVowelButton.disabled = false
			else:
				buyVowelButton.disabled = true
		else:
			setTurn((currentTurn + 1) if (currentTurn != 2) else 0)
	else:
		if (guessState != GuessState.SOLVE):
			guessField.text = ""
			return
		var regex = RegEx.new()
		regex.compile("[^A-Z ]")
		var correctText = regex.sub(targetText, "", true)
		if (guessText == correctText):
			winner = currentTurn
			handleWin()
		else:
			setTurn((currentTurn + 1) if (currentTurn != 2) else 0)

func _on_guess_button_pressed() -> void:
	handleGuess()
	
func _on_guess_field_text_submitted(new_text: String) -> void:
	handleGuess()

func _on_buy_vowel_pressed() -> void:
	guessState = GuessState.VOWEL
	guessField.text = ""
	guessField.editable = true
	guessButton.disabled = false
	buyVowelButton.disabled = true
	solveButton.disabled = true
	spinButton.disabled = true

func _on_solve_pressed() -> void:
	guessState = GuessState.SOLVE
	guessField.text = ""
	guessField.editable = true
	guessButton.disabled = false
	buyVowelButton.disabled = true
	solveButton.disabled = true
	spinButton.disabled = true

func _ready():
	setupGame(GlobalManager.playerNames, GlobalManager.currentStartingPlayer)
