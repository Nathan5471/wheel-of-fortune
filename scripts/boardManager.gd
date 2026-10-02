extends Node2D

var state = false

func revealBoard(textList: Array[String]) -> void:
	for i in range(1,53):
		var text = textList[i-1]
		if (text == ""):
			continue
		var block = get_node("Blocks/BoardBlock" + str(i))
		block.showBlock(text)
		
func resetBoard() -> void:
	for i in range(1,53):
		var block = get_node("Blocks/BoardBlock" + str(i))
		block.reset()
		
const sampleText: Array[String] = ["", "", "", "", "", "", "", "", "", "", "", "", "S", "H", "R", "E", "K", "", "I", "S", "", "L", "O", "V", "E", "", "S", "H", "R", "E", "K", "", "I", "S", "", "L", "I", "F", "E", "", "", "", "", "", "", "", "", "", "", "", "", ""]

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if (!state):
			revealBoard(sampleText)
			state = true
		else:
			resetBoard()
			state = false
