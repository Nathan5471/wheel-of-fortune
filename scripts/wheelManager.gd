extends Node2D

const sliceCount: int = 24
@onready var wheelSprite: Sprite2D = $Sprite2D
var isSpinning: bool = false
var currentAngle = 0

func spinWheel() -> void:
	if (isSpinning):
		return
	isSpinning = true
	
	var targetRotation = currentAngle + 360.0 * 4 + randf_range(0.0, 360.0)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(wheelSprite, "rotation_degrees", targetRotation, 5.0)
	currentAngle = targetRotation
	tween.finished.connect(onSpinFinished)

func onSpinFinished() -> void:
	await get_tree().create_timer(2.5).timeout
	isSpinning = false

func _process(delta: float) -> void:
	spinWheel()
