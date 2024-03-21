extends CharacterBody2D

# player size is 150px 150px

@export var jump_height: float
@export var jump_time_to_peak: float
@export var jump_time_to_descent: float

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1
@onready var jump_gravity: float = ((-2 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
@onready var fall_gravity: float = ((-2 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1

signal player_dead
var delta_time: float

func _physics_process(delta):
	delta_time += delta
	velocity.y += fall_gravity * delta
	rotation += 0.003 * delta_time
	
	if Input.is_action_just_pressed("Jump"):
		$AudioStreamPlayer2D.play()
		$AnimationPlayer.play("jumpy")
		jump()
	
	move_and_slide()
	
func jump():
	velocity.y = jump_velocity
	
func _on_death_area_body_entered(_body):
	delta_time = 0.0
	player_dead.emit()
