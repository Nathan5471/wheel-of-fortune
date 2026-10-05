extends Node2D

@onready var label = $Label

func _ready() -> void:
	label.text = label.text.replace("{NAME}", GlobalManager.playerNames[GlobalManager.currentStartingPlayer])

func _on_shrek_pressed() -> void:
	GlobalManager.startBonusRound("SHREK")

func _on_terra_pressed() -> void:
	GlobalManager.startBonusRound("TERRA")

func _on_phrases_pressed() -> void:
	GlobalManager.startBonusRound("PHRASE")
