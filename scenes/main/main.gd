extends Node2D

@onready var obstacles_table = ObstaclesTable.new()
@onready var simple_obstacle: PackedScene = preload("res://scenes/obstacles/simple_obstacle/simple_obstacle.tscn")

@export var obstacle_speed: float
@export var simple_obstacle_up: float
@export var simple_obstacle_down: float

var score = 0
var high_score = 0

var delta_time: float = 0.0

const out_of_bounds = -1200
var refreshed = false
var obstacle_spawn_enabled = true

var game_started = true

func _ready():
	obstacles_table.add_obstacle(simple_obstacle, 1.0)
	$Player.position = Vector2(450, 450) #250, 450
	$Player.connect("player_dead", on_player_death)  
	$DeathMenu.connect("retry", refresh)
	$AudioStreamPlayer2D.play()
	
func _process(delta):
	var obstacles_children = $Obstacles.get_children()
	for child in obstacles_children:
		child.position.x -= obstacle_speed * delta
		if child.position.x <= out_of_bounds:   
			child.queue_free()
			
	Globals.up_column_lenght = simple_obstacle_up
	Globals.down_column_lenght = simple_obstacle_down
	
	delta_time += 0.2 * delta
	$ParallaxBackground/ParallaxLayer.motion_offset.x -= 200 * delta
	
func increase_score(score_number):
	score += round((score_number * delta_time))
	$CanvasLayer/MarginContainer/CenterContainer/HBoxContainer/Number.text = str(score)
	update_score()
	
func update_score():
	if score > Globals.high_score:
		Globals.high_score = score
		$DeathMenu.update_stats()
		
func _on_obstacle_spawn_timer_timeout():
	# the obstacles table is useless, the idea was to generate different obstacles later, but yeah...
	if obstacle_spawn_enabled:
		var pick_obstacle = obstacles_table.pick_obstacle()
		var picked_obstacle = pick_obstacle.instantiate()
		picked_obstacle.position.x = 2000
		$Obstacles.add_child(picked_obstacle)
		
		picked_obstacle.connect("score", increase_score)
	else:
		pass
		
func _on_fall_area_body_entered(_body):
	on_player_death()
	
func on_player_death():
	refreshed = false
	delta_time = 0.0
	$AudioStreamPlayer2D.stop()
	$DeathMusic.play()
	$DeathMenu.show()
	$Player.set_physics_process(false)
	set_process(false)
	$DiffIncreaser.stop()
	obstacle_spawn_enabled = false
	game_started = false
	
func refresh():
	$DeathMusic.stop()
	$AudioStreamPlayer2D.play()
	refreshed = true
	obstacles_table = ObstaclesTable.new()
	var obstacles_children = $Obstacles.get_children()
	for child in obstacles_children:
		child.queue_free()
	$Player.position = Vector2(450, 450)
	$DeathMenu.hide()    
	
func _input(_event):
	if refreshed and not game_started and Input.is_action_just_pressed("Jump"):
		game_started = true
		$Player.set_physics_process(true)
		set_process(true)
		obstacle_spawn_enabled = true
		score = 0
		increase_score(0)
		obstacles_table.add_obstacle(simple_obstacle, 1.0)
		$DiffIncreaser.play("diff_increase")
