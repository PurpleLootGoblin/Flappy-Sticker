extends Node2D

@onready var sounds = $Sounds.get_children()
signal score(score)

func _ready():
	position.y = randi_range(-220, 220)
	$UpColumn.position.y = Globals.up_column_lenght
	$DownColumn.position.y = Globals.down_column_lenght
	
func _on_score_area_body_entered(_body):
	var random_sound = sounds.pick_random()
	if random_sound != null:
		random_sound.play()
	score.emit(1)
