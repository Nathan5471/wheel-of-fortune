extends Node2D

const shownSprite = preload("res://assets/revealed.png")
const hiddenSprite = preload("res://assets/hidden.png")
@onready var sprite = $Sprite2D
@onready var label = $Label

func showBlock(letter: String) -> void:
	sprite.texture = shownSprite
	label.text = letter

func reset() -> void:
	sprite.texture = hiddenSprite
	label.text = ""
