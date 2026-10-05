extends Node2D

const phraseJson = "res://phrases.json"

var playerNames: Array[String] = []
var currentGuesser: int = 0
var winner: int = -1
var pastGuesses: Array[int] = []
var targetText: String = ""
var category: String = ""
var displaying: bool = false
var lettersToDisplay: Array[String] = [""]
var displayIndex: int = 0
@onready var board = $Board
@onready var categoryLabel = $Category
@onready var player1Button = $Player1
@onready var player1Outline = $Player1/Player1Outline
@onready var player2Button = $Player2
@onready var player2Outline = $Player2/Player2Outline
@onready var player3Button = $Player3
@onready var player3Outline = $Player3/Player3Outline
@onready var guessField = $GuessField
@onready var guessButton = $GuessButton
@onready var timer = $Timer

func getRandomPhraseAndCategory() -> Array[String]:
	var phraseText = FileAccess.get_file_as_string(phraseJson)
	var phraseData = JSON.parse_string(phraseText)
	var category = phraseData["categories"][randi() % phraseData["categories"].size()]
	var phrase = phraseData[category][randi() % phraseData[category].size()]
	return [phrase, category]
	
func generateListOfUniqueCharacters(string: String) -> Array[String]:
	var list: Array[String] = []
	for character in string:
		if (!(character in list)):
			list.append(character)
	list.shuffle()
	return list
	
func setup() -> void:
	var phraseData = getRandomPhraseAndCategory()
	targetText = phraseData[0]
	board.setText(targetText)
	board.resetBoard()
	board.showGuessedBoard()
	category = phraseData[1]
	categoryLabel.text = category
	lettersToDisplay = generateListOfUniqueCharacters(targetText)
	timer.wait_time = 2
	timer.autostart = true
	timer.start()
	
func checkGuess(guess: String) -> void:
	guessField.editable = false
	guessField.text = ""
	guessButton.disabled = true
	if (guess == targetText):
		winner = currentGuesser
		handleWin()
		return
	pastGuesses.append(currentGuesser)
	if (currentGuesser == 1):
		player1Button.disabled = true
		player1Outline.visible = false
	elif (currentGuesser == 2):
		player2Button.disabled = true
		player2Outline.visible = false
	else:
		player3Button.disabled = true
		player3Outline.visible = false
	currentGuesser = 0
	if (!pastGuesses.has(1)):
		player1Button.disabled = false
	if (!pastGuesses.has(2)):
		player2Button.disabled = false
	if (!pastGuesses.has(3)):
		player3Button.disabled = false
	if (!pastGuesses.has(1) && !pastGuesses.has(2) && !pastGuesses.has(3)):
		handleWin()
		return
	timer.start()
	
func handleWin() -> void:
	pass
func _ready() -> void:
	setup()

func _on_timer_timeout() -> void:
	if (displayIndex >= lettersToDisplay.size()):
		timer.stop()
		return
	board.addGuess(lettersToDisplay[displayIndex])
	displayIndex += 1

func _on_player_1_pressed() -> void:
	if (currentGuesser != 0 || pastGuesses.has(1)):
		return
	currentGuesser = 1
	timer.stop()
	player1Outline.visible = true
	player2Button.disabled = true
	player3Button.disabled = true
	guessField.editable = true
	guessButton.disabled = false

func _on_player_2_pressed() -> void:
	if (currentGuesser != 0 || pastGuesses.has(2)):
		return
	currentGuesser = 2
	timer.stop()
	player2Outline.visible = true
	player1Button.disabled = true
	player3Button.disabled = true
	guessField.editable = true
	guessButton.disabled = false

func _on_player_3_pressed() -> void:
	if (currentGuesser != 0 || pastGuesses.has(3)):
		return
	currentGuesser = 3
	timer.stop()
	player3Outline.visible = true
	player1Button.disabled = true
	player2Button.disabled = true
	guessField.editable = true
	guessButton.disabled = false

func _on_guess_field_text_submitted(new_text: String) -> void:
	checkGuess(new_text)

func _on_guess_button_pressed() -> void:
	checkGuess(guessField.text)
