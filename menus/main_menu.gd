extends CanvasLayer

@onready var main_scene: PackedScene = preload("res://scenes/main/main.tscn")
@onready var player_scene: PackedScene = preload("res://scenes/player/player.tscn")
 
func _ready():
	var music = $AudioStreamPlayer2D
	music.play()
	
func _process(delta):
	$ParallaxBackground/ParallaxLayer.motion_offset.x -= 200 * delta
	
func _on_play_pressed():
	$UISounds2.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_packed(main_scene)
	
func _on_quit_pressed():
	$UISounds2.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()
	
func _on_play_mouse_entered():
	$UISounds.play()

func _on_quit_mouse_entered():
	$UISounds.play()
