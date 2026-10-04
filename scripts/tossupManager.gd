extends Node2D

const phraseJson = "res://phrases.json"

var playerNames: Array[String] = []
var currentGuesser: int = 0
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
	
func _ready() -> void:
	setup()

func _on_timer_timeout() -> void:
	if (displayIndex >= lettersToDisplay.size()):
		timer.stop()
		return
	board.addGuess(lettersToDisplay[displayIndex])
	displayIndex += 1
