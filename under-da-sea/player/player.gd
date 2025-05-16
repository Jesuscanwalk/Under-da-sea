class_name Player extends CharacterBody2D

signal health_changed
@onready var die_sound: AudioStreamPlayer2D = $DieSound
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimationPlayer
@onready var stamina = $Control/StaminaBar
@export var SPEED : float = 130.0
@export var JUMP_VELOCITY : float = -250
@export var SWIM_GRAVITY : float = 0.25
@export var SWIM_VELOCITY : float = 80
@export var SWIM_JUMP : float = -200
@export var max_health = 3
@onready var current_health: int = max_health

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_in_water : bool = false
var can_regen = false
var time_to_wait = 1.5 
var s_timer = 0
var can_start_stimer = true
func _ready() -> void:
	stamina.value = stamina.max_value

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
	handle_collision()
	if can_regen == false && stamina.value != 1000 or stamina.value == 0:
		can_start_stimer = true
		if can_start_stimer:
			s_timer += delta
			if s_timer >= time_to_wait:
				can_regen = true
				can_start_stimer = false
				s_timer = false
	if stamina.value == 1000:
		can_regen = false
	if can_regen == true:
		stamina.value += 0.5
		can_start_stimer = false
		s_timer = 0
	if is_in_water:
		stamina.value -= 0.55
		can_regen = false
		s_timer = 0
	if stamina.value == 0:
		die()
	if is_on_floor():
		can_regen = true
func die() -> void:
	queue_free()
	die_sound.play()
	collision_shape_2d.set_deferred("disabled", true)
	get_tree().change_scene_to_file("res://menus/end.tscn")

func handle_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

func _on_water_detection_water_state_changed(is_in_water):
	self.is_in_water = is_in_water
	print(is_in_water)

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.name == "HitBox":
		current_health -= 1
	if current_health == 0:
			die()
	health_changed.emit(current_health)
