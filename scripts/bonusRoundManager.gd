extends Node2D

const phraseJson = "res://phrases.json"

var guessedLetters: Array[String] = ["R", "S", "T", "L", "N", "E"]
var currentGuess: int = 0
var targetText: String = ""
var categorty: String = ""
var won: bool = false
@onready var board = $Board
@onready var categoryLabel = $Category
@onready var guessedLabel = $Guessed
@onready var instructionsLabel = $Instructions
@onready var guessField = $GuessField
@onready var guessButton = $GuessButton
@onready var timer = $Timer

func getRandomPhraseAndCategory() -> Array[String]:
	var phraseText = FileAccess.get_file_as_string(phraseJson)
	var phraseData = JSON.parse_string(phraseText)
	var category = phraseData["categories"][randi() % phraseData["categories"].size()]
	var phrase = phraseData[category][randi() % phraseData[category].size()]
	return [phrase, category]

func setup() -> void:
	var phraseData = getRandomPhraseAndCategory()
	targetText = phraseData[0]
	board.setText(targetText)
	board.resetBoard()
	for letter in guessedLetters:
		board.addGuess(letter)
	categorty = phraseData[1]
	categoryLabel.text = categorty
	
func handleGuess(guess: String) -> void:
	if currentGuess < 4:
		if (guess.length() != 1):
			guessField.text = ""
			return
		handleAddGuessLetter(guess)
	else:
		handleSolveAttempt(guess)
		
func handleAddGuessLetter(guess: String) -> void:
	var regex = RegEx.new()
	regex.compile("[AEIOU]")
	if (currentGuess < 3):
		if (regex.search(guess)):
			guessField.text = ""
			return
		if (guessedLetters.has(guess)):
			guessField.text = ""
			return
		guessedLetters.append(guess)
		guessedLabel.text += ", " + guess if (currentGuess != 0) else guess
		currentGuess += 1
		guessField.text = ""
		if (currentGuess == 3):
			instructionsLabel.text = "GUESS A VOWEL"
	else:
		if (!regex.search(guess)):
			guessField.text = ""
			return
		if (guessedLetters.has(guess)):
			guessField.text = ""
			return
		guessedLetters.append(guess)
		guessedLabel.text += ", " + guess
		currentGuess += 1
		guessField.text = ""
		instructionsLabel.text = "SOLVE BEFORE THE TIMER RUNS OUT"
		for letter in guessedLetters:
			board.addGuess(letter)
		timer.wait_time = 20
		timer.start()
			
func handleSolveAttempt(guess: String) -> void:
	var regex = RegEx.new()
	regex.compile("[^A-Z ]")
	var correctText = regex.sub(targetText, "", true)
	if (guess == correctText):
		timer.stop()
		won = true
		handleWin()
		return
	guessField.text = ""

func handleWin() -> void:
	GlobalManager.handleWin(won, 0)

func _ready() -> void:
	guessButton.focus_mode = Control.FOCUS_NONE
	guessField.call_deferred("grab_focus")
	guessField.keep_editing_on_text_submit = true
	setup()

func _on_guess_button_pressed() -> void:
	handleGuess(guessField.text)

func _on_guess_field_text_submitted(new_text: String) -> void:
	handleGuess(new_text)
	guessField.grab_focus()

func _on_timer_timeout() -> void:
	guessField.editable = false
	guessField.text = ""
	guessButton.disabled = true
	handleWin()
