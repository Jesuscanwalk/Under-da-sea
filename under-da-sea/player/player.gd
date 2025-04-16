class_name Player extends CharacterBody2D

@onready var health_bar: ProgressBar = $Control/HealthBar
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@export var max_health := 5
@onready var animated_sprite: AnimatedSprite2D = $AnimationPlayer

@export var SPEED : float = 130.0
@export var JUMP_VELOCITY : float = -5.0
@export var SWIM_GRAVITY : float = 0.25
@export var SWIM_VELOCITY : float = 80
@export var SWIM_JUMP : float = -150

var health := max_health: set = set_health
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_in_water : bool = false

func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = health

func _physics_process(delta):
	if not is_on_floor():
		if(!is_in_water):
			velocity.y += gravity * delta
			animated_sprite.play("jump")
		else:
			velocity.y = clampf(velocity.y + (gravity * delta * SWIM_GRAVITY), -10000, SWIM_VELOCITY)
			animated_sprite.play("swim")
	if Input.is_action_just_pressed("up"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		if is_in_water == true:
			velocity.y += SWIM_JUMP
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


func _on_water_detection_water_state_changed(is_in_water):
	self.is_in_water = is_in_water
	print("is in water")
