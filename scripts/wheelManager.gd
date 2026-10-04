extends Node2D

const sliceCount: int = 24
const degreesPerSlice: float = 360.0 / sliceCount
const wheelValues: Array[String] = ["$1000", "$700", "$300", "$600", "$150", "$400", "$500", "LOSE A TURN", "$300", "$400", "$700", "BANKRUPT", "$300", "$900", "$150", "$500", "$650", "$300", "$800", "$300", "$450", "$350", "$300", "BANKRUPT"]
@onready var wheelSprite: Sprite2D = $WheelSprite
var isSpinning: bool = false
var currentAngle = 0

func spinWheel() -> String:
	if (isSpinning):
		return ""
	isSpinning = true
	
	var targetRotation = currentAngle + 360.0 * 4 + randf_range(0.0, 360.0)
	currentAngle = targetRotation
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(wheelSprite, "rotation_degrees", targetRotation, 5.0)
	await tween.finished
	
	var landedAngle = wrapf(wheelSprite.rotation_degrees, 0.0, 360.0)
	var landedSliceIndex = floor((landedAngle+5.5) / degreesPerSlice)
	return wheelValues[landedSliceIndex]
