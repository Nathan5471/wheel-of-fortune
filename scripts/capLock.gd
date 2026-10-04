extends LineEdit


# Called when the node enters the scene tree for the first time.
func onTextChanged(newText: String) -> void:
	var currentCaret = caret_column
	var cleanedText = newText.to_upper()
	var regex = RegEx.new()
	regex.compile("[^A-Z ]")
	cleanedText = regex.sub(cleanedText, "", true)
	text= cleanedText
	caret_column = currentCaret

func _ready() -> void:
	text_changed.connect(onTextChanged)
