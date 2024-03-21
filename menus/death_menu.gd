extends CanvasLayer

signal retry

func _ready():
	$MarginContainer/HBoxContainer/MarginContainer2/HBoxContainer/HighscoreNumber.text = str(Globals.high_score)
	
func update_stats():
	$MarginContainer/HBoxContainer/MarginContainer2/HBoxContainer/HighscoreNumber.text = str(Globals.high_score)

func _on_retry_button_pressed():
	retry.emit()

func _on_quit_button_pressed():
	get_tree().quit()
