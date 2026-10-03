extends Node2D

var boardText: Array[String] = []
var state = false

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
	print("Words:", words)
	var rows: Array[String] = ["", "", "", ""]
	print("Rows:", rows)
	var currentRow = 1 if (text.length() <= 40) else 0
	while true:
		print("Currnet Row:", currentRow)
		for word in words:
			print("Current Word:", word)
			while true:
				var characterLimit = 14 if (currentRow == 1 || currentRow == 2) else 12
				print("Characters Remaining:", characterLimit - rows[currentRow].length())
				if (characterLimit - rows[currentRow].length() < 1 + word.length()):
					currentRow += 1
					print("Current Row:", currentRow)
					continue
				else:
					rows[currentRow] = word if (rows[currentRow] == "") else rows[currentRow] + " " + word
					print("Row:", rows[currentRow])
					break
		if (rows[3] != "" && rows[0] == ""):
			rows = ["", "", "", ""]
			currentRow = 0
			continue
		break
	var newBoard: Array[String] = []
	for i in range(4):
		print("Formatted Row:", formatRow(rows[i], 14 if (i == 1 || i == 2) else 12))
		newBoard = newBoard + formatRow(rows[i], 14 if (i == 1 || i == 2) else 12)
	boardText = newBoard
	

func revealBoard() -> void:
	for i in range(1,53):
		var text = boardText[i-1]
		if (text == ""):
			continue
		var block = get_node("Blocks/BoardBlock" + str(i))
		block.showBlock(text)

func resetBoard() -> void:
	for i in range(1,53):
		var block = get_node("Blocks/BoardBlock" + str(i))
		block.reset()

func _on_line_edit_text_submitted(newText: String) -> void:
	setText(newText)
	if (!state):
		revealBoard()
		state = true
	else:
		resetBoard()
		state = false
