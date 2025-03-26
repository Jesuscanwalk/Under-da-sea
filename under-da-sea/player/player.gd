class_name Player extends CharacterBody2D

@onready var health_bar: ProgressBar = $Control/HealthBar
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@export var SPEED = 400.0
@export var max_health := 5

var health := max_health: set = set_health

func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = health

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right","up", "down")
	velocity = direction * SPEED
	move_and_slide()

func set_health(new_health: int) -> void:
	var previous_health := health
	health = clampi(new_health, 0, max_health)
	health_bar.value = health
	if health == 0:
		die()

func die() -> void:
	queue_free()
	collision_shape_2d.set_deferred("disabled", true)
	get_tree().change_scene_to_file("res://menus/end.tscn")
