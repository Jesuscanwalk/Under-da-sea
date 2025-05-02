class_name Player extends CharacterBody2D

@onready var health_bar: ProgressBar = $Control/HealthBar
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@export var max_health := 5
@onready var animated_sprite: AnimatedSprite2D = $AnimationPlayer

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var health := max_health: set = set_health
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = health

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	var direction = Input.get_axis("left", "right")
	if direction > 0:
		animated_sprite.flip_h = true
	elif direction < 0:
		animated_sprite.flip_h = false
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
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
