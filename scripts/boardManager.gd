extends Node2D

var boardText: Array[String] = []
const letters: Array[String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
var revealedLetters: Array[String] = []

func formatRow(row: String, intendedLength: int) -> Array[String]:
	var formattedRow: Array[String] = []
	formattedRow.assign(row.split(""))
	for i in range(formattedRow.size()):
		if (formattedRow[i] == " "):
			formattedRow[i] = ""
	if (formattedRow.size() != intendedLength):
		var remainingLength = intendedLength - formattedRow.size()
		var leftNeeded = floor(remainingLength / 2)
		var rightNeeded = remainingLength - leftNeeded
		for i in range(leftNeeded):
			formattedRow.push_front("")
		for i in range(rightNeeded):
			formattedRow.push_back("")
	return formattedRow

func setText(text: String) -> void:
	var words = text.split(" ")
	var rows: Array[String] = ["", "", "", ""]
	var currentRow = 1 if (text.length() <= 40) else 0
	while true:
		for word in words:
			while true:
				var characterLimit = 14 if (currentRow == 1 || currentRow == 2) else 12
				if (characterLimit - rows[currentRow].length() < 1 + word.length()):
					currentRow += 1
					continue
				else:
					rows[currentRow] = word if (rows[currentRow] == "") else rows[currentRow] + " " + word
					break
		if (rows[3] != "" && rows[0] == ""):
			rows = ["", "", "", ""]
			currentRow = 0
			continue
		break
	var newBoard: Array[String] = []
	for i in range(4):
		newBoard = newBoard + formatRow(rows[i], 14 if (i == 1 || i == 2) else 12)
	boardText = newBoard

func showGuessedBoard() -> void:
	for i in range(1,53):
		var text = boardText[i-1]
		if (text == ""):
			continue
		if (text in letters && !(text in revealedLetters)):
			text = ""
		var block = get_node("Blocks/BoardBlock" + str(i))
		block.showBlock(text)

func revealBoard() -> void:
	for i in range(1,53):
		var text = boardText[i-1]
		if (text == ""):
			continue
		var block = get_node("Blocks/BoardBlock" + str(i))
		block.showBlock(text)
		
func addGuess(guess: String) -> void:
	if (!(guess in revealedLetters)):
		revealedLetters.append(guess)
		revealBoard()

func resetBoard() -> void:
	for i in range(1,53):
		var block = get_node("Blocks/BoardBlock" + str(i))
		block.reset()
