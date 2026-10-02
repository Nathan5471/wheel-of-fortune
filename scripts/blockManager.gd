extends Node2D

const shown = preload("res://assets/revealed.png")
@onready var sprite = $Sprite2D
@onready var text = $Label

func showBlock(letter: String) -> void:
	sprite.texture = shown
	text.text = letter
